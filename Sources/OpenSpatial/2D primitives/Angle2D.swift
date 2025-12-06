import Foundation

/// A geometric angle with a value you access in either radians or degrees.
@frozen 
public struct Angle2D : Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Inspecting an angle’s properties

    /// The angle in degrees.
    public var degrees: Double {
        radians * 180.0 / .pi
    }

    /// The angle in radians.
    public let radians: Double

    // MARK: - Creating an angle structure

    /// Creates an angle.
    @inline(__always)
    public init() {
        radians = 0
    }

    /// Creates an angle with the specified double-precision radians.
    /// 
    /// - Parameter radians: The angle in radians.
    @inline(__always)
    public init(radians: Double) {
        self.radians = radians
    }

    /// Creates an angle with the specified floating-point radians.
    /// 
    /// - Parameter radians: The angle in radians.
    @inline(__always)
    public init<T>(radians: T) where T : BinaryFloatingPoint {
        self.radians = Double(radians)
    }

    /// Creates an angle with the specified double-precision degrees.
    /// 
    /// - Parameter degrees: The angle in degrees.
    @inline(__always)
    public init(degrees: Double) {
        self.radians = degrees * .pi / 180.0
    }

    /// Creates an angle with the specified floating-point degrees.
    /// 
    /// - Parameter degrees: The angle in degrees.
    @inline(__always)
    public init<T>(degrees: T) where T : BinaryFloatingPoint {
        self.radians = Double(degrees) * .pi / 180.0
    }

    /// Returns a new angle structure with the specified double-precision degrees.
    /// 
    /// - Parameter degrees: The angle in degrees.
    /// - Returns: A new angle structure.
    /// - Complexity: O(1)
    @inline(__always)
    public static func degrees(_ degrees: Double) -> Angle2D {
        Angle2D(degrees: degrees)
    }

    /// Returns a new angle structure with the specified double-precision radians.
    /// 
    /// - Parameter radians: The angle in radians.
    /// - Returns: A new angle structure.
    /// - Complexity: O(1)
    @inline(__always)
    public static func radians(_ radians: Double) -> Angle2D {
        Angle2D(radians: radians)
    }
}

extension Angle2D : ExpressibleByFloatLiteral {

    /// Creates an angle with the specified floating-point literal value in radians.
    /// 
    /// - Parameter value: The angle in radians.
    @inline(__always)
    public init(floatLiteral value: Double) {
        self.radians = value
    }
}

extension Angle2D : ExpressibleByIntegerLiteral {

    /// Creates an angle with the specified integer literal value in radians.
    /// 
    /// - Parameter value: The angle in radians.
    @inline(__always)
    public init(integerLiteral value: Int) {
        self.radians = Double(value)
    }
}

extension Angle2D : AdditiveArithmetic {

    /// The zero angle.
    public static var zero: Angle2D {
        Angle2D(radians: 0)
    }

    /// Adds two angles and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The first angle to add.
    ///   - rhs: The second angle to add.
    /// - Returns: The sum of the two angles.
    /// - Complexity: O(1)
    @inline(__always)
    public static func + (lhs: Angle2D, rhs: Angle2D) -> Angle2D {
        Angle2D(radians: lhs.radians + rhs.radians)
    }

    /// Adds an angle to another angle and stores the result in the left-hand side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The angle to add to.
    ///   - rhs: The angle to add.
    /// - Complexity: O(1)
    @inline(__always)
    public static func += (lhs: inout Angle2D, rhs: Angle2D) {
        lhs = lhs + rhs
    }

    /// Subtracts one angle from another and returns the result.
    /// 
    /// - Parameters:
    ///   - lhs: The angle to subtract from.
    ///   - rhs: The angle to subtract.
    /// - Returns: The difference of the two angles.
    /// - Complexity: O(1)
    @inline(__always)
    public static func - (lhs: Angle2D, rhs: Angle2D) -> Angle2D {
        Angle2D(radians: lhs.radians - rhs.radians)
    }

    /// Subtracts an angle from another angle and stores the result in the left-hand side variable.
    /// 
    /// - Parameters:
    ///   - lhs: The angle to subtract from.
    ///   - rhs: The angle to subtract.
    /// - Complexity: O(1)
    @inline(__always)
    public static func -= (lhs: inout Angle2D, rhs: Angle2D) {
        lhs = lhs - rhs
    }
}

extension Angle2D : Comparable {

    /// Compares two angles to determine if the left-hand side angle is less than the right-hand side angle.
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A Boolean value indicating whether the left-hand side angle is less than the right-hand side angle.
    public static func < (lhs: Angle2D, rhs: Angle2D) -> Bool {
        lhs.radians < rhs.radians && lhs.degrees < rhs.degrees
    }

    /// Compares two angles to determine if the left-hand side angle is greater than the right-hand side angle.
    /// - Parameters:
    ///   - lhs: The left-hand side angle.
    ///   - rhs: The right-hand side angle.
    /// - Returns: A Boolean value indicating whether the left-hand side angle is greater than the right-hand side angle.
    public static func > (lhs: Angle2D, rhs: Angle2D) -> Bool {
        lhs.radians > rhs.radians && lhs.degrees > rhs.degrees
    }
}

extension Angle2D {

    /// The value of π.
    public static var pi: Double {
        3.141592653589793238462643383279502884
    }

    /// Returns the square root of the value.
    /// 
    /// - Parameter value: The value to square root.
    /// - Returns: The square root of the value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func sqrt(_ value: Double) -> Double {
        if value <= 0 { return 0 }
        var guess = value > 1 ? value : 1.0
        for _ in 0..<8 {
            guess = 0.5 * (guess + value / guess)
        }
        return guess
    }

    /// Normalizes the angle.
    /// 
    /// - Parameter angle: The angle to normalize.
    /// - Returns: The normalized angle.
    /// - Complexity: O(1)
    @inline(__always)
    public static func normalize(_ angle: Angle2D) -> Double {
        self.normalize(angle.radians)
    }

    /// Normalizes the angle.
    /// 
    /// - Parameter value: The value to normalize.
    /// - Returns: The normalized value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func normalize(_ value: Double) -> Double {
        guard value.isFinite else { return 0 }

        var value = value
        value = value.truncatingRemainder(dividingBy: 2 * pi)

        if value > pi { value -= 2 * pi }
        if value < -pi { value += 2 * pi }

        return value
    }

    /// Returns the sine of the angle.
    /// 
    /// - Parameter value: The angle in radians.
    /// - Returns: The sine of the angle.
    /// - Complexity: O(1)
    @inline(__always)
    public static func sin(_ value: Double) -> Double {
        let x = normalize(value)
        let x2 = x * x
        let x3 = x2 * x
        let x5 = x2 * x3
        let x7 = x2 * x5
        let x9 = x2 * x7
        
        return x - x3 / 6.0 + x5 / 120.0 - x7 / 5040.0 + x9 / 362880.0
    }

    /// Returns the cosine of the angle.
    /// 
    /// - Parameter value: The angle in radians.
    /// - Returns: The cosine of the angle.
    /// - Complexity: O(1)
    @inline(__always)
    public static func cos(_ value: Double) -> Double {
        let x = normalize(value)
        let x2 = x * x
        let x4 = x2 * x2
        let x6 = x2 * x4
        let x8 = x4 * x4
        let x10 = x2 * x8
        return 1 - x2 / 2.0 + x4 / 24.0 - x6 / 720.0 + x8 / 40320.0 - x10 / 3628800.0
    }

    /// Returns the tangent of the angle.
    /// 
    /// - Parameter value: The angle in radians.
    /// - Returns: The tangent of the angle.
    /// - Complexity: O(1)
    @inline(__always)
    public static func tan(_ value: Double) -> Double {
        sin(value) / cos(value)
    }

    /// Returns the arcsine of the angle.
    /// 
    /// - Parameter value: The angle in radians.
    /// - Returns: The arcsine of the angle.
    /// - Complexity: O(1)
    @inline(__always)
    public static func asin(_ value: Double) -> Double {
        let x = normalize(value)
        let x2 = x * x
        let x3 = x2 * x
        let x5 = x2 * x3
        let x7 = x2 * x5
        let x9 = x2 * x7
        return x + x3 / 6.0 + x5 / 120.0 + x7 / 5040.0 + x9 / 362880.0
    }
}