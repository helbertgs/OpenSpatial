import Foundation

/// A three-element vector.
@frozen public struct Vector3D : Codable, Equatable, Hashable, Sendable {

    // MARK: - Creating a vector

    /// Creates a vector.
    @inline(__always)
    public init() {
        (x, y, z) = (0, 0, 0)
    }

    /// Creates a vector from the specified double-precision values.
    /// 
    /// - Parameters:
    ///   - x: A double-precision value that specifies the x value. The default is `0`.
    ///   - y: A double-precision value that specifies the y value. The default is `0`.
    ///   - z: A double-precision value that specifies the z value. The default is `0`.
    @inline(__always)
    public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        (self.x, self.y, self.z) = (x, y, z)
    }

    /// Creates a vector from the specified floating-point values.
    /// 
    /// - Parameters:
    ///   - x: A floating-point value that specifies the x value.
    ///   - y: A floating-point value that specifies the y value.
    ///   - z: A floating-point value that specifies the z value.
    @inline(__always)
    public init<T>(x: T, y: T, z: T) where T : BinaryFloatingPoint {
        (self.x, self.y, self.z) = (Double(x), Double(y), Double(z))
    }

    // MARK: - Inspecting a vector’s properties

    /// The x-element value.
    public let x: Double

    /// The y-element value.
    public let y: Double

    /// The z-element value.
    public let z: Double

    // MARK: - Geometry functions

    /// Returns the cross product of the vector and the specified vector.
    /// 
    /// - Parameter other: The second vector.
    /// - Returns: The cross product vector.
    /// - Complexity: O(1)
    @inline(__always)
    public func cross(_ other: Vector3D) -> Vector3D {
        .init(
            x: y * other.z - z * other.y,
            y: z * other.x - x * other.z,
            z: x * other.y - y * other.x
        )
    }

    /// Returns the dot product of the vector and the specified vector.
    /// 
    /// - Parameter other: The second vector.
    /// - Returns: The dot product value.
    /// - Complexity: O(1)
    @inline(__always)
    public func dot(_ other: Vector3D) -> Double {
        x * other.x + y * other.y + z * other.z
    }

    /// The length (magnitude) of the vector.
    public var length: Double {
        sqrt(x * x + y * y + z * z)
    }

    /// The squared length of the vector.
    public var lengthSquared: Double {
        x * x + y * y + z * z
    }

    /// Normalizes the mutable vector.
    /// 
    /// - Complexity: O(1)
    @inline(__always)
    public mutating func normalize() {
        let len = length
        guard len != 0 else { return }
        self = Vector3D(x: x / len, y: y / len, z: z / len)
    }

    /// A new vector that represents the normalized copy of the current vector.
    public var normalized: Vector3D {
        var vector = self
        vector.normalize()
        return vector
    }

    /// Returns the vector projected onto the specified vector.
    /// 
    /// - Parameter other: The second vector.
    /// - Returns: The projected vector.
    /// - Complexity: O(1)
    @inline(__always)
    public func projected(_ other: Vector3D) -> Vector3D {
        let otherLengthSquared = other.lengthSquared
        guard otherLengthSquared != 0 else { return .zero }
        let scalar = dot(other) / otherLengthSquared
        return Vector3D(x: other.x * scalar, y: other.y * scalar, z: other.z * scalar)
    }

    /// Returns the reflection direction of the incident vector and a specified unit normal vector.
    /// 
    /// - Parameter normal: The unit normal vector.
    /// - Returns: The reflected vector.
    /// - Complexity: O(1)
    @inline(__always)
    public func reflected(_ normal: Vector3D) -> Vector3D {
        let dotProduct = self.dot(normal)
        return Vector3D(
            x: self.x - 2 * dotProduct * normal.x,
            y: self.y - 2 * dotProduct * normal.y,
            z: self.z - 2 * dotProduct * normal.z
        )
    }

    // MARK: - Type properties

    /// A vector that contains the values 0, 0, -1.
    public static let backward = Vector3D(x: 0, y: 0, z: -1)

    /// A vector that contains the values 0, 0, 1.
    public static let forward = Vector3D(x: 0, y: 0, z: 1)

    /// A vector that contains the values -1, 0, 0.
    public static let left = Vector3D(x: -1, y: 0, z: 0)

    /// A vector that contains the values 1, 0, 0.
    public static let right = Vector3D(x: 1, y: 0, z: 0)

    /// A vector that contains the values 0, 1, 0.
    public static let up = Vector3D(x: 0, y: 1, z: 0)

    /// A vector that contains the values 0, -1, 0.
    public static let down = Vector3D(x: 0, y: -1, z: 0)
}

extension Vector3D : ExpressibleByArrayLiteral {

    /// Creates an instance initialized with the given elements.
    /// 
    /// - Parameter elements: The elements of the array literal.
    @inline(__always)
    public init(arrayLiteral elements: Double...) {
        precondition(elements.count == 3, "Array literal must contain exactly three elements.")
        (x, y, z) = (elements[0], elements[1], elements[2])
    }
}

extension Vector3D : AdditiveArithmetic {

    // MARK: - Applying arithmetic operations

    /// The zero vector.
    public static let zero = Vector3D()

    /// Returns a vector that’s the product of a vector and a scalar value.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side scalar value.
    /// - Returns: The product of the vector and the scalar.
    /// - Complexity: O(1)
    @inline(__always)
    public static func * (lhs: Vector3D, rhs: Double) -> Vector3D {
        .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    /// Multiplies a vector and a double-precision value, and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func *= (lhs: inout Vector3D, rhs: Double) {
        lhs = lhs * rhs
    }

    /// Adds two vectors and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The first vector.
    ///   - rhs: The second vector.
    /// - Returns: The sum of the two vectors.
    /// - Complexity: O(1)
    @inline(__always)
    public static func + (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    /// Adds the second vector to the first vector and stores the result in the first vector.
    /// 
    /// - Parameters:
    ///   - lhs: The first vector.
    ///   - rhs: The second vector.
    /// - Complexity: O(1)
    @inline(__always)
    public static func += (lhs: inout Vector3D, rhs: Vector3D) {
        lhs = lhs + rhs
    }

    /// Subtracts one vector from another and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The first vector.
    ///   - rhs: The second vector.
    /// - Returns: The difference of the two vectors.
    /// - Complexity: O(1)
    @inline(__always)
    public static func - (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    /// Subtracts the second vector from the first vector and stores the result in the first vector.
    /// 
    /// - Parameters:
    ///   - lhs: The first vector.
    ///   - rhs: The second vector.
    /// - Complexity: O(1)
    @inline(__always)
    public static func -= (lhs: inout Vector3D, rhs: Vector3D) {
        lhs = lhs - rhs
    }

    /// Returns a vector with each element divided by a scalar value.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Returns: The resulting vector.
    /// - Complexity: O(1)
    @inline(__always)
    public static func / (lhs: Vector3D, rhs: Double) -> Vector3D {
        .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    /// Divides each element of the vector by a scalar value and stores the result in the left-hand-side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func /= (lhs: inout Vector3D, rhs: Double) {
        lhs = lhs / rhs
    }
}

extension Vector3D : Primitive3D {

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
    public static var infinity: Vector3D {
        .init(x: .infinity, y: .infinity, z: .infinity)
    }
}