### OpenSpatial
[![codecov](https://codecov.io/github/helbertgs/OpenSpatial/graph/badge.svg?token=7WrVJPx17w)](https://codecov.io/github/helbertgs/OpenSpatial)
![Language](https://img.shields.io/badge/Swift-6.1-orange.svg)
[![Swift](https://github.com/helbertgs/OpenSpatial/actions/workflows/swift.yml/badge.svg)](https://github.com/helbertgs/OpenSpatial/actions/workflows/swift.yml)

Open-source implementation of Apple's [Spatial](https://developer.apple.com/documentation/spatial) framework to Create and manipulate 3D mathematical primitives.

The main goal of this project is to provide a compatible, reliable and efficient implementation which can be used on Apple's operating systems before iOS 16.0, iPadOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, as well as Linux, Windows and WebAssembly.

### Installation
##### Swift Package Manager
To add `OpenSpatial` to your [SwiftPM](https://swift.org/package-manager/) package, add the `OpenSpatial` package to the list of package and target dependencies in your `Package.swift` file.

```swift
dependencies: [
    .package(url: "https://github.com/helbertgs/OpenSpatial.git", branch: "main")
],
targets: [
    .target(
        name: "MyAwesomePackage",
        dependencies: [
            .product(name: "OpenSpatial", package: "OpenSpatial")
        ]
    ),
]
```

###### Xcode
`OpenSpatial` can also be added as a SwiftPM dependency directly in your Xcode project *(requires Xcode 11 upwards)*.

To do so, open Xcode, use **File** → **Swift Packages** → **Add Package Dependency…**, enter the [repository URL](https://github.com/helbertgs/OpenSpatial.git), choose the latest available version, and activate the checkboxes:

<p align="center">
<img alt="Select the OpenSpatial target" 
	src="" width="70%">
</p>
