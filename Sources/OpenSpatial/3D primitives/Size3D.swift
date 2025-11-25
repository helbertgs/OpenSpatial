import Foundation

/// A size that describes width, height, and depth in a 3D coordinate system.
@frozen public struct Size3D : Codable, Copyable, Equatable, Hashable, Sendable {

    // MARK: - Creating a 3D size structure

    /// Creates a size structure.
    @inline(__always)
    public init() {
        self.width = 0.0
        self.height = 0.0
        self.depth = 0.0
    }

    /// Creates a size structure from the specified double-precision values.
    /// 
    /// - Parameters:
    ///   - width: A double-precision value that specifies the width.
    ///   - height: A double-precision value that specifies the height.
    ///   - depth: A double-precision value that specifies the depth.
    @inline(__always)
    public init(width: Double = 0, height: Double = 0, depth: Double = 0) {
        self.width = width
        self.height = height
        self.depth = depth
    }

    /// Creates a size structure from the specified floating-point values.
    /// 
    /// - Parameters:
    ///  - width: A floating-point value that specifies the width.
    /// - height: A floating-point value that specifies the height.
    /// - depth: A floating-point value that specifies the depth.
    @inline(__always)
    public init<T>(width: T, height: T, depth: T ) where T : BinaryFloatingPoint {
        self.width = Double(width)
        self.height = Double(height)
        self.depth = Double(depth)
    }

    /// Creates a size structure from the specified vector.
    /// 
    /// - Parameter xyz: A vector that contains the width, height, and depth values.
    @inline(__always)
    public init(_ xyz: Vector3D) {
        (width, height, depth) = (xyz.x, xyz.y, xyz.z)
    }

    // MARK: - Inspecting a 3D size’s properties
    
    /// The width value.
    public let width: Double
    
    /// The height value.
    public let height: Double
    
    /// The depth value.
    public let depth: Double

    /// Accesses the width, height, or depth value at the specified index.
    /// 
    /// - Parameter index: The index of the value to access. Valid indices are 0, 1, and 2.
    /// - Returns: The width, height, or depth value at the specified index.
    /// - Complexity: O(1)
    @inline(__always)
    public subscript(index: Int) -> Double {
        get {
            switch index {
            case 0: return width
            case 1: return height
            case 2: return depth
            default:
                fatalError("Index out of range. Valid indices are 0, 1, and 2.")
            }
        }
    }

    // MARK: - 3D size constants

    /// The size structure with width, height, and depth values of one.
    public static let one = Size3D(width: 1, height: 1, depth: 1)

    // MARK: - Creating derived 3D sizes

    /// Returns the intersection of two sizes.
    /// 
    /// - Parameter other: The size that the function compares against.
    /// - Returns: A new size that is the intersection of two sizes.
    @inline(__always)
    public func intersection(_ other: Size3D) -> Size3D? {
        let newWidth = min(self.width, other.width)
        let newHeight = min(self.height, other.height)
        let newDepth = min(self.depth, other.depth)

        if newWidth >= 0 && newHeight >= 0 && newDepth >= 0 {
            return Size3D(width: newWidth, height: newHeight, depth: newDepth)
        } else {
            return nil
        }
    }
}

extension Size3D : ExpressibleByArrayLiteral {

    /// Creates an instance initialized with the given elements.
    /// 
    /// - Parameter elements: The elements of the array literal.
    @inline(__always)
    public init(arrayLiteral elements: Double...) {
        precondition(elements.count == 3, "Array literal must contain exactly three elements.")
        (width, height, depth) = (elements[0], elements[1], elements[2])
    }
}

extension Size3D : AdditiveArithmetic {

    // MARK: - Applying arithmetic operations

    /// The zero size.
    public static let zero = Size3D()

    /// Returns a size that’s the product of a size and a scalar value.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side scalar value.
    /// - Returns: The product of the size and the scalar.
    /// - Complexity: O(1)
    @inline(__always)
    public static func * (lhs: Size3D, rhs: Double) -> Size3D {
        .init(width: lhs.width * rhs, height: lhs.height * rhs, depth: lhs.depth * rhs)
    }

    /// Multiplies a size and a double-precision value, and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func *= (lhs: inout Size3D, rhs: Double) {
        lhs = lhs * rhs
    }

    /// Adds two sizes and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The first size.
    ///   - rhs: The second size.
    /// - Returns: The sum of the two sizes.
    /// - Complexity: O(1)
    @inline(__always)
    public static func + (lhs: Size3D, rhs: Size3D) -> Size3D {
        .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height, depth: lhs.depth + rhs.depth)
    }

    /// Adds the second size to the first size and stores the result in the first size.
    /// 
    /// - Parameters:
    ///   - lhs: The first size.
    ///   - rhs: The second size.
    /// - Complexity: O(1)
    @inline(__always)
    public static func += (lhs: inout Size3D, rhs: Size3D) {
        lhs = lhs + rhs
    }

    /// Subtracts one size from another and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The first size.
    ///   - rhs: The second size.
    /// - Returns: The difference of the two sizes.
    /// - Complexity: O(1)
    @inline(__always)
    public static func - (lhs: Size3D, rhs: Size3D) -> Size3D {
        .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height, depth: lhs.depth - rhs.depth)
    }

    /// Subtracts the second size from the first size and stores the result in the first size.
    /// 
    /// - Parameters:
    ///   - lhs: The first size.
    ///   - rhs: The second size.
    /// - Complexity: O(1)
    @inline(__always)
    public static func -= (lhs: inout Size3D, rhs: Size3D) {
        lhs = lhs - rhs
    }

    /// Returns a size with each element divided by a scalar value.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Returns: The resulting size.
    /// - Complexity: O(1)
    @inline(__always)
    public static func / (lhs: Size3D, rhs: Double) -> Size3D {
        .init(width: lhs.width / rhs, height: lhs.height / rhs, depth: lhs.depth / rhs)
    }

    /// Divides each element of the size by a scalar value and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func /= (lhs: inout Size3D, rhs: Double) {
        lhs = lhs / rhs
    }
}

extension Size3D : Primitive3D {
    // MARK: - Instance properties

    /// A Boolean value that indicates whether the vector is finite.
    public var isFinite: Bool {
        width.isFinite && height.isFinite && depth.isFinite
    }

    /// A Boolean value that indicates whether the vector contains any NaN values.
    public var isNaN: Bool {
        width.isNaN || height.isNaN || depth.isNaN
    }

    /// A Boolean value that indicates whether the vector is zero.
    public var isZero: Bool {
        width == 0 && height == 0 && depth == 0
    }

    // MARK: - Type properties

    /// A size with infinite values.
    public static var infinity: Size3D {
        .init(width: .infinity, height: .infinity, depth: .infinity)
    }

    // MARK: - Transforming primitives

    // Applies an affine transform.
    /// 
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new transformed size.
    /// - Complexity: O(1)
    public func applying(_ transform: AffineTransform3D) -> Size3D {
        fatalError("Size3D does not support applying affine transforms.")
    }
}

extension Size3D : Scalable3D {

    /// Returns a new entity scaled by the specified size.
    /// 
    /// - Parameter size: A size that contains the scale factors for each axis.
    /// - Returns: A new scaled entity.
    /// - Complexity: O(1)
    @inline(__always)
    public func scaled(by size: Size3D) -> Size3D {
        .init(width: self.width * size.width,
              height: self.height * size.height,
              depth: self.depth * size.depth)
    }

    /// Returns a new entity scaled uniformly by the specified factor.
    /// 
    /// - Parameter scale: A double-precision value that specifies the uniform scale factor.
    /// - Returns: A new scaled entity.
    /// - Complexity: O(1)
    @inline(__always)
    public func uniformlyScaled(by scale: Double) -> Size3D {
        .init(width: self.width * scale,
              height: self.height * scale,
              depth: self.depth * scale)
    }
}