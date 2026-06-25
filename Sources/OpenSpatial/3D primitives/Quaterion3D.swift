
// Quaterion3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// Quaternions are used to represent rotations.
///
/// A quaternion is a four-tuple of real numbers {x,y,z,w}.
/// A quaternion is a mathematically convenient alternative to the euler angle representation.
/// You can interpolate a quaternion without experiencing gimbal lock.
/// You can also use a quaternion to concatenate a series of rotations into a single representation.
///
/// OpenSpatial internally uses Quaternions to represent all rotations.
@frozen
public struct Quaternion3D: Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Initializers

    /// Creates a new quaternion
    @inline(__always)
    public init() {
        self.init(x: 0, y: 0, z: 0, w: 1)
    }

    /// Creates a new quaternion structure from the specified double-precision values.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate value.
    ///   - y: The y-coordinate value.
    ///   - z: The z-coordinate value.
    ///   - w: The w-coordinate value.
    @inline(__always)
    public init(x: Double, y: Double, z: Double, w: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    /// Creates a new quaternion structure from the specified Euler angles.
    ///
    /// - Parameter eulerAngles: The Euler angles of the quaternion.
    public init(_ angles: EulerAngles, order: EulerAngles.Order = .xyz) {
        let x = angles.x.radians
        let y = angles.y.radians
        let z = angles.z.radians

        let cx = Foundation.cos(x)
        let cy = Foundation.cos(y)
        let cz = Foundation.cos(z)
        let sx = Foundation.sin(x)
        let sy = Foundation.sin(y)
        let sz = Foundation.sin(z)

        switch order {
        case .xyz:
            self.init(
                x: sx * cy * cz + cx * sy * sz,
                y: cx * sy * cz - sx * cy * sz,
                z: cx * cy * sz + sx * sy * cz,
                w: cx * cy * cz - sx * sy * sz
            )
        case .zxy:
            self.init(
                x: sx * cy * cz - cx * sy * sz,
                y: cx * sy * cz + sx * cy * sz,
                z: cx * cy * sz - sx * sy * cz,
                w: cx * cy * cz + sx * sy * sz
            )
        }
    }

    public init(angle: Angle2D, axis: Vector3D) {
        let n = axis.normalized
        let x = angle.radians * 0.5
        let sx = Foundation.sin(x)
        let cx = Foundation.cos(x)
        self.init(x: n.x * sx, y: n.y * sx, z: n.z * sx, w: cx)
    }

    /// Accesses the x, y, or z value at the specified index.
    ///
    /// - Parameter index: The index of the value to access. Valid indices are 0, 1, and 2.
    /// - Returns: The x, y, or z value at the specified index.
    /// - Complexity: O(1)
    @inline(__always)
    public subscript(index: Int) -> Double {
        get throws {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            case 3: return w
            default:
                throw Error.outOfRage
            }
        }
    }

    /// Creates a quaternion representing the shortest-arc rotation from one vector to another.
    ///
    /// - Parameters:
    ///   - from: The starting unit vector.
    ///   - to: The ending unit vector.
    public init(from: Vector3D, to: Vector3D) {
        let a = from.normalized
        let b = to.normalized
        let dot = a.dot(b)
        if dot >= 1.0 {
            self.init()
            return
        }
        if dot <= -1.0 {
            // 180-degree rotation: find an orthogonal axis
            let ortho =
                abs(a.x) < 0.9
                ? Vector3D(x: 0, y: -a.z, z: a.y).normalized
                : Vector3D(x: -a.z, y: 0, z: a.x).normalized
            self.init(x: ortho.x, y: ortho.y, z: ortho.z, w: 0)
            return
        }
        let c = a.cross(b)
        self.init(x: c.x, y: c.y, z: c.z, w: 1.0 + dot)
        let norm = self.normalized
        self.init(x: norm.x, y: norm.y, z: norm.z, w: norm.w)
    }

    // MARK: - Checking characteristics

    /// The x-coordinate value.
    public var x: Double

    /// The y-coordinate value.
    public var y: Double

    /// The z-coordinate value.
    public var z: Double

    /// The w-coordinate value.
    public var w: Double

    /// A simd four-element vector that contains the x-, y-, z-, and w-coordinate values.
    public var vector: [Double] { [x, y, z, w] }

    /// The identity quaternion (0, 0, 0, 1).
    public static let identity = Quaternion3D()

    /// Rotates the given vector by this quaternion.
    ///
    /// - Parameter vector: The vector to rotate.
    /// - Returns: The rotated vector.
    /// - Complexity: O(1)
    @inline(__always)
    public func act(_ vector: Vector3D) -> Vector3D {
        vector.rotated(by: self)
    }

    /// The Euler angles of the quaternion.
    public var eulerAngles: EulerAngles {
        let q = self.normalized

        let sinp = 2.0 * (q.w * q.x + q.y * q.z)
        let cosp = 1.0 - 2.0 * (q.x * q.x + q.y * q.y)
        let pitch = atan2(sinp, cosp)

        let siny = 2.0 * (q.w * q.y - q.z * q.x)
        let yaw: Double
        if abs(siny) >= 1 {
            yaw = siny > 0 ? Double.pi / 2 : -Double.pi / 2
        } else {
            yaw = asin(siny)
        }

        let sinr = 2.0 * (q.w * q.z + q.x * q.y)
        let cosr = 1.0 - 2.0 * (q.y * q.y + q.z * q.z)
        let roll = atan2(sinr, cosr)

        return .init(
            x: .init(radians: pitch),
            y: .init(radians: yaw),
            z: .init(radians: roll),
            order: .xyz
        )
    }

    /// The squared length of the quaternion.
    public var lengthSquared: Double {
        x * x + y * y + z * z + w * w
    }

    /// The length of the quaternion.
    public var length: Double {
        Foundation.sqrt(lengthSquared)
    }

    /// Returns the conjugated quaternion.
    ///
    /// - Complexity: O(1)
    @inline(__always)
    public func conjugated() -> Quaternion3D {
        .init(x: -x, y: -y, z: -z, w: w)
    }

    /// Returns the inverted quaternion.
    ///
    /// - Complexity: O(1)
    @inline(__always)
    public func inverted() -> Quaternion3D {
        let lenSq = lengthSquared
        guard lenSq > 0 else { return self }
        let conjugate = conjugated()
        let inverse = 1.0 / lenSq
        return .init(
            x: conjugate.x * inverse,
            y: conjugate.y * inverse,
            z: conjugate.z * inverse,
            w: conjugate.w * inverse
        )
    }

    /// Returns the normalized quaternion.
    public var normalized: Quaternion3D {
        let magnitude = length
        guard magnitude > 0 else { return self }
        let inverse = 1.0 / magnitude
        return Quaternion3D(
            x: x * inverse,
            y: y * inverse,
            z: z * inverse,
            w: w * inverse
        )
    }

    /// Returns the product of two quaternions.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side quaternion.
    ///   - rhs: The right-hand-side quaternion.
    /// - Returns: The product of the two quaternions.
    /// - Complexity: O(1)
    public static func * (lhs: Quaternion3D, rhs: Quaternion3D) -> Quaternion3D {
        .init(
            x: lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.w * rhs.y - lhs.x * rhs.z + lhs.y * rhs.w + lhs.z * rhs.x,
            z: lhs.w * rhs.z + lhs.x * rhs.y - lhs.y * rhs.x + lhs.z * rhs.w,
            w: lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z
        )
    }
}

extension Quaternion3D: CustomStringConvertible {

    /// A textual representation of the quaternion.
    public var description: String {
        return "(x: \(x), y: \(y), z: \(z), w: \(w))"
    }
}

extension Quaternion3D: ExpressibleByArrayLiteral {

    /// Creates a quaternion from the specified array literal.
    ///
    /// - Parameter elements: An array of double-precision values.
    @inline(__always)
    public init(arrayLiteral elements: Double...) {
        precondition(elements.count == 4, "Invalid array literal for \(Self.self)")
        self.init(x: elements[0], y: elements[1], z: elements[2], w: elements[3])
    }
}

extension Quaternion3D: Primitive3D {

    /// Returns a Boolean value that indicates whether the quaternion is finite.
    public var isFinite: Bool {
        x.isFinite && y.isFinite && z.isFinite && w.isFinite
    }

    /// Returns a Boolean value that indicates whether the quaternion contains any NaN values.
    public var isNaN: Bool {
        x.isNaN || y.isNaN || z.isNaN || w.isNaN
    }

    /// Returns a Boolean value that indicates whether the quaternion is zero.
    public var isZero: Bool {
        x == 0 && y == 0 && z == 0 && w == 0
    }

    /// Returns a quaternion with infinite values.
    public static var infinity: Quaternion3D {
        .init(x: .infinity, y: .infinity, z: .infinity, w: .infinity)
    }

    /// Returns a quaternion with zero values.
    public static var zero: Quaternion3D {
        .init(x: 0, y: 0, z: 0, w: 0)
    }

    /// Returns a new quaternion created by applying an affine transform.
    ///
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new quaternion created by applying the affine transform.
    /// - Complexity: O(1)
    public func applying(_ transform: AffineTransform3D) -> Quaternion3D {
        let w =
            0.5
            * Foundation.sqrt(
                1 + transform.matrix[0][0] + transform.matrix[1][1] + transform.matrix[2][2])
        let x =
            0.5
            * Foundation.sqrt(
                1 + transform.matrix[0][0] - transform.matrix[1][1] - transform.matrix[2][2])
        let y =
            0.5
            * Foundation.sqrt(
                1 + transform.matrix[1][1] - transform.matrix[0][0] - transform.matrix[2][2])
        let z =
            0.5
            * Foundation.sqrt(
                1 + transform.matrix[2][2] - transform.matrix[0][0] - transform.matrix[1][1])

        return Quaternion3D(x: x, y: y, z: z, w: w)
    }

    // MARK: - Transforing 3D Rotations structure

    @inline(__always)
    public static func slerp(_ a: Quaternion3D, _ b: Quaternion3D, t: Double) -> Quaternion3D {
        // Inline normalization for a — avoids calling .length (sqrt) twice via .normalized
        let aLenSq = a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w
        let aInv = aLenSq > 0 ? 1.0 / Foundation.sqrt(aLenSq) : 1.0
        let q1 = Quaternion3D(x: a.x * aInv, y: a.y * aInv, z: a.z * aInv, w: a.w * aInv)

        // Inline normalization for b
        let bLenSq = b.x * b.x + b.y * b.y + b.z * b.z + b.w * b.w
        let bInv = bLenSq > 0 ? 1.0 / Foundation.sqrt(bLenSq) : 1.0
        var q2 = Quaternion3D(x: b.x * bInv, y: b.y * bInv, z: b.z * bInv, w: b.w * bInv)

        var dot = q1.x * q2.x + q1.y * q2.y + q1.z * q2.z + q1.w * q2.w

        if dot < 0.0 {
            q2 = Quaternion3D(x: -q2.x, y: -q2.y, z: -q2.z, w: -q2.w)
            dot = -dot
        }

        if dot > 0.9995 {
            // Near-linear: lerp then renormalize inline
            let rx = q1.x + (q2.x - q1.x) * t
            let ry = q1.y + (q2.y - q1.y) * t
            let rz = q1.z + (q2.z - q1.z) * t
            let rw = q1.w + (q2.w - q1.w) * t
            let rLenSq = rx * rx + ry * ry + rz * rz + rw * rw
            let rInv = rLenSq > 0 ? 1.0 / Foundation.sqrt(rLenSq) : 1.0
            return Quaternion3D(x: rx * rInv, y: ry * rInv, z: rz * rInv, w: rw * rInv)
        }

        let theta0 = acos(dot)
        let theta = theta0 * t

        let sin_theta = sin(theta)
        let sin_theta0 = sin(theta0)

        let s0 = cos(theta) - dot * sin_theta / sin_theta0
        let s1 = sin_theta / sin_theta0

        return Quaternion3D(
            x: q1.x * s0 + q2.x * s1,
            y: q1.y * s0 + q2.y * s1,
            z: q1.z * s0 + q2.z * s1,
            w: q1.w * s0 + q2.w * s1
        )
    }
}
