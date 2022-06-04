// swift-tools-version:5.5
import PackageDescription


let package = Package(
	name: "___VARIABLE_prefix______VARIABLE_productName___View",
	defaultLocalization: .init(rawValue: "en"),
	platforms: [.iOS(.v14)],
	products: [.library(name: "___VARIABLE_prefix______VARIABLE_productName___View", targets: ["___VARIABLE_prefix______VARIABLE_productName___View"])],
	dependencies: [
		.package(path: "../../Modules/CoordinatorProtocol")
	],
	targets: [
		.target(name: "___VARIABLE_prefix______VARIABLE_productName___View", dependencies: [
			.product(name: "CoordinatorProtocol", package: "CoordinatorProtocol")
		]/*, swiftSettings: [
			.unsafeFlags(["-Xfrontend", "-warn-concurrency", "-Xfrontend", "-enable-actor-data-race-checks"])
		]*/)
	]
)
