#!/usr/bin/env swift

import Foundation



public struct FileHandleOutputStream : TextOutputStream {
	
	let fileHandle: FileHandle
	
	public func write(_ string: String) {
		fileHandle.write(Data(string.utf8))
	}
	
}

public var stdoutStream = FileHandleOutputStream(fileHandle: FileHandle.standardOutput)
public var stderrStream = FileHandleOutputStream(fileHandle: FileHandle.standardError)

guard CommandLine.arguments.count == 3 else {
	print("usage: \(CommandLine.arguments[0]) safari_bundle_id toolbar_config_key", to: &stderrStream)
	print("failed")
	exit(1)
}

let safariDefaultsName = CommandLine.arguments[1]
let toolbarConfigKey = CommandLine.arguments[2]
let toolbarDefaultItemsKey = "TB Default Item Identifiers"

/* Get the path of the plist that should be modified by this script.
 * The “correct” way would be to use the undocumented `_CFPreferencesCopyApplicationMap` function that the `defaults` tool uses.
 * See https://gist.github.com/jessepeterson/a46562565affbe87789e and https://stackoverflow.com/a/20719428 */
guard let libURL = try? FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
	print("could not get the library path of the current user", to: &stderrStream)
	print("failed")
	exit(2)
}
let defaultsURL = libURL
	.appendingPathComponent("Containers").appendingPathComponent(safariDefaultsName)
	.appendingPathComponent("Data").appendingPathComponent("Library").appendingPathComponent("Preferences")
	.appendingPathComponent(safariDefaultsName).appendingPathExtension("plist")
/* Now get the UserDefaults instance and work on them. */
guard let ud = UserDefaults(suiteName: defaultsURL.path) else {
	print("could not get the user defaults for safari", to: &stderrStream)
	print("failed")
	exit(2)
}
guard let valuesO = ud.object(forKey: toolbarConfigKey) as? [String: Any]? else {
	print("unexpected type for the toolbar config (key = \(toolbarConfigKey))", to: &stderrStream)
	print("failed")
	exit(2)
}
var values = valuesO ?? [:]
guard let arrayO = values[toolbarDefaultItemsKey] as? [String]? else {
	print("unexpected type for key “\(toolbarDefaultItemsKey)”; bailing out.", to: &stderrStream)
	print("failed")
	exit(2)
}
let originalArray = arrayO ?? []
var array = originalArray
/* First we remove everything that does not look like an extension in the array. */
array = array.filter{ $0.contains(".") }
/* Then add expected entries for compact tab layout. */
array.insert(contentsOf: ["CombinedSidebarTabGroupToolbarIdentifier", "SidebarSeparatorToolbarItemIdentifier", "BackForwardToolbarIdentifier"], at: 0)
array.append(contentsOf: ["UnifiedTabBarToolbarIdentifier", "ShareToolbarIdentifier", "NewTabToolbarIdentifier"])
guard array != originalArray else {
	print("ok")
	exit(0)
}

values[toolbarDefaultItemsKey] = array
ud.set(values, forKey: toolbarConfigKey)
print("changed")
