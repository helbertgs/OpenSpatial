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

    // MARK: - Geometry functions

    /// Returns the cosine of the specified angle.
    /// 
    /// - Parameter x: The angle in radians.
    /// - Returns: The cosine of the angle.
    /// - Complexity: O(1)
    @inline(__always)
    public static func cos(_ x: Double) -> Double {
        var result = 1.0
        var term = 1.0
        let maxIterations = 20
        for n in 1...maxIterations {
            term *= -x * x / Double((2 * n - 1) * (2 * n))
            result += term
            if abs(term) < 1e-15 { break }
        }
        return result
    }

    /// Returns the sine of the specified angle.
    /// 
    /// - Parameter x: The angle in radians.
    /// - Returns: The sine of the angle.
    /// - Complexity: O(1)
    @inline(__always)
    public static func sin(_ x: Double) -> Double {
        var result = x
        var term = x
        let maxIterations = 20
        for n in 1...maxIterations {
            term *= -x * x / Double((2 * n) * (2 * n + 1))
            result += term
            if abs(term) < 1e-15 { break }
        }
        return result
    }

    /// Returns the inverse cosine of the specified value.
    /// 
    /// - Parameter x: The source value.
    /// - Returns: A new angle structure representing the inverse cosine of the specified value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func acos(_ x: Double) -> Angle2D {
        guard x >= -1.0 && x <= 1.0 else {
            return Angle2D(radians: Double.nan)
        }
        
        if x == 1.0 { return Angle2D(radians: 0.0) }
        if x == -1.0 { return Angle2D(radians: .pi) }
        if x == 0.0 { return Angle2D(radians: .pi / 2.0) }

        let asinResult = asin(x)
        return Angle2D(radians: .pi / 2.0 - asinResult.radians)
    }

    /// Returns the inverse hyperbolic cosine of the specified value.
    /// 
    /// - Parameter x: The source value.
    /// - Returns: A new angle structure representing the inverse hyperbolic cosine of the specified value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func acosh(_ x: Double) -> Angle2D {
        guard x >= 1.0 else {
            return Angle2D(radians: Double.nan)
        }
        
        if x == 1.0 { return Angle2D(radians: 0.0) }

        let argument = x + sqrt(x * x - 1.0)
        let result = naturalLog(argument)
        
        return Angle2D(radians: result)
    }
    
    /// Auxiliary function to compute natural logarithm using Taylor series expansion
    /// 
    /// - Parameter x: The value to compute the natural logarithm for.
    /// - Returns: The natural logarithm of x.
    /// - Complexity: O(1)
    @inline(__always)
    private static func naturalLog(_ x: Double) -> Double {
        guard x > 0 else { return Double.nan }
        
        if x == 1.0 { return 0.0 }

        if x > 0.5 && x < 2.0 {
            let u = x - 1.0
            var result = u
            var term = u
            
            for n in 2...50 {
                term *= -u
                result += term / Double(n)
                if abs(term / Double(n)) < 1e-15 { break }
            }
            
            return result
        }

        if x > 2.0 {
            return naturalLog(x / 2.0) + naturalLog(2.0)
        } else {
            return -naturalLog(1.0 / x)
        }
    }
    
    /// Auxiliary function to compute square root using Newton's method
    /// 
    /// - Parameter x: The value to compute the square root for.
    /// - Returns: The square root of x.
    /// - Complexity: O(1)
    @inline(__always)
    private static func sqrt(_ x: Double) -> Double {
        guard x >= 0 else { return Double.nan }
        if x == 0.0 { return 0.0 }
        if x == 1.0 { return 1.0 }
        
        var guess = x / 2.0
        for _ in 0..<20 {
            let newGuess = (guess + x / guess) / 2.0
            if abs(newGuess - guess) < 1e-15 { break }
            guess = newGuess
        }
        
        return guess
    }

    /// Returns the inverse sine of the specified value.
    ///
    /// - Parameter x: The source value.
    /// - Returns: A new angle structure representing the inverse sine of the specified value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func asin(_ x: Double) -> Angle2D {
        guard x >= -1.0 && x <= 1.0 else {
            return Angle2D(radians: Double.nan)
        }

        if x == 0.0 { return Angle2D(radians: 0.0) }
        if x == 1.0 { return Angle2D(radians: .pi / 2.0) }
        if x == -1.0 { return Angle2D(radians: -.pi / 2.0) }

        let absX = abs(x)
        var result = absX
        var term = absX
        let x2 = absX * absX

        for n in 1...20 {
            let numerator = Double(2 * n - 1)
            let denominator = Double(2 * n)
            term *= x2 * numerator / denominator / Double(2 * n + 1)
            result += term

            if abs(term) < 1e-15 { break }
        }
        
        return Angle2D(radians: x < 0 ? -result : result)
    }

    /// Returns the inverse hyperbolic sine of the specified value.
    /// 
    /// - Parameter x: The source value.
    /// - Returns: A new angle structure representing the inverse hyperbolic sine of the specified value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func asinh(_ x: Double) -> Angle2D {
        if x == 0.0 { return Angle2D(radians: 0.0) }

        let absX = abs(x)
        let argument = absX + sqrt(absX * absX + 1.0)
        let result = naturalLog(argument)
        
        return Angle2D(radians: x < 0 ? -result : result)
    }

    /// Returns the inverse tangent of the specified value.
    ///
    /// - Parameter x: The source value.
    /// - Returns: A new angle structure representing the inverse tangent of the specified value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func atan(_ x: Double) -> Angle2D {
        if x == 0.0 { return Angle2D(radians: 0.0) }
        if x == 1.0 { return Angle2D(radians: .pi / 4.0) }
        if x == -1.0 { return Angle2D(radians: -.pi / 4.0) }
        
        let absX = abs(x)
        var result: Double
        
        if absX <= 1.0 {
            result = absX
            var term = absX
            let x2 = absX * absX
            
            for n in 1...50 {
                term *= -x2
                let denominator = Double(2 * n + 1)
                result += term / denominator
                
                if abs(term / denominator) < 1e-15 { break }
            }
        } else {
            let reciprocal = 1.0 / absX
            var atanReciprocal = reciprocal
            var term = reciprocal
            let recip2 = reciprocal * reciprocal
            
            for n in 1...50 {
                term *= -recip2
                let denominator = Double(2 * n + 1)
                atanReciprocal += term / denominator
                
                if abs(term / denominator) < 1e-15 { break }
            }
            
            result = .pi / 2.0 - atanReciprocal
        }
        
        return Angle2D(radians: x < 0 ? -result : result)
    }

    /// Returns the inverse tangent of the specified values.
    /// 
    /// - Parameters:
    ///   - y: The y coordinate.
    ///   - x: The x coordinate.
    /// - Returns: A new angle structure representing the inverse tangent of y/x, considering the quadrant.
    /// - Complexity: O(1)
    @inline(__always)
    public static func atan2(y: Double, x: Double ) -> Angle2D {
        if x == 0.0 && y == 0.0 { return Angle2D(radians: 0.0) }
        if x == 0.0 {
            return Angle2D(radians: y > 0 ? .pi / 2.0 : -.pi / 2.0)
        }
        if y == 0.0 {
            return Angle2D(radians: x > 0 ? 0.0 : .pi)
        }
        
        let atanResult = atan(y / x)

        if x > 0 {
            return atanResult
        } else if x < 0 {
            if y >= 0 {
                return Angle2D(radians: atanResult.radians + .pi)
            } else {
                return Angle2D(radians: atanResult.radians - .pi)
            }
        } else {
            return Angle2D(radians: y > 0 ? .pi / 2.0 : -.pi / 2.0)
        }
    }

    /// Returns the inverse hyperbolic tangent of the specified value.
    /// 
    /// - Parameter x: The source value.
    /// - Returns: A new angle structure representing the inverse hyperbolic tangent of the specified value.
    /// - Complexity: O(1)
    @inline(__always)
    public static func atanh(_ x: Double) -> Angle2D {
        guard x > -1.0 && x < 1.0 else {
            return Angle2D(radians: Double.nan)
        }

        if x == 0.0 { return Angle2D(radians: 0.0) }

        let numerator = 1.0 + x
        let denominator = 1.0 - x
        let ratio = numerator / denominator
        let result = 0.5 * naturalLog(ratio)

        return Angle2D(radians: result)
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