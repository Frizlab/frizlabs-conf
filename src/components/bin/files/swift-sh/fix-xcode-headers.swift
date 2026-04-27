#!/usr/bin/env -S swift-sh --
import Foundation

import SwiftSH_Helpers



/* Let’s bootstrap the logger before anything else. */
LoggingSystem.bootstrap(CLTLogger.init, metadataProvider: nil)
let logger: Logger = {
	var ret = Logger(label: "main")
	ret.logLevel = .info
	return ret
}()


/* Then call main. */
_ = await Task{ await FixSourceHeaders.main() }.value
struct FixSourceHeaders : AsyncParsableCommand {
	
	func run() throws {
		let fm = FileManager.default
		
		guard let e = fm.enumerator(at: URL(fileURLWithPath: "."), includingPropertiesForKeys: [.isRegularFileKey], options: .skipsHiddenFiles) else {
			throw MessageError("Cannot create directory iterator.")
		}
		while let currentURL = e.nextObject() as! URL? {
			do {
				guard let isRegularFile = (try? currentURL.resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile, isRegularFile else {
					continue
				}
				
				logger.trace("Starting file processing.", metadata: ["path": "\(currentURL.path(percentEncoded: false))"])
				let reader = try FileHandleReader(
					stream: FileHandle(forReadingFrom: currentURL),
					bufferSize: 3 * 1024 * 1024, /* 3 MiB */
					bufferSizeIncrement: 1 * 1024 * 1024, /* 1 MiB */
				)
				
				/* Find the start of the comment. */
				do {
					let commentLines: [String]
					switch try reader.skipWhiteUpToCommentStart() {
						case .star:  commentLines = try reader.readStarCommentContents()
						case .slash: commentLines = try reader.readSlashCommentContents()
						case nil:
							logger.debug("Skipping file does not start with a comment.", metadata: ["path": "\(currentURL.path(percentEncoded: false))"])
							continue
					}
					/* Let’s verify the comment contents look like a comment we want to get rid of. */
					guard commentLines.count == 6 || commentLines.count == 7,
							commentLines.first == "", commentLines.last == "",
							commentLines[3] == ""
					else {
						logger.debug("Skipping file which has a comment we probably don’t want to get rid of.", metadata: ["path": "\(currentURL.path(percentEncoded: false))"])
						continue
					}
				} catch ReadCommentError.commentContentsIsNotUTF8 {
					logger.warning("File has a non-utf8 comment.", metadata: ["path": "\(currentURL.path(percentEncoded: false))"])
					continue
				} catch ReadCommentError.embeddedComment {
					logger.warning("File starts with a star comment that has embedded comment(s) (or is malformed), which we do not support.", metadata: ["path": "\(currentURL.path(percentEncoded: false))"])
					continue
				} catch ReadCommentError.earlyEOF {
					logger.info("File starts with a star comment that does not end.", metadata: ["path": "\(currentURL.path(percentEncoded: false))"])
					continue
				}
				try reader.skipWhiteLines()
				logger.debug("Rewriting file.", metadata: ["path": "\(currentURL.path(percentEncoded: false))"])
				try reader.readDataToEnd().write(to: currentURL)
			} catch {
				logger.error("Failed processing file.", metadata: ["error": "\(error)", "path": "\(currentURL.path(percentEncoded: false))"])
			}
		}
	}
	
}


enum CommentStyle {
	case star
	case slash
}

/* These constants must either be defined _before_ calling the main, or be wrapped in something.
 * We decided to wrap them in an enum.
 * If we let these at the top-level after the call of main, the constants will be used before being initialized. */
enum Constants {
	
	static let whiteChars: Set<Character> = [" ", "\t", "\n"]
	static let whiteAscii = Set(whiteChars.map{ $0.asciiValue! })
	
	static let starCommentStart = Data("/*".utf8)
	static let starCommentEnd   = Data("*/".utf8)
	
	static let slashCommentStart = Data("//".utf8)
	
	/* Stream reader does not support negative delimiters, so we put all the possible ones here. */
	static let delimitersForCommentStart = Array(Set(UInt8.min...UInt8.max)
		.subtracting([Character("/").asciiValue!])
		.subtracting(whiteAscii)
	).map{ Data([$0]) } + [starCommentStart, slashCommentStart]
	
}

enum ReadCommentError : Error {
	case commentContentsIsNotUTF8
	/* Those two are for star comments only. */
	case embeddedComment
	case earlyEOF
}

extension StreamReader {
	
	func skipWhiteUpToCommentStart() throws -> CommentStyle? {
		let (length, commentStyle): (Int, CommentStyle?) = try readData(upTo: Constants.delimitersForCommentStart, matchingMode: .shortestDataWins, failIfNotFound: false, includeDelimiter: false, updateReadPosition: false, { data, delimiter in
			switch Data(delimiter) {
				case Constants .starCommentStart: return (data.count, .star)
				case Constants.slashCommentStart: return (data.count, .slash)
				default: return (0, nil)
			}
			return (0, nil)
		})
		guard let commentStyle else {
			return nil
		}
		_ = try readData(size: length, allowReadingLess: false, updateReadPosition: true, { _ in })
		return commentStyle
	}
	
	func readStarCommentContents() throws -> [String] {
		/* Read the start of the comment. */
		_ = try readData(size: 2, allowReadingLess: false, updateReadPosition: true, { _ in })
		/* Read the actual contents of the comment. */
		let ret = try readData(upTo: [Constants.starCommentEnd, Constants.starCommentStart], matchingMode: .shortestDataWins, failIfNotFound: false, includeDelimiter: false, updateReadPosition: true, { data, delimiter in
			switch delimiter {
				case Constants.starCommentEnd:
					guard let str = String(data: Data(data), encoding: .utf8) else {
						throw ReadCommentError.commentContentsIsNotUTF8
					}
					return str.split(separator: "\n", omittingEmptySubsequences: false).map{ line in
						line.trimmingCharacters(in: .whitespaces.union(CharacterSet(charactersIn: "*")))
					}
					
				case Constants.starCommentStart:
					/* That’s an embedded comment that we do not support. */
					throw ReadCommentError.embeddedComment
					
				case Data():
					/* We reached the end of the data but did not find the end of the comment. */
					throw ReadCommentError.earlyEOF
					
				default:
					/* No other case should be possible. */
					fatalError()
			}
		})
		/* Read the end of the comment. */
		_ = try readData(size: 2, allowReadingLess: false, updateReadPosition: true, { _ in })
		return ret
	}
	
	func readSlashCommentContents() throws -> [String] {
		var res: [String] = []
		while true {
			guard try peekData(size: 2, allowReadingLess: true) == Constants.slashCommentStart,
					let (line, _) = try readLine()
			else {
				break
			}
			guard let lineContent = String(data: line[2...], encoding: .utf8) else {
				throw ReadCommentError.commentContentsIsNotUTF8
			}
			res.append(lineContent.trimmingCharacters(in: .whitespaces))
		}
		return res
	}
	
	func skipWhiteLines() throws {
		let (isWhite, length) = try readData(upTo: [Data("\n".utf8)], matchingMode: .anyMatchWins, failIfNotFound: false, includeDelimiter: true, updateReadPosition: false, { line, delimiter in
			return (line.allSatisfy(Constants.whiteAscii.contains), line.count)
		})
		guard isWhite, length > 0 else {
			return
		}
		
		_ = try readData(size: length, allowReadingLess: false, updateReadPosition: true, { _ in })
		try skipWhiteLines()
	}
	
}
