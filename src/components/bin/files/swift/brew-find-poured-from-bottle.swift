#!/usr/bin/swift

import Foundation



struct PackageInfo : Decodable {
	struct InstalledInfo : Decodable {
		var pouredFromBottle: Bool
	}
	var fullName: String
	var installed: [InstalledInfo]
}


do {
	let installedPackages: [String]
	do {
		let p = Process()
		let outputPipe = Pipe()
		p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
		p.arguments = ["brew", "list"]
		p.standardOutput = outputPipe

		try p.run()

		let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
		let brewList = String(decoding: outputData, as: UTF8.self)
		installedPackages = brewList.split(separator: "\n").map(String.init)
	}

	guard installedPackages.count > 0 else {
		exit(0)
	}

	let packageInfos: [PackageInfo]
	do {
		let p = Process()
		let outputPipe = Pipe()
		p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
		p.arguments = ["brew", "info", "--json"] + installedPackages
		p.standardOutput = outputPipe

		try p.run()

		let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()

		let jsonDecoder = JSONDecoder()
		jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
		packageInfos = try jsonDecoder.decode([PackageInfo].self, from: outputData)
	}

	for p in packageInfos.filter({ $0.installed.first?.pouredFromBottle ?? false }) {
		print(p.fullName)
	}
} catch {
	print("Got an error: \(error)")
}
