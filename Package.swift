// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SgRouter",
    products: [
        .library(name: "SgRouter", targets: ["SgRouter"]),
        .executable(name: "RouterPerfTest", targets: ["RouterPerfTest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gavrilaf/SwiftPerfTool.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "SgRouter", dependencies: []),
        .target(name: "RouterPerfTest", dependencies: ["SgRouter", "SwiftPerfTool"], path: "Sources/Examples/RouterPerfTest"),
        .testTarget(name: "SgRouterTests", dependencies: ["SgRouter"]),
    ]
)
