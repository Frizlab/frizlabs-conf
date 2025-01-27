#!/usr/bin/env -S swift-sh --
import Foundation

import ArgumentParser    /* @apple/swift-argument-parser            ~> 1.3.0 */
import CLTLogger         /* @xcode-actions/clt-logger               ~> 1.0.0-rc */
import Logging           /* @apple/swift-log                        ~> 1.5.3 */
import ProcessInvocation /* @xcode-actions/swift-process-invocation ~> 1.0.0-beta.3 */



/* Let’s bootstrap the logger first and make it available globally. */
LoggingSystem.bootstrap(CLTLogger.init, metadataProvider: nil)
let logger: Logger = {
	var ret = Logger(label: "main")
	ret.logLevel = .info
	return ret
}()


/* Then call main. */
_ = await Task{ await ___VARIABLE_mainCommandName:identifier___.main() }.value
struct ___VARIABLE_mainCommandName:identifier___ : AsyncParsableCommand {
	
	func run() async throws {
		let filepath = CommandLine.arguments.first ?? ""
		FileManager.default.changeCurrentDirectoryPath(URL(fileURLWithPath: filepath).deletingLastPathComponent().deletingLastPathComponent().path)
		
		/* Start your code here. */
		/* Here’s an example of calling a launching a subprocess and waiting for it to finish. */
//		_ = try await ProcessInvocation(
//			"bash", "-c", #"echo Hello world!"#,
//			stdoutRedirect: .none, stderrRedirect: .none
//		).invokeAndGetRawOutput()
	}
	
}


struct SimpleError : Error {
	var message: String
}
