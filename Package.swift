// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SgRouter",
    products: [
        .library(name: "SgRouter", targets: ["SgRouter"]),
        .executable(name: "PerfTest", targets: ["PerfTest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gavrilaf/SwiftPerfTool.git", from: "0.0.2"),
    ],
    targets: [
        .target(name: "SgRouter", dependencies: []),
        .target(name: "PerfTest", dependencies: ["SgRouter", "SwiftPerfTool"], path: "Sources/Examples/PerfTest"),
        .testTarget(name: "SgRouterTests", dependencies: ["SgRouter"]),
    ]
)
