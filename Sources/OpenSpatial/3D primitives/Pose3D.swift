
// Pose3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A type that combines a position and orientation in 3D space.
@frozen
public struct Pose3D: Codable, Equatable, Hashable, Sendable {

    // MARK: - Stored properties

    /// The position of the pose.
    public var position: Point3D

    /// The rotation of the pose.
    public var rotation: Rotation3D

    // MARK: - Creating a Pose3D

    /// Creates a pose at the origin with identity rotation.
    @inline(__always)
    public init() {
        position = Point3D()
        rotation = Rotation3D()
    }

    /// Creates a pose with the specified position and rotation.
    ///
    /// - Parameters:
    ///   - position: The position of the pose.
    ///   - rotation: The rotation of the pose.
    @inline(__always)
    public init(position: Point3D, rotation: Rotation3D) {
        self.position = position
        self.rotation = rotation
    }

    /// Creates a pose at the origin with a rotation derived from the specified forward and up vectors.
    ///
    /// - Parameters:
    ///   - forward: The forward direction of the pose.
    ///   - up: The up direction of the pose.
    @inline(__always)
    public init(forward: Vector3D, up: Vector3D) {
        position = Point3D()
        rotation = Rotation3D(forward: forward, up: up)
    }

    // MARK: - Constants

    /// The identity pose: origin position and identity rotation.
    public static let identity = Pose3D()

    // MARK: - Inspecting characteristics

    /// A Boolean value that indicates whether the pose is the identity pose.
    public var isIdentity: Bool {
        position == .zero && rotation.isIdentity
    }

    /// Returns the inverse pose.
    public var inverse: Pose3D {
        let invRotation = rotation.inverse
        let invPosition = Point3D(invRotation.act(Vector3D(position) * -1.0))
        return Pose3D(position: invPosition, rotation: invRotation)
    }

    // MARK: - Transforming

    /// Returns a new pose with the specified affine transform applied.
    ///
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new transformed pose.
    /// - Complexity: O(1)
    public func applying(_ transform: AffineTransform3D) -> Pose3D {
        let newPosition = position.applying(transform)
        let newRotation = rotation.quaternion * transform.rotation.quaternion
        return Pose3D(position: newPosition, rotation: Rotation3D(quaternion: newRotation))
    }
}

extension Pose3D: Translatable3D {

    /// Returns a new pose translated by the specified vector.
    ///
    /// - Parameter vector: The translation vector.
    /// - Returns: A new translated pose.
    /// - Complexity: O(1)
    @inline(__always)
    public func translated(by vector: Vector3D) -> Pose3D {
        Pose3D(position: position.translated(by: vector), rotation: rotation)
    }
}

extension Pose3D: Rotatable3D {

    /// Returns a new pose rotated by the specified quaternion.
    ///
    /// - Parameter quaternion: The quaternion to apply.
    /// - Returns: A new rotated pose.
    /// - Complexity: O(1)
    @inline(__always)
    public func rotated(by quaternion: Quaternion3D) -> Pose3D {
        Pose3D(
            position: position, rotation: Rotation3D(quaternion: rotation.quaternion * quaternion))
    }
}

extension Pose3D: ProjectiveTransformable3D {

    /// Returns a transformed copy of the pose.
    ///
    /// - Parameter transform: A projective transform to apply.
    /// - Returns: The transformed pose.
    /// - Complexity: O(1)
    public func applying(_ transform: ProjectiveTransform3D) -> Pose3D {
        Pose3D(
            position: position.applying(transform),
            rotation: rotation.applying(transform)
        )
    }
}

extension Pose3D: CustomStringConvertible {

    /// A textual representation of the pose.
    public var description: String {
        "(position: \(position), rotation: \(rotation))"
    }
}
