import Foundation

/// A 3D affine transformation matrix.
@frozen 
public struct AffineTransform3D : Codable, Copyable, Equatable, Hashable, Sendable {

    // MARK: - Creating a 3D affine transform structure

    /// Returns a new identity affine transform..
    @inline(__always) 
    public init() {
        self.matrix = [
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [0.0, 0.0, 0.0, 1.0]
        ]
    }

    /// Creates an affine transform from the specified double-precision matrix.
    /// 
    /// - Parameter matrix: The source double-precision matrix.
    /// - Note: Currently, this initializer always creates an identity matrix, regardless of the input
    @inline(__always) 
    public init(matrix: [[Double]]) {
        self.matrix = matrix
    }

    // MARK: - Checking characteristics

    /// The affine transform’s underlying matrix.
    public private(set) var matrix: [[Double]]

    /// Accesses the element at the specified row and column.
    ///
    /// - Parameters:
    ///   - row: The row index.
    ///   - column: The column index.
    /// - Returns: The element at the specified row and column.
    public subscript(row: Int, column: Int) -> Double {
        get { matrix[row][column] }
        set { matrix[row][column] = newValue }
    }
}

extension AffineTransform3D : CustomStringConvertible {

    /// A textual representation of the affine transform.
    public var description: String {
        var rows: [String] = []
        for row in matrix {
            let rowString = row.map { String(format: "% .4f", $0) }.joined(separator: " ")
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
    @inline(__always)
    public static func *(lhs: AffineTransform3D, rhs: AffineTransform3D) -> AffineTransform3D {
        var result = AffineTransform3D()
        for i in 0..<4 {
            for j in 0..<4 {
                result.matrix[i][j] = 0.0
                for k in 0..<4 {
                    result.matrix[i][j] += lhs.matrix[i][k] * rhs.matrix[k][j]
                }
            }
        }
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