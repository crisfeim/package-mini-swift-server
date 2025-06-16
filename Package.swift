// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "MiniSwiftServer",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(
            name: "MiniSwiftServer",
            targets: ["MiniSwiftServer"]
        ),
    ],
    targets: [
        .target(
            name: "MiniSwiftServer"
        ),
    ]
)
