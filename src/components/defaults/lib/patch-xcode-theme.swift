#!/usr/bin/env swift

import Foundation



/* Let’s get the developer dir!
 * Our algo is:
 *    - If DEVELOPER_DIR env var is defined, use that;
 *    - Otherwise try and get the path w/ xcode-select.
 *
 * This method is adapted from xct’s `BuildSettings.getDeveloperDir()` method.
 *
 * Note: There are private APIs in libxcselect that allow retrieving the developer dir and whether it is an Xcode dev dir or not. */
public func getDeveloperDir() -> String? {
	if let p = getenv("DEVELOPER_DIR") {
		return String(cString: p)
	}
	
	let p = Process()
	/* If the executable does not exist, the app crashes w/ an unhandled exception.
	 * We assume /usr/bin/env will always exist. */
	p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
	p.arguments = ["/usr/bin/xcode-select", "-p"]
	
	p.standardInput = nil
	p.standardError = nil
	
	let pipe = Pipe()
	p.standardOutput = pipe
	
	p.launch()
	p.waitUntilExit()
	guard p.terminationReason == .exit, p.terminationStatus == 0 else {
		return nil
	}
	
	let outputData: Data?
	if #available(OSX 10.15.4, *) {
		outputData = try? pipe.fileHandleForReading.readToEnd()
	} else {
		/* Note: This can throw an (uncatchable objc) exception! */
		outputData = pipe.fileHandleForReading.readDataToEndOfFile()
	}
	
	guard let outputString = outputData.flatMap({ String(data: $0, encoding: .utf8) }), !outputString.isEmpty else {
		return nil
	}
	return outputString.trimmingCharacters(in: .whitespacesAndNewlines)
}


public struct FileHandleOutputStream : TextOutputStream {
	
	let fileHandle: FileHandle
	
	public func write(_ string: String) {
		fileHandle.write(Data(string.utf8))
	}
	
}

public var stdoutStream = FileHandleOutputStream(fileHandle: FileHandle.standardOutput)
public var stderrStream = FileHandleOutputStream(fileHandle: FileHandle.standardError)


public enum Action : String {
	
	case mono
	case smaller
	
}


guard CommandLine.arguments.count >= 2 else {
	print("usage: \(CommandLine.arguments[0]) source_relative_to_xcode_app [action1 ...]", to: &stderrStream)
	exit(1)
}

let relativeSourcePath = CommandLine.arguments[1]
let actions = CommandLine.arguments[2...].compactMap{ Action(rawValue: $0) }
guard actions.count == CommandLine.arguments.count - 2 else {
	print("got at least one invalid action", to: &stderrStream)
	exit(1)
}


guard let developerDir = getDeveloperDir() else {
	print("cannot get developer dir", to: &stderrStream)
	exit(2)
}


let sourceURL = URL(fileURLWithPath: developerDir).appendingPathComponent(relativeSourcePath, isDirectory: false)
guard let source = try? Data(contentsOf: sourceURL),
		let parsedUntypedSource = try? PropertyListSerialization.propertyList(from: source, options: [.mutableContainers], format: nil),
		let parsedSource = parsedUntypedSource as? [String: Any]
else {
	print("cannot read source file at path \(sourceURL.path)", to: &stderrStream)
	exit(3)
}

guard parsedSource["DVTFontAndColorVersion"] as? Int == 1 else {
	print("unknown font and color version; bailing", to: &stderrStream)
	exit(4)
}


let knownKeys = Set([
	"DVTFontAndColorVersion", "DVTLineSpacing",
	"DVTConsoleTextBackgroundColor", "DVTConsoleTextInsertionPointColor", "DVTConsoleTextSelectionColor",
	
	"DVTConsoleDebuggerInputTextFont",  "DVTConsoleDebuggerOutputTextFont",  "DVTConsoleDebuggerPromptTextFont",  "DVTConsoleExectuableInputTextFont",  "DVTConsoleExectuableOutputTextFont",
	"DVTConsoleDebuggerInputTextColor", "DVTConsoleDebuggerOutputTextColor", "DVTConsoleDebuggerPromptTextColor", "DVTConsoleExectuableInputTextColor", "DVTConsoleExectuableOutputTextColor",
	
	"DVTMarkupTextBackgroundColor", "DVTMarkupTextBorderColor",
	
	"DVTMarkupTextCodeFont", "DVTMarkupTextEmphasisFont",                                  "DVTMarkupTextLinkFont",  "DVTMarkupTextNormalFont",  "DVTMarkupTextOtherHeadingFont",  "DVTMarkupTextPrimaryHeadingFont",  "DVTMarkupTextSecondaryHeadingFont",  "DVTMarkupTextStrongFont",
	                         "DVTMarkupTextEmphasisColor", "DVTMarkupTextInlineCodeColor", "DVTMarkupTextLinkColor", "DVTMarkupTextNormalColor", "DVTMarkupTextOtherHeadingColor", "DVTMarkupTextPrimaryHeadingColor", "DVTMarkupTextSecondaryHeadingColor", "DVTMarkupTextStrongColor",
	
	"DVTScrollbarMarkerAnalyzerColor", "DVTScrollbarMarkerBreakpointColor", "DVTScrollbarMarkerDiffColor", "DVTScrollbarMarkerDiffConflictColor", "DVTScrollbarMarkerErrorColor", "DVTScrollbarMarkerRuntimeIssueColor", "DVTScrollbarMarkerWarningColor",
	"DVTSourceTextBackground", "DVTSourceTextBlockDimBackgroundColor", "DVTSourceTextCurrentLineHighlightColor", "DVTSourceTextInsertionPointColor", "DVTSourceTextInvisiblesColor", "DVTSourceTextSelectionColor",
	
	"DVTSourceTextSyntaxFonts",
	"DVTSourceTextSyntaxColors"
])
guard Set(parsedSource.keys) == knownKeys else {
	print("unknown or missing keys in source; bailing", to: &stderrStream)
	exit(5)
}

public func iterateAndModifyFonts(in source: inout [String: Any], _ transformer: (_ font: String) -> String?) throws {
	struct InternalError : Error {}
	for key in knownKeys.filter({ $0.hasSuffix("Font") }) {
		guard let v = source[key] as? String, let transformed = transformer(v) else {
			throw InternalError()
		}
		source[key] = transformed
	}
	guard let syntaxFonts = source["DVTSourceTextSyntaxFonts"] as? [String: String] else {
		throw InternalError()
	}
	var modifiedSyntaxFonts = [String: String]()
	for (key, val) in syntaxFonts {
		guard let transformed = transformer(val) else {
			throw InternalError()
		}
		modifiedSyntaxFonts[key] = transformed
	}
	source["DVTSourceTextSyntaxFonts"] = modifiedSyntaxFonts
}

let fontComponentsSeparator = " - "

var modifiedSource = parsedSource
for action in actions {
	switch action {
		case .mono:
			let fontTransformer = { (_ font: String) -> String? in
				let fontComponents = font.components(separatedBy: fontComponentsSeparator)
				guard fontComponents.count == 2 else {
					print("found font “\(font)” which is not exactly two components separated by “\(fontComponentsSeparator)”", to: &stderrStream)
					return nil
				}
				let transformedFont: String
				switch fontComponents[0] {
					case let v where v.hasPrefix("SFMono-"): transformedFont = v
					case "HelveticaNeue":                    transformedFont = "SFMono-Regular"
					case ".AppleSystemUIFont":               transformedFont = "SFMono-Regular"
					case ".AppleSystemUIFontBold":           transformedFont = "SFMono-Bold"
					case ".AppleSystemUIFontItalic":         transformedFont = "SFMono-Italic"
					default:
						print("found unknown font “\(font)” which I don’t know how to transform to mono", to: &stderrStream)
						return nil
				}
				return transformedFont + fontComponentsSeparator + fontComponents[1]
			}
			guard let _ = try? iterateAndModifyFonts(in: &modifiedSource, fontTransformer) else {
				print("failed to transform a font to smaller font; bailing", to: &stderrStream)
				exit(9)
			}
			
		case .smaller:
			let fontTransformer = { (_ font: String) -> String? in
				let fontComponents = font.components(separatedBy: fontComponentsSeparator)
				guard fontComponents.count == 2 else {
					print("found font “\(font)” which is not exactly two components separated by “\(fontComponentsSeparator)”", to: &stderrStream)
					return nil
				}
				guard let size = Float(fontComponents[1]) else {
					print("found font “\(font)” whose second component is not a Float", to: &stderrStream)
					return nil
				}
				return fontComponents[0] + fontComponentsSeparator + "\(size - 1)"
			}
			guard let _ = try? iterateAndModifyFonts(in: &modifiedSource, fontTransformer) else {
				print("failed to transform a font to smaller font; bailing", to: &stderrStream)
				exit(8)
			}
	}
	print("got action \(action)", to: &stderrStream)
}

guard let serialized = try? PropertyListSerialization.data(fromPropertyList: modifiedSource, format: .xml, options: 0) else {
	print("cannot re-serialize modified source; bailing", to: &stderrStream)
	exit(6)
}

guard let _ = try? FileHandle.standardOutput.write(contentsOf: serialized) else {
	print("cannot write modified source to stdout; bailing", to: &stderrStream)
	exit(7)
}



/*
 An annotated xccolortheme.
 I tried changing all the fonts and see what they are acting on.
 Some of them I did not find.
 
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>DVTFontAndColorVersion</key>
	<integer>1</integer>
	<key>DVTLineSpacing</key>
	<real>1.1000000238418579</real>
	
	<key>DVTConsoleTextBackgroundColor</key>
	<string>1 1 1 1</string>
	<key>DVTConsoleTextInsertionPointColor</key>
	<string>0 0 0 1</string>
	<key>DVTConsoleTextSelectionColor</key>
	<string>0.642038 0.802669 0.999195 1</string>
	
<!-- Font when typing in console on a breakpoint. -->
	<key>DVTConsoleDebuggerInputTextFont</key>
	<string>SFMono-Bold - 12.0</string>
<!-- Output from the debugger. -->
	<key>DVTConsoleDebuggerOutputTextFont</key>
	<string>SFMono-Medium - 12.0</string>
<!-- Debugger prompt. -->
	<key>DVTConsoleDebuggerPromptTextFont</key>
	<string>SFMono-Bold - 12.0</string>
<!-- Font when typing in console for running program (whether the program expects something or not). -->
	<key>DVTConsoleExectuableInputTextFont</key>
	<string>SFMono-Medium - 12.0</string>
<!-- Program output. -->
	<key>DVTConsoleExectuableOutputTextFont</key>
	<string>SFMono-Bold - 12.0</string>
	
	<key>DVTConsoleDebuggerInputTextColor</key>
	<string>0 0 0 1</string>
	<key>DVTConsoleDebuggerOutputTextColor</key>
	<string>0 0 0 1</string>
	<key>DVTConsoleDebuggerPromptTextColor</key>
	<string>0.317071 0.437736 1 1</string>
	<key>DVTConsoleExectuableInputTextColor</key>
	<string>0 0 0 1</string>
	<key>DVTConsoleExectuableOutputTextColor</key>
	<string>0 0 0 1</string>
	
	<key>DVTMarkupTextBackgroundColor</key>
	<string>0.96 0.96 0.96 1</string>
	<key>DVTMarkupTextBorderColor</key>
	<string>0.8832 0.8832 0.8832 1</string>
	
<!-- Unknown -->
	<key>DVTMarkupTextCodeFont</key>
	<string>SFMono-Regular - 10.0</string>
<!-- Unknown -->
	<key>DVTMarkupTextEmphasisFont</key>
	<string>.AppleSystemUIFontItalic - 10.0</string>
<!-- Unknown -->
	<key>DVTMarkupTextLinkFont</key>
	<string>.AppleSystemUIFont - 10.0</string>
<!-- Unknown -->
	<key>DVTMarkupTextNormalFont</key>
	<string>.AppleSystemUIFont - 10.0</string>
<!-- Unknown -->
	<key>DVTMarkupTextOtherHeadingFont</key>
	<string>.AppleSystemUIFont - 14.0</string>
<!-- Unknown -->
	<key>DVTMarkupTextPrimaryHeadingFont</key>
	<string>.AppleSystemUIFont - 24.0</string>
<!-- Unknown -->
	<key>DVTMarkupTextSecondaryHeadingFont</key>
	<string>.AppleSystemUIFont - 18.0</string>
<!-- Unknown -->
	<key>DVTMarkupTextStrongFont</key>
	<string>.AppleSystemUIFontBold - 10.0</string>
	
	<key>DVTMarkupTextEmphasisColor</key>
	<string>0 0 0 1</string>
	<key>DVTMarkupTextInlineCodeColor</key>
	<string>0 0 0 0.7</string>
	<key>DVTMarkupTextLinkColor</key>
	<string>0.055 0.055 1 1</string>
	<key>DVTMarkupTextNormalColor</key>
	<string>0 0 0 1</string>
	<key>DVTMarkupTextOtherHeadingColor</key>
	<string>0 0 0 0.5</string>
	<key>DVTMarkupTextPrimaryHeadingColor</key>
	<string>0 0 0 1</string>
	<key>DVTMarkupTextSecondaryHeadingColor</key>
	<string>0 0 0 1</string>
	<key>DVTMarkupTextStrongColor</key>
	<string>0 0 0 1</string>
	
	<key>DVTScrollbarMarkerAnalyzerColor</key>
	<string>0.403922 0.372549 1 1</string>
	<key>DVTScrollbarMarkerBreakpointColor</key>
	<string>0.290196 0.290196 0.968627 1</string>
	<key>DVTScrollbarMarkerDiffColor</key>
	<string>0.556863 0.556863 0.556863 1</string>
	<key>DVTScrollbarMarkerDiffConflictColor</key>
	<string>0.968627 0.290196 0.290196 1</string>
	<key>DVTScrollbarMarkerErrorColor</key>
	<string>0.968627 0.290196 0.290196 1</string>
	<key>DVTScrollbarMarkerRuntimeIssueColor</key>
	<string>0.643137 0.509804 1 1</string>
	<key>DVTScrollbarMarkerWarningColor</key>
	<string>0.937255 0.717647 0.34902 1</string>
	
	<key>DVTSourceTextBackground</key>
	<string>1 1 1 1</string>
	<key>DVTSourceTextBlockDimBackgroundColor</key>
	<string>0.424672 0.424672 0.424672 1</string>
	<key>DVTSourceTextCurrentLineHighlightColor</key>
	<string>0.909804 0.94902 1 1</string>
	<key>DVTSourceTextInsertionPointColor</key>
	<string>0 0 0 1</string>
	<key>DVTSourceTextInvisiblesColor</key>
	<string>0.8 0.8 0.8 1</string>
	<key>DVTSourceTextSelectionColor</key>
	<string>0.642038 0.802669 0.999195 1</string>
	
	<key>DVTSourceTextSyntaxFonts</key>
	<dict>
<!-- Unknown -->
		<key>xcode.syntax.attribute</key>
		<string>SFMono-Regular - 12.0</string>
<!-- A C character (e.g. 'a'). -->
		<key>xcode.syntax.character</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Regular comments -->
		<key>xcode.syntax.comment</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Doc comments -->
		<key>xcode.syntax.comment.doc</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Unknown -->
		<key>xcode.syntax.comment.doc.keyword</key>
		<string>SFMono-Bold - 12.0</string>
<!-- Variable (let ->bob<- = ...) -->
		<key>xcode.syntax.declaration.other</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Type declaration (class ->Bob<- { ... }) -->
		<key>xcode.syntax.declaration.type</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Not sure… Seems like user-defined classes or protocols. -->
		<key>xcode.syntax.identifier.class</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Not sure… Seems like system-defined classes or protocols. -->
		<key>xcode.syntax.identifier.class.system</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Not sure… Seems like the values from a user-defined enum. -->
		<key>xcode.syntax.identifier.constant</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Not sure… Seems like the values from a system-defined enum. -->
		<key>xcode.syntax.identifier.constant.system</key>
		<string>SFMono-Regular - 12.0</string>
<!-- User-defined function calls. -->
		<key>xcode.syntax.identifier.function</key>
		<string>SFMono-Regular - 12.0</string>
<!-- System-defined function calls. -->
		<key>xcode.syntax.identifier.function.system</key>
		<string>SFMono-Regular - 12.0</string>
<!-- User-defined macro (#define) usage. -->
		<key>xcode.syntax.identifier.macro</key>
		<string>SFMono-Regular - 12.0</string>
<!-- System-defined macro (#define) usage. -->
		<key>xcode.syntax.identifier.macro.system</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Not sure… Seems like user-defined structs and typealiases. -->
		<key>xcode.syntax.identifier.type</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Not sure… Seems like system-defined structs and typealiases. -->
		<key>xcode.syntax.identifier.type.system</key>
		<string>SFMono-Regular - 12.0</string>
<!-- User-defined variable usage. -->
		<key>xcode.syntax.identifier.variable</key>
		<string>SFMono-Regular - 12.0</string>
<!-- System-defined variable usage. -->
		<key>xcode.syntax.identifier.variable.system</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Keywords (import, while, etc.) -->
		<key>xcode.syntax.keyword</key>
		<string>SFMono-Semibold - 12.0</string>
<!-- “MARK: blah” in a comment. -->
		<key>xcode.syntax.mark</key>
		<string>SFMono-Bold - 12.0</string>
<!-- Unknown -->
		<key>xcode.syntax.markup.code</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Numbers. -->
		<key>xcode.syntax.number</key>
		<string>SFMono-Regular - 12.0</string>
<!-- “Normal” text. Includes md text. Relative text sizes in md (h1, h2, etc.) are relative to this value. -->
		<key>xcode.syntax.plain</key>
		<string>SFMono-Regular - 12.0</string>
<!-- #define -->
		<key>xcode.syntax.preprocessor</key>
		<string>SFMono-Regular - 12.0</string>
<!-- Strings (e.g. "blah" in Swift). -->
		<key>xcode.syntax.string</key>
		<string>SFMono-Regular - 12.0</string>
<!-- URLs in comments. -->
		<key>xcode.syntax.url</key>
		<string>SFMono-Regular - 12.0</string>
	</dict>
	<key>DVTSourceTextSyntaxColors</key>
	<dict>
		<key>xcode.syntax.attribute</key>
		<string>0.505801 0.371396 0.012096 1</string>
		<key>xcode.syntax.character</key>
		<string>0.11 0 0.81 1</string>
		<key>xcode.syntax.comment</key>
		<string>0.36526 0.421879 0.475154 1</string>
		<key>xcode.syntax.comment.doc</key>
		<string>0.36526 0.421879 0.475154 1</string>
		<key>xcode.syntax.comment.doc.keyword</key>
		<string>0.290196 0.333333 0.376471 1</string>
		<key>xcode.syntax.declaration.other</key>
		<string>0.0588235 0.407843 0.627451 1</string>
		<key>xcode.syntax.declaration.type</key>
		<string>0.0431373 0.309804 0.47451 1</string>
		<key>xcode.syntax.identifier.class</key>
		<string>0.109812 0.272761 0.288691 1</string>
		<key>xcode.syntax.identifier.class.system</key>
		<string>0.224543 0 0.628029 1</string>
		<key>xcode.syntax.identifier.constant</key>
		<string>0.194184 0.429349 0.454553 1</string>
		<key>xcode.syntax.identifier.constant.system</key>
		<string>0.421903 0.212783 0.663785 1</string>
		<key>xcode.syntax.identifier.function</key>
		<string>0.194184 0.429349 0.454553 1</string>
		<key>xcode.syntax.identifier.function.system</key>
		<string>0.421903 0.212783 0.663785 1</string>
		<key>xcode.syntax.identifier.macro</key>
		<string>0.391471 0.220311 0.124457 1</string>
		<key>xcode.syntax.identifier.macro.system</key>
		<string>0.391471 0.220311 0.124457 1</string>
		<key>xcode.syntax.identifier.type</key>
		<string>0.109812 0.272761 0.288691 1</string>
		<key>xcode.syntax.identifier.type.system</key>
		<string>0.224543 0 0.628029 1</string>
		<key>xcode.syntax.identifier.variable</key>
		<string>0.194184 0.429349 0.454553 1</string>
		<key>xcode.syntax.identifier.variable.system</key>
		<string>0.421903 0.212783 0.663785 1</string>
		<key>xcode.syntax.keyword</key>
		<string>0.607592 0.137526 0.576284 1</string>
		<key>xcode.syntax.mark</key>
		<string>0.290196 0.333333 0.376471 1</string>
		<key>xcode.syntax.markup.code</key>
		<string>0.665 0.052 0.569 1</string>
		<key>xcode.syntax.number</key>
		<string>0.11 0 0.81 1</string>
		<key>xcode.syntax.plain</key>
		<string>0 0 0 0.85</string>
		<key>xcode.syntax.preprocessor</key>
		<string>0.391471 0.220311 0.124457 1</string>
		<key>xcode.syntax.string</key>
		<string>0.77 0.102 0.086 1</string>
		<key>xcode.syntax.url</key>
		<string>0.055 0.055 1 1</string>
	</dict>
</dict>
</plist> */
