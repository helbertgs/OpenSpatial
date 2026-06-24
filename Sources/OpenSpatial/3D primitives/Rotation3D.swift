
// Rotation3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A rotation in three dimensions.
@frozen
public struct Rotation3D: Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Storage

    private let _quaternion: Quaternion3D

    // MARK: - Creating a 3D rotation structure

    /// Creates an identity rotation.
    @inline(__always)
    public init() {
        _quaternion = Quaternion3D(x: 0, y: 0, z: 0, w: 1)
    }

    /// Creates a rotation structure with the specified Euler angles.
    ///
    /// - Parameter eulerAngles: A structure that specifies the order and values of the Euler angles.
    public init(eulerAngles: EulerAngles) {
        // Quaternion3D(eulerAngles:) uses full angles, not half angles, which gives wrong results.
        // Implement the standard half-angle Euler→quaternion conversion directly.
        let hx = eulerAngles.x.radians * 0.5
        let hy = eulerAngles.y.radians * 0.5
        let hz = eulerAngles.z.radians * 0.5
        let cx = Foundation.cos(hx)
        let sx = Foundation.sin(hx)
        let cy = Foundation.cos(hy)
        let sy = Foundation.sin(hy)
        let cz = Foundation.cos(hz)
        let sz = Foundation.sin(hz)
        switch eulerAngles.order {
        case .xyz:
            _quaternion = Quaternion3D(
                x: sx * cy * cz - cx * sy * sz,
                y: cx * sy * cz + sx * cy * sz,
                z: cx * cy * sz - sx * sy * cz,
                w: cx * cy * cz + sx * sy * sz
            )
        case .zxy:
            _quaternion = Quaternion3D(
                x: sx * cy * cz + cx * sy * sz,
                y: cx * sy * cz - sx * cy * sz,
                z: cx * cy * sz + sx * sy * cz,
                w: cx * cy * cz - sx * sy * sz
            )
        }
    }

    /// Creates a rotation structure with the specified quaternion.
    ///
    /// - Parameter quaternion: A quaternion that represents the rotation.
    @inline(__always)
    public init(quaternion: Quaternion3D) {
        _quaternion = quaternion.normalized
    }

    /// Creates a rotation structure with the specified axis and angle.
    ///
    /// - Parameter angle: The angle of the rotation.
    /// - Parameter axis: The axis of the rotation.
    @inline(__always)
    public init(angle: Angle2D, axis: RotationAxis3D) {
        _quaternion = Quaternion3D(angle: angle, axis: Vector3D(x: axis.x, y: axis.y, z: axis.z))
    }

    // MARK: - Look-at and forward initialisers

    /// Creates a rotation structure with the specified position, target, and up vector.
    ///
    /// - Parameter position: The position of the rotation.
    /// - Parameter target: The target of the rotation.
    /// - Parameter up: The up vector of the rotation.
    public init(position: Point3D, target: Point3D, up: Vector3D) {
        let forward = Vector3D(
            x: target.x - position.x,
            y: target.y - position.y,
            z: target.z - position.z
        ).normalized
        self.init(forward: forward, up: up)
    }

    /// Creates a rotation structure with the specified forward vector and default up vector (0, 1, 0).
    ///
    /// - Parameter forward: The forward vector of the rotation.
    public init(forward: Vector3D) {
        self.init(forward: forward, up: Vector3D(x: 0, y: 1, z: 0))
    }

    /// Creates a rotation structure with the specified forward and up vectors.
    ///
    /// - Parameter forward: The forward vector of the rotation.
    /// - Parameter up: The up vector of the rotation.
    public init(forward: Vector3D, up: Vector3D) {
        let f = forward.normalized
        let r = up.normalized.cross(f).normalized
        let u = f.cross(r)
        // Build quaternion from rotation matrix columns [right, up, forward]
        let trace = r.x + u.y + f.z
        let q: Quaternion3D
        if trace > 0 {
            let s = 0.5 / Foundation.sqrt(trace + 1.0)
            q = Quaternion3D(
                x: (u.z - f.y) * s, y: (f.x - r.z) * s, z: (r.y - u.x) * s, w: 0.25 / s)
        } else if r.x > u.y && r.x > f.z {
            let s = 2.0 * Foundation.sqrt(1.0 + r.x - u.y - f.z)
            q = Quaternion3D(
                x: 0.25 * s, y: (u.x + r.y) / s, z: (f.x + r.z) / s, w: (u.z - f.y) / s)
        } else if u.y > f.z {
            let s = 2.0 * Foundation.sqrt(1.0 + u.y - r.x - f.z)
            q = Quaternion3D(
                x: (u.x + r.y) / s, y: 0.25 * s, z: (f.y + u.z) / s, w: (f.x - r.z) / s)
        } else {
            let s = 2.0 * Foundation.sqrt(1.0 + f.z - r.x - u.y)
            q = Quaternion3D(
                x: (f.x + r.z) / s, y: (f.y + u.z) / s, z: 0.25 * s, w: (r.y - u.x) / s)
        }
        _quaternion = q.normalized
    }

    // MARK: - Inspecting a 3D rotation's properties

    /// The angle of the rotation derived from the quaternion.
    public var angle: Angle2D {
        let w = Swift.max(-1.0, Swift.min(1.0, _quaternion.w))
        return Angle2D(radians: 2.0 * Foundation.acos(w))
    }

    /// The normalised rotation axis derived from the quaternion xyz components.
    public var axis: RotationAxis3D {
        let sinHalfAngle = Foundation.sqrt(1.0 - _quaternion.w * _quaternion.w)
        guard sinHalfAngle > 1e-10 else {
            return RotationAxis3D(x: 0, y: 1, z: 0)
        }
        let inv = 1.0 / sinHalfAngle
        return RotationAxis3D(
            x: _quaternion.x * inv, y: _quaternion.y * inv, z: _quaternion.z * inv)
    }

    /// A quaternion that represents the rotation.
    public var quaternion: Quaternion3D {
        _quaternion
    }

    /// The underlying vector of the rotation: [x, y, z, w].
    public var vector: [Double] {
        [_quaternion.x, _quaternion.y, _quaternion.z, _quaternion.w]
    }

    /// A Boolean value that indicates whether the rotation is the identity rotation.
    public var isIdentity: Bool {
        (_quaternion.x == 0 && _quaternion.y == 0 && _quaternion.z == 0 && _quaternion.w == 1)
            || (_quaternion.x == 0 && _quaternion.y == 0 && _quaternion.z == 0
                && _quaternion.w == -1)
    }

    /// Returns the inverse of the rotation.
    public var inverse: Rotation3D {
        Rotation3D(quaternion: _quaternion.conjugated())
    }

    /// Rotates the given vector by this rotation.
    ///
    /// - Parameter vector: The vector to rotate.
    /// - Returns: The rotated vector.
    /// - Complexity: O(1)
    @inline(__always)
    public func act(_ vector: Vector3D) -> Vector3D {
        _quaternion.act(vector)
    }
}

extension Rotation3D: ProjectiveTransformable3D {

    /// Returns a transformed copy of the rotation.
    ///
    /// When the transform is affine, extracts its rotation component and
    /// composes it with this rotation. Otherwise returns self unchanged.
    ///
    /// - Parameter transform: A projective transform to apply.
    /// - Returns: The transformed rotation.
    /// - Complexity: O(1)
    public func applying(_ transform: ProjectiveTransform3D) -> Rotation3D {
        guard transform.isAffine else { return self }
        let affineRotation = AffineTransform3D(matrix: transform.matrix).rotation
        return Rotation3D(quaternion: quaternion * affineRotation.quaternion)
    }
}

extension Rotation3D: CustomStringConvertible {

    /// A textual representation of the rotation.
    public var description: String {
        "(angle: \(_quaternion.w), axis: \(axis))"
    }
}
