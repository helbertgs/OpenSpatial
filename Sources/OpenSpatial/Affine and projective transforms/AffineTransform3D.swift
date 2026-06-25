
// AffineTransform3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A 3D affine transformation matrix.
@frozen
public struct AffineTransform3D: Copyable, Equatable, Hashable, Sendable {

    // MARK: - Flat storage (row-major: _mRC = row R, column C)

    var _m00: Double; var _m01: Double; var _m02: Double; var _m03: Double
    var _m10: Double; var _m11: Double; var _m12: Double; var _m13: Double
    var _m20: Double; var _m21: Double; var _m22: Double; var _m23: Double
    var _m30: Double; var _m31: Double; var _m32: Double; var _m33: Double

    // MARK: - Creating a 3D affine transform structure

    @inline(__always)
    public static var identity: AffineTransform3D { .init() }

    /// Returns a new identity affine transform.
    @inline(__always)
    public init() {
        _m00 = 1; _m01 = 0; _m02 = 0; _m03 = 0
        _m10 = 0; _m11 = 1; _m12 = 0; _m13 = 0
        _m20 = 0; _m21 = 0; _m22 = 1; _m23 = 0
        _m30 = 0; _m31 = 0; _m32 = 0; _m33 = 1
    }

    /// Creates an affine transform from the specified double-precision matrix.
    ///
    /// - Parameter matrix: The source double-precision matrix.
    @inline(__always)
    public init(matrix: [[Double]]) {
        _m00 = matrix[0][0]; _m01 = matrix[0][1]; _m02 = matrix[0][2]; _m03 = matrix[0][3]
        _m10 = matrix[1][0]; _m11 = matrix[1][1]; _m12 = matrix[1][2]; _m13 = matrix[1][3]
        _m20 = matrix[2][0]; _m21 = matrix[2][1]; _m22 = matrix[2][2]; _m23 = matrix[2][3]
        _m30 = matrix[3][0]; _m31 = matrix[3][1]; _m32 = matrix[3][2]; _m33 = matrix[3][3]
    }

    /// Creates an affine transform that represents the specified rotation.
    ///
    /// - Parameter rotation: The rotation to encode.
    public init(rotation: Rotation3D) {
        let q = rotation.quaternion
        let x = q.x; let y = q.y; let z = q.z; let w = q.w
        _m00 = 1 - 2 * (y * y + z * z); _m01 = 2 * (x * y + w * z); _m02 = 2 * (x * z - w * y); _m03 = 0
        _m10 = 2 * (x * y - w * z);     _m11 = 1 - 2 * (x * x + z * z); _m12 = 2 * (y * z + w * x); _m13 = 0
        _m20 = 2 * (x * z + w * y);     _m21 = 2 * (y * z - w * x); _m22 = 1 - 2 * (x * x + y * y); _m23 = 0
        _m30 = 0;                        _m31 = 0;                    _m32 = 0;                        _m33 = 1
    }

    /// Creates an affine transform that represents the specified scale.
    ///
    /// - Parameter scale: The scale factors for each axis.
    @inline(__always)
    public init(scale: Size3D) {
        _m00 = scale.width; _m01 = 0; _m02 = 0; _m03 = 0
        _m10 = 0; _m11 = scale.height; _m12 = 0; _m13 = 0
        _m20 = 0; _m21 = 0; _m22 = scale.depth; _m23 = 0
        _m30 = 0; _m31 = 0; _m32 = 0; _m33 = 1
    }

    /// Creates an affine transform that represents the specified translation.
    ///
    /// - Parameter translation: The translation vector.
    @inline(__always)
    public init(translation: Vector3D) {
        _m00 = 1; _m01 = 0; _m02 = 0; _m03 = 0
        _m10 = 0; _m11 = 1; _m12 = 0; _m13 = 0
        _m20 = 0; _m21 = 0; _m22 = 1; _m23 = 0
        _m30 = translation.x; _m31 = translation.y; _m32 = translation.z; _m33 = 1
    }

    /// Creates an affine transform that composes rotation, scale, and translation.
    ///
    /// - Parameters:
    ///   - rotation: The rotation component.
    ///   - scale: The scale component.
    ///   - translation: The translation component.
    public init(rotation: Rotation3D, scale: Size3D, translation: Vector3D) {
        self = AffineTransform3D(rotation: rotation)
            .scaled(by: scale)
            .translated(by: translation)
    }

    // MARK: - Checking characteristics

    /// The affine transform's underlying matrix (API-compatible with Apple Spatial framework).
    public var matrix: [[Double]] {
        [
            [_m00, _m01, _m02, _m03],
            [_m10, _m11, _m12, _m13],
            [_m20, _m21, _m22, _m23],
            [_m30, _m31, _m32, _m33],
        ]
    }

    /// Accesses the element at the specified row and column.
    ///
    /// - Parameters:
    ///   - row: The row index.
    ///   - column: The column index.
    /// - Returns: The element at the specified row and column.
    public subscript(row: Int, column: Int) -> Double {
        get {
            switch (row, column) {
            case (0, 0): return _m00; case (0, 1): return _m01
            case (0, 2): return _m02; case (0, 3): return _m03
            case (1, 0): return _m10; case (1, 1): return _m11
            case (1, 2): return _m12; case (1, 3): return _m13
            case (2, 0): return _m20; case (2, 1): return _m21
            case (2, 2): return _m22; case (2, 3): return _m23
            case (3, 0): return _m30; case (3, 1): return _m31
            case (3, 2): return _m32; case (3, 3): return _m33
            default: preconditionFailure("Index out of range")
            }
        }
        set {
            switch (row, column) {
            case (0, 0): _m00 = newValue; case (0, 1): _m01 = newValue
            case (0, 2): _m02 = newValue; case (0, 3): _m03 = newValue
            case (1, 0): _m10 = newValue; case (1, 1): _m11 = newValue
            case (1, 2): _m12 = newValue; case (1, 3): _m13 = newValue
            case (2, 0): _m20 = newValue; case (2, 1): _m21 = newValue
            case (2, 2): _m22 = newValue; case (2, 3): _m23 = newValue
            case (3, 0): _m30 = newValue; case (3, 1): _m31 = newValue
            case (3, 2): _m32 = newValue; case (3, 3): _m33 = newValue
            default: preconditionFailure("Index out of range")
            }
        }
    }

    /// A Boolean value that indicates whether this transform is the identity transform.
    public var isIdentity: Bool {
        self == AffineTransform3D()
    }

    // MARK: - Decomposing a 3D affine transform

    /// The scale component extracted from the matrix (column magnitudes of the 3×3 upper-left block).
    public var scale: Size3D {
        let sx = Foundation.sqrt(_m00 * _m00 + _m10 * _m10 + _m20 * _m20)
        let sy = Foundation.sqrt(_m01 * _m01 + _m11 * _m11 + _m21 * _m21)
        let sz = Foundation.sqrt(_m02 * _m02 + _m12 * _m12 + _m22 * _m22)
        return Size3D(width: sx, height: sy, depth: sz)
    }

    /// The translation component extracted from the last row of the matrix.
    public var translation: Vector3D {
        Vector3D(x: _m30, y: _m31, z: _m32)
    }

    /// The rotation component extracted from the matrix.
    public var rotation: Rotation3D {
        let s = scale
        guard s.width > 0 && s.height > 0 && s.depth > 0 else { return Rotation3D() }
        let r00 = _m00 / s.width;  let r10 = _m10 / s.width;  let r20 = _m20 / s.width
        let r01 = _m01 / s.height; let r11 = _m11 / s.height; let r21 = _m21 / s.height
        let r02 = _m02 / s.depth;  let r12 = _m12 / s.depth;  let r22 = _m22 / s.depth
        let trace = r00 + r11 + r22
        let q: Quaternion3D
        if trace > 0 {
            let s2 = 0.5 / Foundation.sqrt(trace + 1.0)
            q = Quaternion3D(x: (r12 - r21) * s2, y: (r20 - r02) * s2, z: (r01 - r10) * s2, w: 0.25 / s2)
        } else if r00 > r11 && r00 > r22 {
            let s2 = 2.0 * Foundation.sqrt(1.0 + r00 - r11 - r22)
            q = Quaternion3D(x: 0.25 * s2, y: (r10 + r01) / s2, z: (r20 + r02) / s2, w: (r12 - r21) / s2)
        } else if r11 > r22 {
            let s2 = 2.0 * Foundation.sqrt(1.0 + r11 - r00 - r22)
            q = Quaternion3D(x: (r10 + r01) / s2, y: 0.25 * s2, z: (r21 + r12) / s2, w: (r20 - r02) / s2)
        } else {
            let s2 = 2.0 * Foundation.sqrt(1.0 + r22 - r00 - r11)
            q = Quaternion3D(x: (r20 + r02) / s2, y: (r21 + r12) / s2, z: 0.25 * s2, w: (r01 - r10) / s2)
        }
        return Rotation3D(quaternion: q)
    }

    /// Returns the inverse of this transform, or nil if the matrix is singular.
    ///
    /// - Complexity: O(1)
    public var inverse: AffineTransform3D? {
        var m = matrix
        var inv: [[Double]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1],
        ]
        for col in 0..<4 {
            var pivotRow = col
            var maxVal = Swift.abs(m[col][col])
            for row in (col + 1)..<4 {
                let v = Swift.abs(m[row][col])
                if v > maxVal { maxVal = v; pivotRow = row }
            }
            guard maxVal > 1e-12 else { return nil }
            if pivotRow != col {
                m.swapAt(col, pivotRow)
                inv.swapAt(col, pivotRow)
            }
            let pivot = m[col][col]
            for j in 0..<4 {
                m[col][j] /= pivot
                inv[col][j] /= pivot
            }
            for row in 0..<4 where row != col {
                let factor = m[row][col]
                for j in 0..<4 {
                    m[row][j] -= factor * m[col][j]
                    inv[row][j] -= factor * inv[col][j]
                }
            }
        }
        return AffineTransform3D(matrix: inv)
    }
}

// MARK: - Codable

extension AffineTransform3D: Codable {

    public init(from decoder: Decoder) throws {
        let m = try [[Double]](from: decoder)
        self.init(matrix: m)
    }

    public func encode(to encoder: Encoder) throws {
        try matrix.encode(to: encoder)
    }
}

extension AffineTransform3D: CustomStringConvertible {

    /// A textual representation of the affine transform.
    public var description: String {
        var rows: [String] = []
        for row in matrix {
            let rowString = row.map { "\($0)" }.joined(separator: " ")
            rows.append("[\(rowString)]")
        }
        return rows.joined(separator: "\n")
    }
}

extension AffineTransform3D {

    // MARK: - Applying arithmetic operations

    /// Returns the concatenation of two affine transforms.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Returns: The concatenation of the two affine transforms.
    /// - Note: The resulting transform is equivalent to applying `rhs` followed by `lhs`.
    /// - Complexity: O(1)
    public static func * (lhs: AffineTransform3D, rhs: AffineTransform3D) -> AffineTransform3D {
        var result = AffineTransform3D()
        result._m00 = lhs._m00 * rhs._m00 + lhs._m01 * rhs._m10 + lhs._m02 * rhs._m20 + lhs._m03 * rhs._m30
        result._m01 = lhs._m00 * rhs._m01 + lhs._m01 * rhs._m11 + lhs._m02 * rhs._m21 + lhs._m03 * rhs._m31
        result._m02 = lhs._m00 * rhs._m02 + lhs._m01 * rhs._m12 + lhs._m02 * rhs._m22 + lhs._m03 * rhs._m32
        result._m03 = lhs._m00 * rhs._m03 + lhs._m01 * rhs._m13 + lhs._m02 * rhs._m23 + lhs._m03 * rhs._m33
        result._m10 = lhs._m10 * rhs._m00 + lhs._m11 * rhs._m10 + lhs._m12 * rhs._m20 + lhs._m13 * rhs._m30
        result._m11 = lhs._m10 * rhs._m01 + lhs._m11 * rhs._m11 + lhs._m12 * rhs._m21 + lhs._m13 * rhs._m31
        result._m12 = lhs._m10 * rhs._m02 + lhs._m11 * rhs._m12 + lhs._m12 * rhs._m22 + lhs._m13 * rhs._m32
        result._m13 = lhs._m10 * rhs._m03 + lhs._m11 * rhs._m13 + lhs._m12 * rhs._m23 + lhs._m13 * rhs._m33
        result._m20 = lhs._m20 * rhs._m00 + lhs._m21 * rhs._m10 + lhs._m22 * rhs._m20 + lhs._m23 * rhs._m30
        result._m21 = lhs._m20 * rhs._m01 + lhs._m21 * rhs._m11 + lhs._m22 * rhs._m21 + lhs._m23 * rhs._m31
        result._m22 = lhs._m20 * rhs._m02 + lhs._m21 * rhs._m12 + lhs._m22 * rhs._m22 + lhs._m23 * rhs._m32
        result._m23 = lhs._m20 * rhs._m03 + lhs._m21 * rhs._m13 + lhs._m22 * rhs._m23 + lhs._m23 * rhs._m33
        result._m30 = lhs._m30 * rhs._m00 + lhs._m31 * rhs._m10 + lhs._m32 * rhs._m20 + lhs._m33 * rhs._m30
        result._m31 = lhs._m30 * rhs._m01 + lhs._m31 * rhs._m11 + lhs._m32 * rhs._m21 + lhs._m33 * rhs._m31
        result._m32 = lhs._m30 * rhs._m02 + lhs._m31 * rhs._m12 + lhs._m32 * rhs._m22 + lhs._m33 * rhs._m32
        result._m33 = lhs._m30 * rhs._m03 + lhs._m31 * rhs._m13 + lhs._m32 * rhs._m23 + lhs._m33 * rhs._m33
        return result
    }

    /// Concatenates two affine transforms and stores the result in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    public static func *= (lhs: inout AffineTransform3D, rhs: AffineTransform3D) {
        lhs = lhs * rhs
    }
}

extension AffineTransform3D: Scalable3D {

    // MARK: - Scaling transforms

    /// Returns a new affine transform scaled by the specified size.
    ///
    /// - Parameter size: A size that contains the scale factors for each axis.
    /// - Returns: A new scaled affine transform.
    /// - Complexity: O(1)
    @inline(__always)
    public func scaled(by size: Size3D) -> AffineTransform3D {
        var scaleTransform = AffineTransform3D()
        scaleTransform[0, 0] = size.width
        scaleTransform[1, 1] = size.height
        scaleTransform[2, 2] = size.depth
        return self * scaleTransform
    }

    /// Returns a new entity scaled uniformly by the specified factor.
    ///
    /// - Parameter scale: A double-precision value that specifies the uniform scale factor.
    /// - Returns: A new scaled entity.
    /// - Complexity: O(1)
    @inline(__always)
    public func uniformlyScaled(by scale: Double) -> AffineTransform3D {
        self.scaled(by: Size3D(width: scale, height: scale, depth: scale))
    }
}

extension AffineTransform3D: Translatable3D {

    // MARK: - Translating transforms

    /// Returns a new affine transform translated by the specified vector.
    ///
    /// - Parameter vector: A vector that contains the translation distances for each axis.
    /// - Returns: A new translated affine transform.
    /// - Complexity: O(1)
    @inline(__always)
    public func translated(by vector: Vector3D) -> AffineTransform3D {
        var translationTransform = AffineTransform3D()
        translationTransform[3, 0] = vector.x
        translationTransform[3, 1] = vector.y
        translationTransform[3, 2] = vector.z
        return self * translationTransform
    }
}

extension AffineTransform3D: Rotatable3D {

    // MARK: - Rotating transforms

    /// Returns a new affine transform rotated by the specified quaternion.
    ///
    /// - Parameter quaternion: The quaternion to apply.
    /// - Returns: A new rotated affine transform.
    /// - Complexity: O(1)
    public func rotated(by quaternion: Quaternion3D) -> AffineTransform3D {
        self * AffineTransform3D(rotation: Rotation3D(quaternion: quaternion))
    }
}

extension AffineTransform3D: Shearable3D {

    // MARK: - Shearing transforms

    /// Returns a new affine transform sheared by the specified axis and factors.
    ///
    /// - Parameter shear: The axis and shear factors.
    /// - Returns: A new sheared affine transform.
    /// - Complexity: O(1)
    public func sheared(_ shear: AxisWithFactors) -> AffineTransform3D {
        var s = AffineTransform3D()
        switch shear {
        case .xAxis(let ky, let kz):
            s._m10 = ky; s._m20 = kz
        case .yAxis(let kx, let kz):
            s._m01 = kx; s._m21 = kz
        case .zAxis(let kx, let ky):
            s._m02 = kx; s._m12 = ky
        }
        return self * s
    }
}
