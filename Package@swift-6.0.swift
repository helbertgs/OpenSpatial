// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenSpatial",
    products: [
        .library(
            name: "OpenSpatial",
            targets: ["OpenSpatial"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main"),
    ],
    targets: [
        .target(
            name: "OpenSpatial"
        ),
        .testTarget(
            name: "OpenSpatialTests",
            dependencies: ["OpenSpatial"]
        ),
    ]
)
