#!/usr/bin/swift sh

import Foundation

import ArgumentParser  // apple/swift-argument-parser ~> 0.3.2
import FSEventsWrapper // @Frizlab                    ~> 1.0.0
import SwiftShell      // @kareman                    ~> 5.1.0



struct Main : ParsableCommand {
	
	@Argument(help: "The path to monitor")
	var path: String
	
	@Argument(help: "The command to run")
	var command: String
	
	private enum CodingKeys: CodingKey {
		case path
		case command
	}
	
	func run() throws {
		let callback = { (stream: FSEventStream, event: FSEvent) in
//			NSLog("Got FSEvent: %@", String(describing: event))
			dispatcher.dispatchCommand(command: command)
		}
		
		struct SimpleError : Error {var message: String}
		guard let w = FSEventStream(path: path, fsEventStreamFlags: FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents), callback: callback) else {
			throw SimpleError(message: "Cannot monitor the given path.")
		}
		w.startWatching()
		
		repeat {
			RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
		} while true
	}
	
	var dispatcher = Dispatcher()
	
	class Dispatcher {
		
		var isWaitingForDispatch = false
		
		func dispatchCommand(command: String) {
			guard !isWaitingForDispatch else {return}
			isWaitingForDispatch = true
			
			DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(250), execute: {
				DispatchQueue.main.sync{ self.isWaitingForDispatch = false }
				NSLog("Executing command: \(command)")
				do {
					try runAndPrint(bash: command)
					NSLog("Command completed successfully")
				} catch {
					NSLog("Command exited w/ error: \(error)")
				}
			})
		}
		
	}
	
}

Main.main()
