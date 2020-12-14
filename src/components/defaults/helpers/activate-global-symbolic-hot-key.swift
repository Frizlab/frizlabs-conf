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

guard CommandLine.arguments.count == 2 else {
	print("usage: \(CommandLine.arguments[0]) key_to_activate", to: &stderrStream)
	print("failed")
	exit(1)
}

let symbolicHotKeysDefaultsName = "com.apple.symbolichotkeys"
let symbolicHotKeysKey = "AppleSymbolicHotKeys"
let keyToActivate = CommandLine.arguments[1]

guard let ud = UserDefaults(suiteName: symbolicHotKeysDefaultsName) else {
	print("could not get the user defaults for the symbolic hot keys", to: &stderrStream)
	print("failed")
	exit(2)
}
guard var values = ud.object(forKey: symbolicHotKeysKey) as? [String: Any] else {
	print("could not get the symbolic hot keys values (key = \(symbolicHotKeysKey))", to: &stderrStream)
	print("failed")
	exit(2)
}
guard var dic = values[keyToActivate] as? [String: Any] else {
	print("could not get the symbolic hot key value for key \(keyToActivate)", to: &stderrStream)
	print("failed")
	exit(2)
}
let enabled: Bool
if let enabledFromDic = dic["enabled"] {
	guard let v = enabledFromDic as? Bool else {
		print("unexpected type for key “enabled”; bailing out.", to: &stderrStream)
		print("failed")
		exit(2)
	}
	enabled = v
} else {
	enabled = false
}
guard !enabled else {
	print("ok")
	exit(0)
}

dic["enabled"] = true
values[keyToActivate] = dic
ud.set(values, forKey: symbolicHotKeysKey)
print("changed")
