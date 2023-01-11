// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Concurrency",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v11),
    ],
    products: [
        .library(name: "Concurrency", targets: ["Concurrency"]),
        .library(name: "TestConcurrency", targets: ["TestConcurrency"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Concurrency", dependencies: []),
        .target(name: "TestConcurrency", dependencies: ["Concurrency"]),
        .testTarget(name: "ConcurrencyTests", dependencies: ["Concurrency"]),
    ]
)
