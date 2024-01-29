#!/usr/bin/env -S swift-sh --
import Foundation
#if canImport(System)
import System
#else
import SystemPackage     /* @apple/swift-system                     ~> 1.0.0 */
#endif

import ArgumentParser    /* @apple/swift-argument-parser            ~> 1.3.0 */
import AsyncAlgorithms   /* @apple/swift-async-algorithms           ~> 1.0.0 */
import CLTLogger         /* @xcode-actions/clt-logger               ~> 0.8.0 */
import FSEventsWrapper   /* @Frizlab                                ~> 2.1.0 */
import Logging           /* @apple/swift-log                        ~> 1.5.3 */
import ProcessInvocation /* @xcode-actions/swift-process-invocation ~> 1.0.0-beta */



/* Let’s bootstrap the logger first and make it available globally. */
LoggingSystem.bootstrap { _ in CLTLogger() }
let logger: Logger = {
	var ret = Logger(label: "main")
	ret.logLevel = .info
	return ret
}()

ProcessInvocationConfig.logger = nil

_ = await Task{ await Main.main() }.value
struct Main : AsyncParsableCommand {
	
	@Option(name: .shortAndLong, help: #"The shell to use for running the script. The shell will be run like so:\#n   $shell -c "$command""#)
	var shell: String = "zsh"
	
	@Option(name: .shortAndLong, help: "The minimum interval of time that has to happen between two launches of the script.")
	var throttleMilliseconds: String = "zsh"
	
	@Argument(help: "The path to monitor.")
	var path: String
	
	@Argument(help: "The script to run.")
	var command: String
	
	func run() async throws {
		logger.info("Starting path observation.")
		let fsEventsStream = FSEventAsyncStream(path: path, flags: FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents))
		for await event in fsEventsStream._throttle(for: .milliseconds(250)) {
			logger.debug("Got new FSEvent.", metadata: ["event": "\(event)"])
			logger.info("Executing command.", metadata: ["date": "\(Date())"])
			do {
				_ = try await ProcessInvocation(FilePath(shell), "-c", command, stdoutRedirect: .none, stderrRedirect: .none).invokeAndGetRawOutput()
				logger.info("Command completed successfully.")
			} catch {
				logger.info("Command exited w/ error.", metadata: ["error": "\(error)"])
			}
		}
		
		/* If we reach this point, there has been an error setting up FSEvent. */
		throw SimpleError(message: "Cannot monitor the given path.")
	}
	
}


struct SimpleError : Error {
	var message: String
}
