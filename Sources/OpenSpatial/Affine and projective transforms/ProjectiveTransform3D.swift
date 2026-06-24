
// ProjectiveTransform3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A 3D projective transformation represented by a 4×4 matrix.
@frozen
public struct ProjectiveTransform3D: Equatable, Hashable, Sendable {

    // MARK: - Flat storage (row-major: _mRC = row R, column C)

    var _m00: Double; var _m01: Double; var _m02: Double; var _m03: Double
    var _m10: Double; var _m11: Double; var _m12: Double; var _m13: Double
    var _m20: Double; var _m21: Double; var _m22: Double; var _m23: Double
    var _m30: Double; var _m31: Double; var _m32: Double; var _m33: Double

    // MARK: - Creating a ProjectiveTransform3D

    /// Returns the identity projective transform.
    public static let identity = ProjectiveTransform3D()

    /// Creates a projective transform with the identity matrix.
    @inline(__always)
    public init() {
        _m00 = 1; _m01 = 0; _m02 = 0; _m03 = 0
        _m10 = 0; _m11 = 1; _m12 = 0; _m13 = 0
        _m20 = 0; _m21 = 0; _m22 = 1; _m23 = 0
        _m30 = 0; _m31 = 0; _m32 = 0; _m33 = 1
    }

    /// Creates a projective transform from the specified 4×4 matrix.
    ///
    /// - Parameter matrix: The source matrix in row-major order.
    @inline(__always)
    public init(matrix: [[Double]]) {
        _m00 = matrix[0][0]; _m01 = matrix[0][1]; _m02 = matrix[0][2]; _m03 = matrix[0][3]
        _m10 = matrix[1][0]; _m11 = matrix[1][1]; _m12 = matrix[1][2]; _m13 = matrix[1][3]
        _m20 = matrix[2][0]; _m21 = matrix[2][1]; _m22 = matrix[2][2]; _m23 = matrix[2][3]
        _m30 = matrix[3][0]; _m31 = matrix[3][1]; _m32 = matrix[3][2]; _m33 = matrix[3][3]
    }

    /// Creates a projective transform by upcasting an affine transform.
    ///
    /// - Parameter affine: The affine transform to upcast.
    @inline(__always)
    public init(_ affine: AffineTransform3D) {
        _m00 = affine._m00; _m01 = affine._m01; _m02 = affine._m02; _m03 = affine._m03
        _m10 = affine._m10; _m11 = affine._m11; _m12 = affine._m12; _m13 = affine._m13
        _m20 = affine._m20; _m21 = affine._m21; _m22 = affine._m22; _m23 = affine._m23
        _m30 = affine._m30; _m31 = affine._m31; _m32 = affine._m32; _m33 = affine._m33
    }

    // MARK: - Public matrix property (API-compatible with Apple Spatial framework)

    /// The underlying 4×4 matrix in row-major order.
    public var matrix: [[Double]] {
        [
            [_m00, _m01, _m02, _m03],
            [_m10, _m11, _m12, _m13],
            [_m20, _m21, _m22, _m23],
            [_m30, _m31, _m32, _m33],
        ]
    }

    // MARK: - Subscript

    /// Accesses the element at the specified row and column.
    ///
    /// - Parameters:
    ///   - row: The row index.
    ///   - column: The column index.
    /// - Returns: The element at the specified position.
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

    // MARK: - Characteristics

    /// A Boolean value that indicates whether the transform is an affine transform.
    ///
    /// Returns `true` when the bottom row is `[0, 0, 0, 1]`.
    public var isAffine: Bool {
        _m30 == 0 && _m31 == 0 && _m32 == 0 && _m33 == 1
    }

    /// A Boolean value that indicates whether the transform is the identity transform.
    public var isIdentity: Bool {
        self == ProjectiveTransform3D()
    }

    // MARK: - Inverse

    /// Returns the inverse transform, or `nil` if the matrix is singular.
    ///
    /// - Complexity: O(1)
    public var inverse: ProjectiveTransform3D? {
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
        return ProjectiveTransform3D(matrix: inv)
    }

    // MARK: - Concatenation

    /// Returns the concatenation of this transform with another.
    ///
    /// - Parameter other: The transform to concatenate.
    /// - Returns: The concatenated transform.
    @inline(__always)
    public func concatenating(_ other: ProjectiveTransform3D) -> ProjectiveTransform3D {
        self * other
    }

    // MARK: - Operators

    /// Returns the concatenation of two projective transforms.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Returns: The concatenated transform.
    public static func * (lhs: ProjectiveTransform3D, rhs: ProjectiveTransform3D)
        -> ProjectiveTransform3D
    {
        var result = ProjectiveTransform3D()
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

    /// Concatenates two projective transforms and stores the result in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    public static func *= (lhs: inout ProjectiveTransform3D, rhs: ProjectiveTransform3D) {
        lhs = lhs * rhs
    }
}

// MARK: - Codable

extension ProjectiveTransform3D: Codable {

    public init(from decoder: Decoder) throws {
        let m = try [[Double]](from: decoder)
        self.init(matrix: m)
    }

    public func encode(to encoder: Encoder) throws {
        try matrix.encode(to: encoder)
    }
}

extension ProjectiveTransform3D: Shearable3D {

    // MARK: - Shearing transforms

    /// Returns a new projective transform sheared by the specified axis and factors.
    ///
    /// - Parameter shear: The axis and shear factors.
    /// - Returns: A new sheared projective transform.
    /// - Complexity: O(1)
    public func sheared(_ shear: AxisWithFactors) -> ProjectiveTransform3D {
        var s = ProjectiveTransform3D()
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

extension ProjectiveTransform3D: CustomStringConvertible {

    /// A textual representation of the projective transform.
    public var description: String {
        matrix.map { row in
            "[" + row.map { "\($0)" }.joined(separator: " ") + "]"
        }.joined(separator: "\n")
    }
}
