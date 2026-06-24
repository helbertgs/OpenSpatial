# OpenSpatial

![Swift](https://img.shields.io/badge/Swift-6.0%20%7C%206.1%20%7C%206.2%20%7C%206.3-orange.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux%20%7C%20Windows%20%7C%20Wasm%20%7C%20Android-blue)
[![Build and Test on MacOS](https://github.com/helbertgs/OpenSpatial/actions/workflows/MacOS.yml/badge.svg)](https://github.com/helbertgs/OpenSpatial/actions/workflows/MacOS.yml)
[![Build and Test on Ubuntu](https://github.com/helbertgs/OpenSpatial/actions/workflows/Linux.yml/badge.svg)](https://github.com/helbertgs/OpenSpatial/actions/workflows/Linux.yml)
[![Build and Test on Windows](https://github.com/helbertgs/OpenSpatial/actions/workflows/Windows.yml/badge.svg)](https://github.com/helbertgs/OpenSpatial/actions/workflows/Windows.yml)
[![codecov](https://codecov.io/github/helbertgs/OpenSpatial/graph/badge.svg?token=7WrVJPx17w)](https://codecov.io/github/helbertgs/OpenSpatial)
![License](https://img.shields.io/badge/license-MIT-green)

Open-source implementation inspired by Apple's [Spatial](https://developer.apple.com/documentation/spatial) framework.
`OpenSpatial` is not affiliated with, endorsed by, or maintained by Apple.

## Overview

The `OpenSpatial` module is a lightweight 3D mathematical library that provides a simple API for working with 3D primitives.
The API surface mirrors Apple's Spatial framework as closely as possible, so code written against `OpenSpatial` can be migrated to the official framework with minimal changes.

## Goals

OpenSpatial aims to:

- Provide a fully open-source implementation of common spatial mathematics primitives.
- Remain API-compatible with Apple's Spatial framework whenever practical.
- Support Apple and non-Apple platforms equally.
- Serve as a foundation for graphics, simulation, robotics, game development, and spatial computing projects.

## Features

- Pure Swift 6, no platform-specific dependencies
- Full `Sendable` conformance for safe use in Swift Concurrency contexts
- `Codable`, `Hashable`, and `Equatable` on all value types
- `@frozen` structs where applicable for ABI stability
- Generic arithmetic operators and protocol-driven design (`Rotatable3D`, `Translatable3D`, `Scalable3D`, …)

## Available Types

### 2D Primitives
| Type | Description |
|---|---|
| `Angle2D` | A geometric angle |

### 3D Primitives
| Type | Description |
|---|---|
| `Point3D` | A point in 3D space |
| `Size3D` | A 3D size with width, height, and depth |
| `Rect3D` | An axis-aligned 3D bounding box |
| `Pose3D` | A combined position and orientation |
| `ScaledPose3D` | A pose extended with a uniform scale factor |
| `Ray3D` | An origin and direction defining a ray |
| `Rotation3D` | A rotation in 3D space (quaternion-backed) |
| `RotationAxis3D` | A named axis for rotation |
| `Quaternion3D` | A quaternion for representing rotations |
| `SphericalCoordinates3D` | A point in spherical coordinates |

### Transforms
| Type | Description |
|---|---|
| `AffineTransform3D` | A 4×4 affine transform (translation, rotation, scale, shear) |
| `ProjectiveTransform3D` | A full 4×4 projective transform |

### Coordinate Spaces
| Type | Description |
|---|---|
| `CoordinateSpace3D` | A named 3D coordinate space |
| `CoordinateSpaceValue3D` | A value associated with a coordinate space |
| `WorldReferenceCoordinateSpace` | The world reference coordinate space |

### Data Structures & Protocols
| Type | Description |
|---|---|
| `Vector3D` | A 3D vector |
| `Axis3D` | A named axis (x, y, z) |
| `EulerAngles` | Euler angle representation of a rotation |
| `Primitive3D` | Protocol for all 3D primitives |
| `Rotatable3D` | Protocol for types that support rotation |
| `Translatable3D` | Protocol for types that support translation |
| `Scalable3D` | Protocol for types that support scaling |
| `Shearable3D` | Protocol for types that support shearing |
| `Clampable3D` | Protocol for types that can be clamped to a `Rect3D` |
| `Volumetric` | Protocol for types with a volumetric extent |

## Usage

### Working with Points

```swift
import OpenSpatial

let origin = Point3D(x: 0, y: 0, z: 0)
let target = Point3D(x: 3, y: 4, z: 0)

let distance = origin.distance(to: target)  // 5.0

let moved = origin.translated(by: Vector3D(x: 1, y: 2, z: 3))
let scaled = origin.uniformlyScaled(by: 2.0)
```

### Working with Rotations and Poses

```swift
let rotation = Rotation3D(angle: Angle2D(radians: .pi / 4), axis: RotationAxis3D(x: 0, y: 1, z: 0))
let pose = Pose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: rotation)

let rotatedPoint = Point3D(x: 1, y: 0, z: 0).rotated(by: rotation.quaternion)
let invertedPose = pose.inverse
```

### Applying Transforms

```swift
var transform = AffineTransform3D.identity
transform = transform.concatenating(.init(translation: Vector3D(x: 5, y: 0, z: 0)))

let transformedPoint = point.applying(transform)
```

### Raycasting

```swift
let ray = Ray3D(origin: Point3D(x: 0, y: 0, z: -1), direction: Vector3D(x: 0, y: 0, z: 1))
let box = Rect3D(origin: Point3D(x: -0.5, y: -0.5, z: 0), size: Size3D(width: 1, height: 1, depth: 1))

if ray.intersects(box) {
    print("Hit!")
}
```

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/helbertgs/OpenSpatial.git",
        from: "1.0.0"
    )
],
targets: [
    .target(
        name: "MyTarget",
        dependencies: [
            .product(name: "OpenSpatial", package: "OpenSpatial")
        ]
    ),
]
```

## Requirements

Minimum supported toolchain: Swift 6.0

## Supported Platforms

The project is continuously tested on:

- macOS
- Ubuntu Linux
- Windows

Additional support exists for:

- iOS
- tvOS
- watchOS
- WebAssembly (Wasm)
- Android

## Documentation

Full API documentation is generated with [DocC](https://www.swift.org/documentation/docc/) and available in the `docs/` folder and also in this link: [OpenSpatial](https://helbertgs.github.io/OpenSpatial/documentation/openspatial). You can also browse it locally by running:

```bash
swift package --disable-sandbox preview-documentation --target OpenSpatial
```

## Contributing

Contributions are welcome! Read [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide covering setup, code style, testing, commit conventions, and how to submit a pull request.

## License

OpenSpatial is released under the [MIT License](LICENSE).
