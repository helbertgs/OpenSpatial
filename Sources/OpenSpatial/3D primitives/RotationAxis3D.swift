
// RotationAxis3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A 3D rotation axis.
@frozen
public struct RotationAxis3D: Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Creating a 3D rotation axis structure

    /// Creates a rotation axis.
    @inline(__always)
    public init() {
        self.init(x: 0, y: 0, z: 0)
    }

    /// Creates a rotation axis from the specified floating-point values.
    ///
    /// - Parameters:
    ///   - x: A floating-point value that specifies the x-coordinate value.
    ///   - y: A floating-point value that specifies the y-coordinate value.
    ///   - z: A floating-point value that specifies the z-coordinate value.
    @inline(__always)
    public init<T>(x: T, y: T, z: T) where T: BinaryFloatingPoint {
        self.init(x: Double(x), y: Double(y), z: Double(z))
    }

    /// Creates a rotation axis from the specified vector.
    ///
    /// - Parameter xyz: A Spatial vector that specifies the coordinates.
    @inline(__always)
    public init(_ xyz: Vector3D) {
        self.init(x: xyz.x, y: xyz.y, z: xyz.z)
    }

    /// Creates a rotation axis from the specified double-precision values.
    ///
    /// - Parameters:
    ///   - x: A double-precision value that specifies the x-coordinate value.
    ///   - y: A double-precision value that specifies the y-coordinate value.
    ///   - z: A double-precision value that specifies the z-coordinate value.
    @inline(__always)
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    // MARK: - Checking characteristics

    /// The x-coordinate value.
    public let x: Double

    /// The y-coordinate value.
    public let y: Double

    /// The z-coordinate value.
    public let z: Double

    /// A simd three-element vector that contains the x-, y-, and z-coordinate values.
    public var vector: [Double] { [x, y, z] }

    /// A Boolean value that indicates whether the rotation axis is zero.
    public var isZero: Bool { x == 0 && y == 0 && z == 0 }

    // MARK: - Constants

    /// The zero rotation axis.
    public static let zero = RotationAxis3D()

    /// The x-axis rotation axis.
    public static let x = RotationAxis3D(x: 1, y: 0, z: 0)

    /// The y-axis rotation axis.
    public static let y = RotationAxis3D(x: 0, y: 1, z: 0)

    /// The z-axis rotation axis.
    public static let z = RotationAxis3D(x: 0, y: 0, z: 1)

    static let xy = RotationAxis3D(x: 1, y: 1, z: 0)
    static let yz = RotationAxis3D(x: 0, y: 1, z: 1)
    static let xz = RotationAxis3D(x: 1, y: 0, z: 1)
    static let xyz = RotationAxis3D(x: 1, y: 1, z: 1)
}

extension RotationAxis3D {

    /// - Complexity: O(1)
    public func isApproximatelyEqual(
        to other: RotationAxis3D, tolerance: Double = Foundation.sqrt(.ulpOfOne)
    ) -> Bool {
        abs(x - other.x) <= tolerance && abs(y - other.y) <= tolerance
            && abs(z - other.z) <= tolerance
    }
}

extension RotationAxis3D: CustomStringConvertible {

    /// A textual representation of the rotation axis.
    public var description: String {
        return "(x: \(x), y: \(y), z: \(z))"
    }
}

extension RotationAxis3D: ExpressibleByArrayLiteral {

    /// Creates a rotation axis from the specified array literal.
    ///
    /// - Parameter elements: An array of double-precision values.
    @inline(__always)
    public init(arrayLiteral elements: Double...) {
        precondition(elements.count == 3, "Invalid array literal for \(Self.self)")
        self.init(x: elements[0], y: elements[1], z: elements[2])
    }
}
