#!/usr/bin/env -S swift-sh --
import Foundation

import ArgumentParser    /* @apple/swift-argument-parser            ~> 1.3.0 */
import AsyncAlgorithms   /* @apple/swift-async-algorithms           ~> 1.0.0 */
import CLTLogger         /* @xcode-actions/clt-logger               ~> 1.0.0-rc */
import FSEventsWrapper   /* @Frizlab                                ~> 2.1.0 */
import Logging           /* @apple/swift-log                        ~> 1.5.3 */
import ProcessInvocation /* @xcode-actions/swift-process-invocation ~> 1.0.0-beta.5 */
import SystemPackage     /* @apple/swift-system                     ~> 1.0.0 */



/* Let’s bootstrap the logger first and make it available globally. */
LoggingSystem.bootstrap(CLTLogger.init, metadataProvider: nil)
let logger: Logger = {
	var ret = Logger(label: "main")
	ret.logLevel = .notice
	return ret
}()

ProcessInvocationConfig.logger = nil

_ = await Task{ await RunOnChange.main() }.value
struct RunOnChange : AsyncParsableCommand {
	
	@Option(name: .shortAndLong, help: #"The shell to use for running the script. The shell will be run like so:\#n   $shell -c "$command""#)
	var shell: String = "zsh"
	
	@Option(name: .shortAndLong, help: "The minimum interval of time that has to happen between two launches of the script.")
	var throttleMilliseconds: Double = 250
	
	@Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Whether to start the command once before monitoring the given path.")
	var startCommandOnLaunch: Bool = true
	
	@Argument(help: "The path to monitor.")
	var path: String
	
	@Argument(help: "The script to run.")
	var command: String
	
	func run() async throws {
		let runningState = RunningState()
		
		if startCommandOnLaunch {
			Task{ await runCommand(runningState: runningState) }
		}
		
		logger.info("Starting path observation.")
		let fsEventsStream = FSEventAsyncStream(path: path, flags: FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents))
		for await event in fsEventsStream._throttle(for: .milliseconds(throttleMilliseconds)) {
			logger.debug("Got new FSEvent.", metadata: ["event": "\(event)"])
			Task{ await runCommand(runningState: runningState) }
		}
		
		/* If we reach this point, there has been an error setting up FSEvent. */
		throw SimpleError(message: "Cannot monitor the given path.")
	}
	
	func runCommand(runningState: RunningState) async {
		guard await runningState.switchToRunningNow() else {
			logger.debug("Deferring command execution due to previous command still running.", metadata: ["date": "\(Date())"])
			await runningState.needsRunningNext()
			return
		}
		
		do {
			logger.info("Executing command.", metadata: ["date": "\(Date())"])
			_ = try await ProcessInvocation(FilePath(shell), "-c", command, stdinRedirect: .none(setFgPgID: true), stdoutRedirect: .none, stderrRedirect: .none).invokeAndGetRawOutput()
			logger.info("Command completed successfully.")
		} catch {
			logger.info("Command exited w/ error.", metadata: ["error": "\(error)"])
		}
		
		let runningNow = await runningState.runningNow
		assert(runningNow)
		
		if await runningState.finishRunning() {
			await runCommand(runningState: runningState)
		}
	}
	
	actor RunningState {
		
		var runningNow: Bool = false
		var runningNext: Bool = false
		
		func switchToRunningNow() -> Bool {
			let wasRunning = runningNow
			runningNow = true
			return !wasRunning
		}
		
		func finishRunning() -> Bool {
			let needsRunningNext = runningNext
			runningNow = false
			runningNext = false
			return needsRunningNext
		}
		
		func needsRunningNext() {
			runningNext = true
		}
		
	}
	
}


struct SimpleError : Error {
	var message: String
}
