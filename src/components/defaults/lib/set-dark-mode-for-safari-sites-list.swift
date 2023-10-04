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

guard CommandLine.arguments.count >= 2 else {
	print("usage: \(CommandLine.arguments[0]) prefix site1 site2 site3 ...", to: &stderrStream)
	print("failed")
	exit(1)
}


let darkModeForSafariDefaultsName = "com.alexandrudenk.Dark-Mode-for-Safari.Extension"

/* Get the path of the plist that should be modified by this script.
 * The “correct” way would be to use the undocumented `_CFPreferencesCopyApplicationMap` function that the `defaults` tool uses.
 * See https://gist.github.com/jessepeterson/a46562565affbe87789e and https://stackoverflow.com/a/20719428 */
guard let libURL = try? FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
	print("could not get the library path of the current user", to: &stderrStream)
	print("failed")
	exit(2)
}
let defaultsURL = libURL
	.appendingPathComponent("Containers").appendingPathComponent(darkModeForSafariDefaultsName)
	.appendingPathComponent("Data").appendingPathComponent("Library").appendingPathComponent("Preferences")
	.appendingPathComponent(darkModeForSafariDefaultsName).appendingPathExtension("plist")
/* Now get the UserDefaults instance and work on them. */
guard let ud = UserDefaults(suiteName: defaultsURL.path) else {
	print("could not get the user defaults for Dark Mode for Safari", to: &stderrStream)
	print("failed")
	exit(2)
}

let defaultsAsDic = ud.dictionaryRepresentation()

let searchedPrefix = CommandLine.arguments[1]
let destPrefixedSites = Set(CommandLine.arguments[2...].map{ searchedPrefix + $0 })
let currentPrefixedSites = Set(defaultsAsDic.keys.filter{ $0.hasPrefix(searchedPrefix) })

for k in currentPrefixedSites {
	guard defaultsAsDic[k] as? Bool ?? false else {
		print("unexpected type or value for key “\(k)”; bailing out.", to: &stderrStream)
		print("failed")
		exit(3)
	}
}

guard currentPrefixedSites != destPrefixedSites else {
	print("ok")
	exit(0)
}

/* Adding missing sites. */
for k in destPrefixedSites.subtracting(currentPrefixedSites) {
	print("adding \(k)", to: &stderrStream)
	ud.set(true, forKey: k)
}
/* Removing sites that should not be there. */
for k in currentPrefixedSites.subtracting(destPrefixedSites) {
	print("removing \(k)", to: &stderrStream)
	ud.removeObject(forKey: k)
}

print("changed")
