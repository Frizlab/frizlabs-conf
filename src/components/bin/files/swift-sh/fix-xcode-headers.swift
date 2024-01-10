#!/usr/bin/swift sh
import Foundation

import ArgumentParser /* @apple/swift-argument-parser ~> 1.2.0 */
import CLTLogger      /* @xcode-actions/clt-logger    ~> 0.3.6 */
import Logging        /* @apple/swift-log             ~> 1.4.2 */



/* Let’s bootstrap the logger before anything else. */
LoggingSystem.bootstrap{ _ in CLTLogger() }
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
		
		/* Start your code here. */
		guard let e = fm.enumerator(at: URL(fileURLWithPath: "."), includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
			throw SimpleError(message: "cannot create directory iterator")
		}
		let magic = Data("//\n".utf8)
		while let currentURL = e.nextObject() as! URL? {
			guard currentURL.pathExtension == "swift" else {continue}
			
			let fh = try FileHandle(forReadingFrom: currentURL)
			let data = try fh.read(upToCount: magic.count)
			guard data == magic else {continue}
			
			logger.info("Rewriting file \(currentURL.path)")
			let fullData = try Data(contentsOf: currentURL)
			try Data(fullData[magic.count...]).write(to: currentURL)
		}
	}
	
}


struct SimpleError : Error {
	var message: String
}
