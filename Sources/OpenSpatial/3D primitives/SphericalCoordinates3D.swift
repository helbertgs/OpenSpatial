
// SphericalCoordinates3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A position in 3D space expressed in spherical coordinates.
///
/// The coordinate system uses:
/// - `radius`: distance from the origin
/// - `inclination`: polar angle from the +y axis, in the range `0…π`
/// - `azimuth`: azimuthal angle in the xz-plane from +x, in the range `-π…π`
@frozen
public struct SphericalCoordinates3D: Codable, Equatable, Hashable, Sendable {

    // MARK: - Stored properties

    /// The radial distance from the origin.
    public var radius: Double

    /// The polar angle measured from the +y axis, in the range `0…π`.
    public var inclination: Angle2D

    /// The azimuthal angle in the xz-plane measured from +x, in the range `-π…π`.
    public var azimuth: Angle2D

    // MARK: - Creating SphericalCoordinates3D

    /// Creates a spherical coordinate with the specified components.
    ///
    /// - Parameters:
    ///   - radius: The radial distance from the origin.
    ///   - inclination: The polar angle from the +y axis.
    ///   - azimuth: The azimuthal angle from +x in the xz-plane.
    public init(radius: Double, inclination: Angle2D, azimuth: Angle2D) {
        self.radius = radius
        self.inclination = inclination
        self.azimuth = azimuth
    }

    /// Creates a spherical coordinate from a Cartesian point.
    ///
    /// - Parameter point: The Cartesian point to convert.
    @inline(__always)
    public init(_ point: Point3D) {
        let r = Foundation.sqrt(point.x * point.x + point.y * point.y + point.z * point.z)
        self.radius = r
        if r == 0 {
            self.inclination = Angle2D(radians: 0)
            self.azimuth = Angle2D(radians: 0)
        } else {
            self.inclination = Angle2D(radians: Foundation.acos(point.y / r))
            self.azimuth = Angle2D(radians: Foundation.atan2(point.z, point.x))
        }
    }

    // MARK: - Converting to Cartesian

    /// The Cartesian representation of this spherical coordinate.
    public var point: Point3D {
        let sinInc = Foundation.sin(inclination.radians)
        let cosInc = Foundation.cos(inclination.radians)
        let sinAz = Foundation.sin(azimuth.radians)
        let cosAz = Foundation.cos(azimuth.radians)
        return Point3D(
            x: radius * sinInc * cosAz,
            y: radius * cosInc,
            z: radius * sinInc * sinAz
        )
    }

    // MARK: - Approximate equality

    /// Returns a Boolean value that indicates whether this coordinate is approximately
    /// equal to another within a specified tolerance.
    ///
    /// - Parameters:
    ///   - other: The coordinate to compare.
    ///   - tolerance: The maximum allowed difference per component.
    /// - Returns: `true` if all components are within tolerance.
    /// - Complexity: O(1)
    public func isApproximatelyEqual(
        to other: SphericalCoordinates3D, tolerance: Double = Foundation.sqrt(.ulpOfOne)
    ) -> Bool {
        Swift.abs(radius - other.radius) <= tolerance
            && inclination.isApproximatelyEqual(to: other.inclination, tolerance: tolerance)
            && azimuth.isApproximatelyEqual(to: other.azimuth, tolerance: tolerance)
    }
}

extension SphericalCoordinates3D: CustomStringConvertible {

    /// A textual representation of the spherical coordinate.
    public var description: String {
        "(radius: \(radius), inclination: \(inclination.radians), azimuth: \(azimuth.radians))"
    }
}
