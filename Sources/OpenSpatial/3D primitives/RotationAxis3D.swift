import Foundation

/// A 3D rotation axis.
@frozen
public struct RotationAxis3D : Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Creating a 3D rotation axis structure

    /// Creates a rotation axis.
    @inline(__always)
    public init() {
        self.init(x: 0, y: 0, z: 0)
    }
    
    /// Creates a rotation axis from the specified floating-point values.
    /// 
    /// - Parameters:
    ///   - x: A floating-point value that specifies the x-coordinate value.
    ///   - y: A floating-point value that specifies the y-coordinate value.
    ///   - z: A floating-point value that specifies the z-coordinate value.
    @inline(__always)
    public init<T>(x: T, y: T, z: T) where T : BinaryFloatingPoint {
        self.init(x: Double(x), y: Double(y), z: Double(z))
    }

    /// Creates a rotation axis from the specified vector.
    /// 
    /// - Parameter xyz: A Spatial vector that specifies the coordinates.
    @inline(__always)
    public init(_ xyz: Vector3D) {
        self.init(x: xyz.x, y: xyz.y, z: xyz.z)
    }

    /// Creates a rotation axis from the specified double-precision values.
    /// 
    /// - Parameters:
    ///   - x: A double-precision value that specifies the x-coordinate value.
    ///   - y: A double-precision value that specifies the y-coordinate value.
    ///   - z: A double-precision value that specifies the z-coordinate value.
    @inline(__always)
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    // MARK: - Checking characteristics

    /// The x-coordinate value.
    public var x: Double

    /// The y-coordinate value.
    public var y: Double

    /// The z-coordinate value.
    public var z: Double

    /// A simd three-element vector that contains the x-, y-, and z-coordinate values.
    public var vector: [Double] { [x, y, z] }

    /// A Boolean value that indicates whether the rotation axis is zero.
    public var isZero: Bool { x == 0 && y == 0 && z == 0 }

    // MARK: - Constants

    /// The zero rotation axis.
    public static let zero = RotationAxis3D()

    /// The x-axis rotation axis.
    public static let x = RotationAxis3D(x: 1, y: 0, z: 0)

    /// The y-axis rotation axis.
    public static let y = RotationAxis3D(x: 0, y: 1, z: 0)
    
    /// The z-axis rotation axis.
    public static let z = RotationAxis3D(x: 0, y: 0, z: 1)

    /// The xy-axis rotation axis.
    public static let xy = RotationAxis3D(x: 1, y: 1, z: 0) 

    /// The yz-axis rotation axis.
    public static let yz = RotationAxis3D(x: 0, y: 1, z: 1)

    /// The xz-axis rotation axis.
    public static let xz = RotationAxis3D(x: 1, y: 0, z: 1)

    /// The xyz-axis rotation axis.
    public static let xyz = RotationAxis3D(x: 1, y: 1, z: 1)
}

extension RotationAxis3D : CustomStringConvertible {

    /// A textual representation of the rotation axis.
    public var description: String {
        return "(x: \(x), y: \(y), z: \(z))"
    }
}

extension RotationAxis3D : ExpressibleByArrayLiteral {

    /// Creates a rotation axis from the specified array literal.
    /// 
    /// - Parameter elements: An array of double-precision values.
    @inline(__always)
    public init(arrayLiteral elements: Double...) {
        guard elements.count == 3 else {
            fatalError("Invalid array literal for RotationAxis3D")
        }

        self.init(x: elements[0], y: elements[1], z: elements[2])
    }
}

extension RotationAxis3D : ExpressibleByFloatLiteral {

    /// Creates a rotation axis from the specified float literal.
    /// 
    /// - Parameter value: A float literal.
    @inline(__always)
    public init(floatLiteral value: Double) {
        self.init(x: Double(value), y: Double(value), z: Double(value))
    }
}

extension RotationAxis3D : ExpressibleByIntegerLiteral {

    /// Creates a rotation axis from the specified integer literal.
    /// 
    /// - Parameter value: An integer literal.
    @inline(__always)
    public init(integerLiteral value: Int) {
        self.init(x: Double(value), y: Double(value), z: Double(value))
    }
}