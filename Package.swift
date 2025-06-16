// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mini-swift-server",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(
            name: "MiniSwiftServer",
            targets: ["mini-swift-server"]
        ),
    ],
    targets: [
        .target(
            name: "mini-swift-server"),
    ]
)
