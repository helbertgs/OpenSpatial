
// ScaledPose3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A structure that contains a position, rotation, and scale.
@frozen
public struct ScaledPose3D: Codable, Equatable, Hashable, Sendable {

    // MARK: - Stored properties

    /// The position
    public var position: Point3D

    /// The rotation
    public var rotation: Rotation3D

    /// The uniform scale
    public var scale: Double

    // MARK: - Creating a ScaledPose3D

    @inline(__always)
    public init() {
        self.position = .zero
        self.rotation = Rotation3D()
        self.scale = 1.0
    }

    /// Creates a  scaled pose from Spatial primitives that describe the position, rotation, and scale.
    ///
    /// - Parameter position: The position of the scaled pose.
    /// - Parameter rotation: The rotation of the pose.
    /// - Parameter scale: The uniform scale of the scaled pose.
    @inline(__always)
    public init(position: Point3D, rotation: Rotation3D, scale: Double) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
}

extension ScaledPose3D {

    /// Returns a new pose that's constructed by concatenating two existing poses.
    ///
    /// - Parameter lhs: The first value.
    /// - Parameter rhs: The second value.
    @inlinable public static func * (lhs: ScaledPose3D, rhs: Pose3D) -> ScaledPose3D {
        lhs.concatenating(rhs)
    }

    /// Returns a new scaled pose that's constructed by concatenating two existing poses.
    ///
    /// - Parameter lhs: The first value.
    /// - Parameter rhs: The second value.
    @inlinable public static func * (lhs: ScaledPose3D, rhs: ScaledPose3D) -> ScaledPose3D {
        lhs.concatenating(rhs)
    }

    /// Returns a new scaled pose that's constructed by concatenating a pose and a scaled pose.
    ///
    /// - Parameter lhs: The first value.
    /// - Parameter rhs: The second value.
    @inlinable public static func * (lhs: Pose3D, rhs: ScaledPose3D) -> ScaledPose3D {
        ScaledPose3D(position: lhs.position, rotation: lhs.rotation, scale: 1.0).concatenating(rhs)
    }

    /// Calculates the concatenation of scaled poses and stores the result in the left-hand-side variable.
    ///
    /// - Parameter lhs: The first value.
    /// - Parameter rhs: The second value.
    @inlinable public static func *= (lhs: inout ScaledPose3D, rhs: ScaledPose3D) {
        lhs = lhs * rhs
    }
}

extension ScaledPose3D {

    /// Creates a pose from double-precision simd primitives that describe the position, rotation, and scale.
    ///
    /// - Parameter position: The position of the scaled pose.
    /// - Parameter rotation: The rotation of the scaled pose.
    /// - Parameter scale: The uniform scale of the scaled pose.
    @inlinable public init(position: Point3D = .zero, rotation: Quaternion3D, scale: Double = 1) {
        self.position = position
        self.rotation = Rotation3D(quaternion: rotation)
        self.scale = scale
    }

    /// Creates a  scaled pose at the specified position that's oriented towards a look at target.
    ///
    /// - Parameter position: The position of the scaled pose.
    /// - Parameter target: The point that the scaled pose looks at.
    /// - Parameter scale: The uniform scale of the scaled pose.
    /// - Parameter up: The up direction.
    ///
    /// - note: This function creates a scaled pose where `+z` is forward.
    @inlinable public init(
        position: Point3D = .zero, target: Point3D, scale: Double = 1,
        up: Vector3D = Vector3D(x: 0, y: 1, z: 0)
    ) {
        self.position = position
        self.rotation = Rotation3D(position: position, target: target, up: up)
        self.scale = scale
    }

    /// Creates a scaled pose with the specified forward and up vectors.
    ///
    /// - Parameter forward: The forward direction.
    /// - Parameter scale: The uniform scale of the scaled pose.
    /// - Parameter up: The up direction.
    ///
    /// - note: This function creates a scaled pose where `+z` is forward.
    @inlinable public init(
        forward: Vector3D, scale: Double = 1, up: Vector3D = Vector3D(x: 0, y: 1, z: 0)
    ) {
        self.position = .zero
        self.rotation = Rotation3D(forward: forward, up: up)
        self.scale = scale
    }

    /// Creates a scaled pose with with a position, rotation, and scale that are defined by an affine transform.
    ///
    /// - Parameter transform: The source transform. The function only considers the transform's
    /// rotation and translation components.
    /// - Returns: A pose with a position, rotation, and scale that are defined by an affine transform.
    ///
    /// - note: This function can't extract rotation from a non-scale-rotate-translate affine transform. In that case,
    /// the function returns `nil`. If the specified  ``AffineTransform3D`` doesn't have uniform
    /// scale, the function returns `nil`.
    public init?(transform: AffineTransform3D) {
        self.init(transform.matrix)
    }

    /// Creates a pose with with a position, rotation, and scale that are defined by a projective transform.
    ///
    /// - Parameter transform: The source transform. The function only considers the transform's
    /// rotation and translation components.
    /// - Returns: A pose with a position, rotation, and scale that are defined by a projective transform.
    ///
    /// - note: This function can't extract rotation from a non-scale-rotate-translate affine transform. In that case,
    /// the function returns `nil`.  If the specified  ``ProjectiveTransform3D`` doesn't have uniform
    /// scale, the function returns `nil`.
    public init?(transform: ProjectiveTransform3D) {
        self.init(transform.matrix)
    }

    /// Creates a scaled pose with the specified double-precision 4 x 4 matrix
    ///
    /// - Parameter matrix: The source matrix
    ///
    /// - note: This function can't extract rotation from a non-scale-rotate-translate affine transform. In that case,
    /// the function returns `nil`.  If the specified matrix doesn't have uniform scale the function returns `nil`.
    public init?(_ matrix: [[Double]]) {
        guard let (position, rotation, scale) = decomposeSRT(matrix) else { return nil }
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }

    /// Creates a scaled pose with the specified single-precision 4 x 4 matrix
    ///
    /// - Parameter matrix: The source matrix
    ///
    /// - note: This function can't extract rotation from a non-scale-rotate-translate affine transform. In that case,
    /// the function returns `nil`. If the specified matrix doesn't have uniform scale the function returns `nil`.
    public init?(_ matrix: [[Float]]) {
        let doubleMatrix = matrix.map { $0.map { Double($0) } }
        self.init(doubleMatrix)
    }

    /// A 4 x 4 matrix that represents the scaled pose's scale, rotation, and translation.
    @inlinable public var matrix: [[Double]] {
        let q = rotation.quaternion
        let s = scale

        let m00 = s * (1 - 2 * (q.y * q.y + q.z * q.z))
        let m01 = s * 2 * (q.x * q.y + q.z * q.w)
        let m02 = s * 2 * (q.x * q.z - q.y * q.w)

        let m10 = s * 2 * (q.x * q.y - q.z * q.w)
        let m11 = s * (1 - 2 * (q.x * q.x + q.z * q.z))
        let m12 = s * 2 * (q.y * q.z + q.x * q.w)

        let m20 = s * 2 * (q.x * q.z + q.y * q.w)
        let m21 = s * 2 * (q.y * q.z - q.x * q.w)
        let m22 = s * (1 - 2 * (q.x * q.x + q.y * q.y))

        return [
            [m00, m01, m02, 0],
            [m10, m11, m12, 0],
            [m20, m21, m22, 0],
            [position.x, position.y, position.z, 1],
        ]
    }

    /// The inverse of the scaled pose's underlying matrix.
    @inlinable public var inverse: ScaledPose3D {
        let invScale = scale == 0 ? 0 : 1.0 / scale
        let invRotation = rotation.inverse
        let invPos = invRotation.act(Vector3D(position) * (-invScale))
        return ScaledPose3D(position: Point3D(invPos), rotation: invRotation, scale: invScale)
    }

    /// Returns a transform that's constructed by concatenating two existing scaled poses.
    ///
    /// - Parameter transform: The second scaled pose.
    @inlinable public func concatenating(_ transform: ScaledPose3D) -> ScaledPose3D {
        let newScale = scale * transform.scale
        let combinedRotation = Rotation3D(
            quaternion: rotation.quaternion * transform.rotation.quaternion)
        let newPosition = Point3D(
            rotation.act(Vector3D(transform.position) * scale) + Vector3D(position)
        )
        return ScaledPose3D(position: newPosition, rotation: combinedRotation, scale: newScale)
    }

    /// Returns a transform that's constructed by concatenating two a scaled pose and a pose.
    ///
    /// - Parameter transform: The second pose.
    @inlinable public func concatenating(_ transform: Pose3D) -> ScaledPose3D {
        let rhs = ScaledPose3D(
            position: transform.position, rotation: transform.rotation, scale: 1.0)
        return concatenating(rhs)
    }

    /// The identity scaled pose.
    @inlinable public static var identity: ScaledPose3D {
        ScaledPose3D()
    }

    /// Returns the scaled pose flipped along the specified axis.
    ///
    /// - Parameter axis: The axis of the flip operation.
    /// - Complexity: O(1)
    @inlinable public func flipped(along axis: Axis3D) -> ScaledPose3D {
        var p = position
        if axis.contains(.x) { p.x = -p.x }
        if axis.contains(.y) { p.y = -p.y }
        if axis.contains(.z) { p.z = -p.z }
        return ScaledPose3D(position: p, rotation: rotation, scale: scale)
    }

    /// Flips the scaled pose along the specified axis.
    ///
    /// - Parameter axis: The axis of the flip operation.
    public mutating func flip(along axis: Axis3D) {
        self = flipped(along: axis)
    }
}

extension ScaledPose3D: Translatable3D {

    /// Returns the entity translated by the specified vector.
    ///
    /// - Parameter vector: The vector that defines that translation.
    /// - Complexity: O(1)
    @inlinable public func translated(by offset: Vector3D) -> ScaledPose3D {
        ScaledPose3D(position: position + offset, rotation: rotation, scale: scale)
    }
}

extension ScaledPose3D: Rotatable3D {

    /// Returns a pose with a rotation that's rotated by the specified rotation.
    ///
    /// - Parameter rotation: The rotation.
    /// - Returns A scaled pose with a rotation that's rotated by the specified rotation.
    /// - Complexity: O(1)
    @inlinable public func rotated(by rotation: Rotation3D) -> ScaledPose3D {
        ScaledPose3D(
            position: position,
            rotation: Rotation3D(quaternion: self.rotation.quaternion * rotation.quaternion),
            scale: scale
        )
    }

    /// Returns a scaled pose with a rotation that's rotated by the specified quaternion.
    ///
    /// - Parameter quaternion: The quaternion that defines the rotation.
    /// - Returns A scaled pose with a rotation that's rotated by the specified quaternion.
    /// - Complexity: O(1)
    @inlinable public func rotated(by quaternion: Quaternion3D) -> ScaledPose3D {
        ScaledPose3D(
            position: position,
            rotation: Rotation3D(quaternion: rotation.quaternion * quaternion),
            scale: scale
        )
    }
}

extension ScaledPose3D {

    /// Returns a Boolean value that indicates whether two scaled poses are equal within a specified tolerance.
    ///
    /// - Parameter other: The second  scaled pose.
    /// - Parameter tolerance: The tolerance of the comparison.
    /// - Complexity: O(1)
    @inlinable public func isApproximatelyEqual(
        to other: ScaledPose3D, tolerance: Double = sqrt(.ulpOfOne)
    ) -> Bool {
        let q1 = rotation.quaternion
        let q2 = other.rotation.quaternion
        let quatApprox =
            (abs(q1.x - q2.x) <= tolerance && abs(q1.y - q2.y) <= tolerance
                && abs(q1.z - q2.z) <= tolerance && abs(q1.w - q2.w) <= tolerance)
            || (abs(q1.x + q2.x) <= tolerance && abs(q1.y + q2.y) <= tolerance
                && abs(q1.z + q2.z) <= tolerance && abs(q1.w + q2.w) <= tolerance)
        return position.isApproximatelyEqual(to: other.position, tolerance: tolerance) && quatApprox
            && abs(scale - other.scale) <= tolerance
    }

    /// Returns true if the scaled pose is the identity pose.
    @inlinable public var isIdentity: Bool {
        position == .zero && rotation.isIdentity && scale == 1.0
    }
}

extension ScaledPose3D: CustomStringConvertible {

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
        "(position: \(position), rotation: \(rotation), scale: \(scale))"
    }
}

// MARK: - Private helpers

/// Decomposes a 4×4 column-major SRT matrix into position, rotation, and uniform scale.
/// Returns nil if the matrix doesn't represent a uniform-scale SRT transform.
internal func decomposeSRT(_ m: [[Double]]) -> (
    position: Point3D, rotation: Rotation3D, scale: Double
)? {
    guard m.count == 4 && m.allSatisfy({ $0.count == 4 }) else { return nil }

    let col0 = Vector3D(x: m[0][0], y: m[0][1], z: m[0][2])
    let col1 = Vector3D(x: m[1][0], y: m[1][1], z: m[1][2])
    let col2 = Vector3D(x: m[2][0], y: m[2][1], z: m[2][2])

    let sx = col0.length
    let sy = col1.length
    let sz = col2.length

    let tolerance = Foundation.sqrt(.ulpOfOne)
    guard abs(sx - sy) <= tolerance && abs(sy - sz) <= tolerance else { return nil }

    let scale = (sx + sy + sz) / 3.0

    guard scale > 0 else { return nil }

    let invScale = 1.0 / scale
    let rotMatrix = [
        [col0.x * invScale, col0.y * invScale, col0.z * invScale, 0.0],
        [col1.x * invScale, col1.y * invScale, col1.z * invScale, 0.0],
        [col2.x * invScale, col2.y * invScale, col2.z * invScale, 0.0],
        [0.0, 0.0, 0.0, 1.0],
    ]

    let trace = rotMatrix[0][0] + rotMatrix[1][1] + rotMatrix[2][2]
    let q: Quaternion3D
    if trace > 0 {
        let s = 0.5 / Foundation.sqrt(trace + 1.0)
        q = Quaternion3D(
            x: (rotMatrix[1][2] - rotMatrix[2][1]) * s,
            y: (rotMatrix[2][0] - rotMatrix[0][2]) * s,
            z: (rotMatrix[0][1] - rotMatrix[1][0]) * s,
            w: 0.25 / s
        )
    } else if rotMatrix[0][0] > rotMatrix[1][1] && rotMatrix[0][0] > rotMatrix[2][2] {
        let s = 2.0 * Foundation.sqrt(1.0 + rotMatrix[0][0] - rotMatrix[1][1] - rotMatrix[2][2])
        q = Quaternion3D(
            x: 0.25 * s,
            y: (rotMatrix[0][1] + rotMatrix[1][0]) / s,
            z: (rotMatrix[2][0] + rotMatrix[0][2]) / s,
            w: (rotMatrix[1][2] - rotMatrix[2][1]) / s
        )
    } else if rotMatrix[1][1] > rotMatrix[2][2] {
        let s = 2.0 * Foundation.sqrt(1.0 + rotMatrix[1][1] - rotMatrix[0][0] - rotMatrix[2][2])
        q = Quaternion3D(
            x: (rotMatrix[0][1] + rotMatrix[1][0]) / s,
            y: 0.25 * s,
            z: (rotMatrix[1][2] + rotMatrix[2][1]) / s,
            w: (rotMatrix[2][0] - rotMatrix[0][2]) / s
        )
    } else {
        let s = 2.0 * Foundation.sqrt(1.0 + rotMatrix[2][2] - rotMatrix[0][0] - rotMatrix[1][1])
        q = Quaternion3D(
            x: (rotMatrix[2][0] + rotMatrix[0][2]) / s,
            y: (rotMatrix[1][2] + rotMatrix[2][1]) / s,
            z: 0.25 * s,
            w: (rotMatrix[0][1] - rotMatrix[1][0]) / s
        )
    }

    let position = Point3D(x: m[3][0], y: m[3][1], z: m[3][2])
    let rotation = Rotation3D(quaternion: q)
    return (position, rotation, scale)
}
