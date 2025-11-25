import Foundation

/// A point in a 3D coordinate system.
@frozen 
public struct Point3D : Copyable, Codable, Equatable, Hashable, Sendable {
    
    // MARK: - Inspecting a 3D point’s properties
    
    /// The x-coordinate of the point.
    public let x: Double
    
    /// The y-coordinate of the point.
    public let y: Double
    
    /// The z-coordinate of the point.
    public let z: Double

    /// The magnitude (length) of the point from the origin.
    public var magnitudeSquared: Double {
        return x * x + y * y + z * z
    }
    
    // MARK: - Creating a 3D point structure

    /// Creates a point.
    @inline(__always)
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
    }
    
    /// Creates a point with the specified coordinates.
    /// 
    /// - Parameters:
    ///   - x: A double-precision value that specifies the x-coordinate of the point.
    ///   - y: A double-precision value that specifies the y-coordinate of the point.
    ///   - z: A double-precision value that specifies the z-coordinate of the point.
    @inline(__always)
    public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// Creates a point from the specified floating-point values.
    /// 
    /// - Parameters:
    ///   - x: A floating-point value that specifies the x-coordinate value.
    ///   - y: A floating-point value that specifies the y-coordinate value.
    ///   - z: A floating-point value that specifies the z-coordinate value.
    @inline(__always)
    public init<T>(x: T, y: T, z: T) where T : BinaryFloatingPoint {
        self.x = Double(x)
        self.y = Double(y)
        self.z = Double(z)
    }

    /// Creates a point from the specified Spatial size structure.
    /// 
    /// - Parameter size: A size structure that specifies the coordinates.
    @inline(__always)
    public init(_ size: Size3D) {
        self.x = size.width
        self.y = size.height
        self.z = size.depth
    }

    /// Creates a point from the specified Spatial vector structure.
    /// 
    /// - Parameter xyz: A vector structure that specifies the coordinates.
    @inline(__always)
    public init(_ xyz: Vector3D) {
        self.x = xyz.x
        self.y = xyz.y
        self.z = xyz.z
    }

    /// Accesses the x, y, or z value at the specified index.
    /// 
    /// - Parameter index: The index of the value to access. Valid indices are 0, 1, and 2.
    /// - Returns: The x, y, or z value at the specified index.
    /// - Complexity: O(1)
    @inline(__always)
    public subscript(index: Int) -> Double {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default:
                fatalError("Index out of range. Valid indices are 0, 1, and 2.")
            }
        }
    }

    // MARK: - Checking characteristics

    /// Returns the distance between this point and another point.
    /// 
    /// - Parameter other: The other point.
    /// - Returns: The distance between the two points.
    /// - Complexity: O(1)
    @inline(__always)
    public func distance(to other: Point3D) -> Double {
        let dx = other.x - x
        let dy = other.y - y
        let dz = other.z - z
        return (dx * dx + dy * dy + dz * dz).squareRoot()
    }

    // MARK: - Comparing values

    /// Returns a Boolean value indicating whether this point is approximately equal to another point within a specified tolerance.
    /// 
    /// - Parameters:
    ///   - other: The other point to compare.
    ///   - tolerance: The maximum allowable difference between the corresponding coordinates of the two points for them to be considered approximately equal. 
    ///                The default value is the square root of the unit in the last place.
    /// - Returns: `true` if the points are approximately equal within the specified tolerance; otherwise, `false`.
    /// - Complexity: O(1)
    @inline(__always)
    public func isApproximatelyEqual(to other: Point3D, tolerance: Double = sqrt(.ulpOfOne)) -> Bool {
        abs(x - other.x) <= tolerance &&
        abs(y - other.y) <= tolerance &&
        abs(z - other.z) <= tolerance
    }
}

extension Point3D : ExpressibleByArrayLiteral {

    /// Creates an instance initialized with the given elements.
    /// 
    /// - Parameter elements: The elements of the array literal.
    @inline(__always)
    public init(arrayLiteral elements: Double...) {
        precondition(elements.count == 3, "Array literal must contain exactly three elements.")
        (x, y, z) = (elements[0], elements[1], elements[2])
    }
}

extension Point3D : AdditiveArithmetic {

    // MARK: - Applying arithmetic operations

    /// The zero point.
    public static let zero = Point3D()

    /// Returns a point that’s the product of a point and a scalar value.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side scalar value.
    /// - Returns: The product of the point and the scalar.
    /// - Complexity: O(1)
    @inline(__always)
    public static func * (lhs: Point3D, rhs: Double) -> Point3D {
        .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    /// Returns a point that’s the product of a point and a scalar value.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side scalar value.
    ///   - rhs: The right-hand-side  value.
    /// - Returns: The product of the point and the scalar.
    /// - Complexity: O(1)
    @inline(__always)
    public static func * (lhs: Double, rhs: Point3D) -> Point3D {
        .init(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z)
    }

    /// Returns the point that results from applying the affine transform to the point.
    /// 
    /// - Parameters:
    ///   - lhs: The affine transform.
    ///   - rhs: The point to transform.
    /// - Returns: The transformed point.
    /// - Complexity: O(1)
    @inline(__always)
    public static func * (lhs: AffineTransform3D, rhs: Point3D) -> Point3D {
        let x = lhs[0, 0] * rhs.x + lhs[1, 0] * rhs.y + lhs[2, 0] * rhs.z + lhs[3, 0]
        let y = lhs[0, 1] * rhs.x + lhs[1, 1] * rhs.y + lhs[2, 1] * rhs.z + lhs[3, 1]
        let z = lhs[0, 2] * rhs.x + lhs[1, 2] * rhs.y + lhs[2, 2] * rhs.z + lhs[3, 2]
        return Point3D(x: x, y: y, z: z)
    }

    /// Multiplies a point and a double-precision value, and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func *= (lhs: inout Point3D, rhs: Double) {
        lhs = lhs * rhs
    }

    /// Adds two points and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The first point.
    ///   - rhs: The second point.
    /// - Returns: The sum of the two points.
    /// - Complexity: O(1)
    @inline(__always)
    public static func + (lhs: Point3D, rhs: Point3D) -> Point3D {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    /// Adds a point to a size and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The point.
    ///   - rhs: The size.
    /// - Returns: The sum of the point and the size.
    /// - Complexity: O(1)
    @inline(__always)
    public static func + (lhs: Point3D, rhs: Size3D) -> Point3D {
        .init(x: lhs.x + rhs.width, y: lhs.y + rhs.height, z: lhs.z + rhs.depth)
    }

    /// Adds a size to a point and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The size.
    ///   - rhs: The point.
    /// - Returns: The sum of the point and the size.
    /// - Complexity: O(1)
    @inline(__always)
    public static func + (lhs: Size3D, rhs: Point3D) -> Point3D {
        .init(x: lhs.width + rhs.x, y: lhs.height + rhs.y, z: lhs.depth + rhs.z)
    }

    /// Adds the second point to the first point and stores the result in the first point.
    /// 
    /// - Parameters:
    ///   - lhs: The first point.
    ///   - rhs: The second point.
    /// - Complexity: O(1)
    @inline(__always)
    public static func += (lhs: inout Point3D, rhs: Point3D) {
        lhs = lhs + rhs
    }

    /// Adds a point and a vector, and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The point.
    ///   - rhs: The vector.
    /// - Complexity: O(1)
    @inline(__always)
    public static func += (lhs: inout Point3D, rhs: Vector3D) {
        lhs = lhs + rhs
    }

    /// Subtracts one point from another and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The first point.
    ///   - rhs: The second point.
    /// - Returns: The difference of the two points.
    /// - Complexity: O(1)
    @inline(__always)
    public static func - (lhs: Point3D, rhs: Point3D) -> Point3D {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    /// Returns a point that’s the element-wise difference of a point and a size.
    /// 
    /// - Parameters:
    ///   - lhs: The point.
    ///   - rhs: The size.
    /// - Returns: The difference of the point and the size.
    /// - Complexity: O(1)
    @inline(__always)
    public static func - (lhs: Point3D, rhs: Size3D) -> Point3D {
        .init(x: lhs.x - rhs.width, y: lhs.y - rhs.height, z: lhs.z - rhs.depth)
    }

    /// Returns a point that’s the element-wise difference of a point and a size.
    /// 
    /// - Parameters:
    ///   - lhs: The size.
    ///   - rhs: The point.
    /// - Returns: The difference of the size and the point.
    /// - Complexity: O(1)
    @inline(__always)
    public static func - (lhs: Size3D, rhs: Point3D) -> Point3D {
        .init(x: lhs.width - rhs.x, y: lhs.height - rhs.y, z: lhs.depth - rhs.z)
    }

    /// Subtracts the second point from the first point and stores the result in the first point.
    /// 
    /// - Parameters:
    ///   - lhs: The first point.
    ///   - rhs: The second point.
    /// - Complexity: O(1)
    @inline(__always)
    public static func -= (lhs: inout Point3D, rhs: Point3D) {
        lhs = lhs - rhs
    }

    /// Subtracts a vector from a point, and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The point.
    ///   - rhs: The vector.
    /// - Complexity: O(1)
    @inline(__always)
    public static func -= (lhs: inout Point3D, rhs: Vector3D) {
        lhs = lhs - rhs
    }

     /// Subtracts a size from a point, and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The point.
    ///   - rhs: The size.
    /// - Complexity: O(1)
    @inline(__always)
    public static func -= (lhs: inout Point3D, rhs: Size3D) {
        lhs = lhs - rhs
    }

    /// Returns a point with each element divided by a scalar value.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Returns: The resulting point.
    /// - Complexity: O(1)
    @inline(__always)
    public static func / (lhs: Point3D, rhs: Double) -> Point3D {
        .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    /// Divides each element of the point by a scalar value and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func /= (lhs: inout Point3D, rhs: Double) {
        lhs = lhs / rhs
    }
}

extension Point3D : Primitive3D {

    // MARK: - Instance properties

    /// A Boolean value that indicates whether the vector is finite.
    public var isFinite: Bool {
        x.isFinite && y.isFinite && z.isFinite
    }

    /// A Boolean value that indicates whether the vector contains any NaN values.
    public var isNaN: Bool {
        x.isNaN || y.isNaN || z.isNaN
    }

    /// A Boolean value that indicates whether the vector is zero.
    public var isZero: Bool {
        x == 0 && y == 0 && z == 0
    }

    // MARK: - Type properties

    /// A vector with infinite values.
    public static var infinity: Point3D {
        .init(x: .infinity, y: .infinity, z: .infinity)
    }

    // MARK: - Transforming primitives

    /// Applies an affine transform.
    /// 
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new transformed vector.
    /// - Complexity: O(1)
    public func applying(_ transform: AffineTransform3D) -> Point3D {
        let newX = x * transform.matrix[0][0] + y * transform.matrix[1][0] + z * transform.matrix[2][0] + transform.matrix[3][0]
        let newY = x * transform.matrix[0][1] + y * transform.matrix[1][1] + z * transform.matrix[2][1] + transform.matrix[3][1]
        let newZ = x * transform.matrix[0][2] + y * transform.matrix[1][2] + z * transform.matrix[2][2] + transform.matrix[3][2]
        return Point3D(x: newX, y: newY, z: newZ)
    }
}

extension Point3D : Scalable3D {

    // MARK: - Instance methods

    /// Returns a new entity scaled by the specified size.
    /// 
    /// - Parameter size: A size that contains the scale factors for each axis.
    /// - Returns: A new scaled entity.
    /// - Complexity: O(1)
    @inline(__always)
    public func scaled(by size: Size3D) -> Point3D {
        .init(x: x * size.width, y: y * size.height, z: z * size.depth)
    }

    /// Returns a new entity scaled uniformly by the specified factor.
    /// 
    /// - Parameter scale: A double-precision value that specifies the uniform scale factor.
    /// - Returns: A new scaled entity.
    /// - Complexity: O(1)
    @inline(__always)
    public func uniformlyScaled(by scale: Double) -> Point3D {
        .init(x: x * scale, y: y * scale, z: z * scale)
    }
}

extension Point3D : Translatable3D {

    // MARK: - Instance methods

    /// Returns a new entity translated by the specified vector.
    /// 
    /// - Parameter vector: A vector that contains the translation distances for each axis.
    /// - Returns: A new translated entity.
    /// - Complexity: O(1)
    @inline(__always)
    public func translated(by vector: Vector3D) -> Point3D {
        self + vector
    }
}