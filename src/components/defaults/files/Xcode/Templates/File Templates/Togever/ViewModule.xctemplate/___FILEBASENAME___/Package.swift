// swift-tools-version:5.5
import PackageDescription


let package = Package(
	name: "___FILEBASENAME___",
	platforms: [.iOS(.v14)],
	products: [.library(name: "___FILEBASENAME___", targets: ["___FILEBASENAME___"])],
	dependencies: [
		.package(path: "../../Modules/CoordinatorProtocol")
	],
	targets: [
		.target(name: "___FILEBASENAME___", dependencies: [
			.product(name: "CoordinatorProtocol", package: "CoordinatorProtocol")
		]/*, swiftSettings: [
			.unsafeFlags(["-Xfrontend", "-warn-concurrency", "-Xfrontend", "-enable-actor-data-race-checks"])
		]*/)
	]
)
