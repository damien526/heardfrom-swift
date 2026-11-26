// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HeardFrom",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [.library(name: "HeardFrom", targets: ["HeardFrom"])],
    targets: [
        .target(name: "HeardFrom"),
        .testTarget(name: "HeardFromTests", dependencies: ["HeardFrom"]),
    ]
)
