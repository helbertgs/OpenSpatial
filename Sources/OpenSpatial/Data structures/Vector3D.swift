import Foundation

/// A three-element vector.
@frozen public struct Vector3D {

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