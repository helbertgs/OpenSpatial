
// Ray3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A structure that contains the origin and direction of a 3D ray.
@frozen public struct Ray3D: Codable, Equatable, Hashable, Sendable {

    public init() {
        self.origin = .zero
        self.direction = .zero
    }

    /// The origin of the ray.
    public var origin: Point3D

    /// The direction of the ray.
    public var direction: Vector3D
}

extension Ray3D {

    /// Creates a ray from Spatial primitives that describe the origin and direction.
    ///
    /// - Parameter origin: The origin of the ray.
    /// - Parameter direction: The direction of the ray.
    /// - note: This function normalizes the direction vector.
    public init(origin: Point3D = .zero, direction: Vector3D) {
        self.origin = origin
        self.direction = direction.normalized
    }

    /// Returns `true` if the the ray intersects the specified rectangle.
    ///
    /// - Parameter rect: The second primitive.
    /// - Complexity: O(1)
    @inline(__always)
    public func intersects(_ rect: Rect3D) -> Bool {
        let invDirX = direction.x == 0 ? Double.infinity : 1.0 / direction.x
        let invDirY = direction.y == 0 ? Double.infinity : 1.0 / direction.y
        let invDirZ = direction.z == 0 ? Double.infinity : 1.0 / direction.z

        let tx1 = (rect.min.x - origin.x) * invDirX
        let tx2 = (rect.max.x - origin.x) * invDirX
        let ty1 = (rect.min.y - origin.y) * invDirY
        let ty2 = (rect.max.y - origin.y) * invDirY
        let tz1 = (rect.min.z - origin.z) * invDirZ
        let tz2 = (rect.max.z - origin.z) * invDirZ

        let tmin = Swift.max(
            Swift.max(Swift.min(tx1, tx2), Swift.min(ty1, ty2)), Swift.min(tz1, tz2))
        let tmax = Swift.min(
            Swift.min(Swift.max(tx1, tx2), Swift.max(ty1, ty2)), Swift.max(tz1, tz2))

        return tmax >= 0 && tmin <= tmax
    }

    /// Returns a ray that's transformed by the specified pose.
    ///
    /// - Parameter pose: The pose.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    /// This function rotates the ray's direction by the pose's rotation and offsets the ray's origin by the pose's position.
    public func applying(_ pose: Pose3D) -> Ray3D {
        let newOrigin = origin + Vector3D(pose.position)
        let newDirection = pose.rotation.act(direction)
        return Ray3D(origin: newOrigin, direction: newDirection)
    }

    /// Applies a pose.
    ///
    /// - Parameter pose: The pose.
    /// This function rotate's the ray's direction by the pose's rotation and sets the ray's origin to the pose's position.
    public mutating func apply(_ pose: Pose3D) {
        self = applying(pose)
    }
}

extension Ray3D {

    /// Returns a ray that's transformed by the inverse of the specified scaled pose.
    ///
    /// - Parameter pose: The scaled pose.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    /// This function rotates the ray's direction by the pose's rotation and offsets the ray's origin by the pose's position.
    public func unapplying(_ scaledPose: ScaledPose3D) -> Ray3D {
        applying(scaledPose.inverse)
    }

    /// Returns a ray that's transformed by the specified scaled pose.
    ///
    /// - Parameter pose: The scaled pose.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    /// This function rotates the ray's direction by the pose's rotation and offsets the ray's origin by the pose's position.
    public func applying(_ scaledPose: ScaledPose3D) -> Ray3D {
        let newOrigin =
            scaledPose.rotation.act(Vector3D(origin) * scaledPose.scale)
            + Vector3D(scaledPose.position)
        let newDirection = scaledPose.rotation.act(direction)
        return Ray3D(origin: Point3D(newOrigin), direction: newDirection)
    }
}

extension Ray3D: Primitive3D {

    /// Returns a ray that's transformed by the specified affine transform.
    ///
    /// - Parameter transform: The affine transform.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    ///
    /// This function applies the transform to the ray's origin and direction.
    public func applying(_ transform: AffineTransform3D) -> Ray3D {
        let newOrigin = origin.applying(transform)
        let newDirection = applyLinear(transform, to: direction)
        return Ray3D(origin: newOrigin, direction: newDirection)
    }

    /// Returns a ray that's transformed by the inverse of the specified affine transform.
    ///
    /// - Parameter transform: The affine transform.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    ///
    /// This function applies the transform to the ray's origin and direction.
    public func unapplying(_ transform: AffineTransform3D) -> Ray3D {
        guard let inv = transform.inverse else { return self }
        return applying(inv)
    }

    /// Returns a ray that's transformed by the specified projective transform.
    ///
    /// - Parameter transform: The projective transform.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    ///
    /// This function applies the transform to the ray's origin and direction.
    public func applying(_ transform: ProjectiveTransform3D) -> Ray3D {
        let newOrigin = origin.applying(transform)
        let newDirection = direction.applying(transform)
        return Ray3D(origin: newOrigin, direction: newDirection)
    }

    /// Returns a ray that's transformed by the inverse of the specified projective transform.
    ///
    /// - Parameter transform: The projective transform.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    ///
    /// This function applies the transform to the ray's origin and direction.
    public func unapplying(_ transform: ProjectiveTransform3D) -> Ray3D {
        guard let inv = transform.inverse else { return self }
        return applying(inv)
    }

    /// Returns a ray that's transformed by the inverse of the specified pose.
    ///
    /// - Parameter pose: The pose.
    /// - Returns The transformed ray.
    /// - Complexity: O(1)
    /// This function rotates the ray's direction by the pose's rotation and offsets the ray's origin by the pose's position.
    public func unapplying(_ pose: Pose3D) -> Ray3D {
        applying(pose.inverse)
    }

    /// Returns a ray that's rotated by the specified rotation around a specified pivot.
    ///
    /// - Parameter rotation: The rotation.
    /// - Parameter pivot: The center of rotation.
    /// - Complexity: O(1)
    public func rotated(by rotation: Rotation3D, around pivot: Point3D) -> Ray3D {
        rotated(by: rotation.quaternion, around: pivot)
    }

    /// Returns a ray that's rotated by the specified rotation around a specified pivot.
    ///
    /// - Parameter quaternion: The quaternion that defines the rotation.
    /// - Parameter pivot: The center of rotation.
    /// - Complexity: O(1)
    public func rotated(by quaternion: Quaternion3D, around pivot: Point3D) -> Ray3D {
        let offset = Vector3D(origin) - Vector3D(pivot)
        let rotatedOffset = offset.rotated(by: quaternion)
        let newOrigin = Point3D(rotatedOffset) + Vector3D(pivot)
        let newDirection = direction.rotated(by: quaternion)
        return Ray3D(origin: newOrigin, direction: newDirection)
    }

    /// A Boolean value that indicates whether all of the values of the ray are finite.
    public var isNaN: Bool {
        origin.isNaN || direction.isNaN
    }

    /// A Boolean value that indicates whether all of the values of the ray are finite.
    public var isFinite: Bool {
        origin.isFinite && direction.isFinite
    }

    /// A Boolean value that indicates whether all of the values of the ray are zero.
    public var isZero: Bool {
        origin.isZero && direction.isZero
    }

    /// A ray with all-zero values.
    public static var zero: Ray3D {
        Ray3D()
    }

    /// A ray with infinite origin and direction values.
    public static var infinity: Ray3D {
        Ray3D(origin: .infinity, direction: Vector3D(x: .infinity, y: .infinity, z: .infinity))
    }
}

extension Ray3D: Translatable3D {

    /// Returns a ray translated by the specified vector.
    ///
    /// - Parameter vector: The translation vector.
    /// - Complexity: O(1)
    public func translated(by vector: Vector3D) -> Ray3D {
        Ray3D(origin: origin + vector, direction: direction)
    }
}

extension Ray3D: Rotatable3D {

    /// Returns a ray that's rotated by the specified rotation.
    ///
    /// - Parameter rotation: The rotation.
    /// - Returns A ray with a direction that's rotated by the specified rotation.
    /// - Complexity: O(1)
    public func rotated(by rotation: Rotation3D) -> Ray3D {
        Ray3D(origin: origin, direction: rotation.act(direction))
    }

    /// Returns a ray that's rotated by the specified quaternion.
    ///
    /// - Parameter quaternion: The quaternion that defines the rotation.
    /// - Returns A ray with a direction that's rotated by the specified quaternion.
    /// - Complexity: O(1)
    public func rotated(by quaternion: Quaternion3D) -> Ray3D {
        Ray3D(origin: origin, direction: direction.rotated(by: quaternion))
    }
}

extension Ray3D: CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String {
        "(origin: \(origin), direction: \(direction))"
    }
}

// MARK: - Private helpers

private func applyLinear(_ transform: AffineTransform3D, to vector: Vector3D) -> Vector3D {
    let m = transform.matrix
    let x = vector.x * m[0][0] + vector.y * m[1][0] + vector.z * m[2][0]
    let y = vector.x * m[0][1] + vector.y * m[1][1] + vector.z * m[2][1]
    let z = vector.x * m[0][2] + vector.y * m[1][2] + vector.z * m[2][2]
    return Vector3D(x: x, y: y, z: z)
}
