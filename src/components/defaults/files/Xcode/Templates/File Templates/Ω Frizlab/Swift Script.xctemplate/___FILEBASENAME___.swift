#!/usr/bin/swift sh

import Foundation

import ArgumentParser // apple/swift-argument-parser ~> 1.1.2
import CLTLogger      // xcode-actions/clt-logger    ~> 0.3.6
import Logging        // apple/swift-log             ~> 1.4.2



/* Let’s bootstrap the logger before anything else. */
LoggingSystem.bootstrap{ _ in CLTLogger() }
let logger: Logger = {
	var ret = Logger(label: "main")
	ret.logLevel = .info
	return ret
}()

/* Then call main. */
___VARIABLE_mainCommandName:identifier___.main()


struct ___VARIABLE_mainCommandName:identifier___ : ParsableCommand {
	
	func run() throws {
		/* swift-sh creates a binary whose path is not one we expect, so we cannot use main.path directly.
		 * Using the _ env variable is **extremely** hacky, but seems to do the job…
		 * See https://github.com/mxcl/swift-sh/issues/101 */
		let fm = FileManager.default
		let filepath = ProcessInfo.processInfo.environment["_"] ?? fm.currentDirectoryPath
		fm.changeCurrentDirectoryPath(URL(fileURLWithPath: filepath).deletingLastPathComponent().appendingPathComponent("..").path)
		
		/* Start your code here. */
	}
	
}


struct SimpleError : Error {
	var message: String
}
