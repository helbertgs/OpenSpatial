import Foundation

/// A quaternion that represents a 3D rotation.
@frozen
public struct Quaternion3D : Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Initializers

    /// Creates a new quaternion
    @inline(__always)
    public init() {
        self.init(x: 0, y: 0, z: 0, w: 1)
    }

    /// Creates a new quaternion structure from the specified double-precision values.
    /// 
    /// - Parameters:
    ///   - x: The x-coordinate value.
    ///   - y: The y-coordinate value.
    ///   - z: The z-coordinate value.
    ///   - w: The w-coordinate value.
    @inline(__always)
    public init(x: Double, y: Double, z: Double, w: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    /// Creates a new quaternion structure from the specified Euler angles.
    /// 
    /// - Parameter eulerAngles: The Euler angles of the quaternion.
    @inline(__always)
    public init(_ angles: EulerAngles, order: EulerAngles.Order = .xyz) {

        let x = angles.x.radians
        let y = angles.y.radians
        let z = angles.z.radians

        let cx = Angle2D.cos(x)
        let cy = Angle2D.cos(y)
        let cz = Angle2D.cos(z)
        let sx = Angle2D.sin(x)
        let sy = Angle2D.sin(y)
        let sz = Angle2D.sin(z)

        switch order {
        case .xyz:
            self.init(
                x: sx * cy * cz + cx * sy * sz, 
                y: cx * sy * cz - sx * cy * sz, 
                z: cx * cy * sz + sx * sy * cz, 
                w: cx * cy * cz - sx * sy * sz
            )
        case .zxy:
            self.init(
                x: sx * cy * cz - cx * sy * sz, 
                y: cx * sy * cz + sx * cy * sz, 
                z: cx * cy * sz - sx * sy * cz, 
                w: cx * cy * cz + sx * sy * sz
            )
        }
    }

    @inline(__always)
    public init(angle: Angle2D, axis: Vector3D) {
        let normalized = axis.normalized
        let x = angle.radians * 0.5
        let sx = Angle2D.sin(x)
        let cx = Angle2D.cos(x)
        self.init(x: normalized.x * sx, y: normalized.y * sx, z: normalized.z * sx, w: cx)
    }

     /// Accesses the x, y, or z value at the specified index.
    /// 
    /// - Parameter index: The index of the value to access. Valid indices are 0, 1, and 2.
    /// - Returns: The x, y, or z value at the specified index.
    /// - Complexity: O(1)
    @inline(__always)
    public subscript(index: Int) -> Double {
        get throws {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            case 3: return w
            default:
                throw Error.outOfRage
            }
        }
    }

    // MARK: - Checking characteristics

    /// The x-coordinate value.
    public var x: Double

    /// The y-coordinate value.
    public var y: Double

    /// The z-coordinate value.
    public var z: Double
    
    /// The w-coordinate value.
    public var w: Double

    /// A simd four-element vector that contains the x-, y-, z-, and w-coordinate values.
    public var vector: [Double] { [x, y, z, w] }

    /// The Euler angles of the quaternion.
    public var eulerAngles: EulerAngles {
        let angle = 2 * acos(w)
        let sin = Angle2D.sqrt(1 - w * w)
        let x = angle * x / sin
        let y = angle * y / sin
        let z = angle * z / sin
        return EulerAngles(x: Angle2D(radians: x), y: Angle2D(radians: y), z: Angle2D(radians: z), order: .xyz)
    }

    /// The squared length of the quaternion.
    public var lengthSquared: Double {
        x * x + y * y + z * z + w * w
    }

    /// The length of the quaternion.
    public var length: Double {
        Angle2D.sqrt(lengthSquared)
    }

    /// Returns the conjugated quaternion.
    @inline(__always) 
    public func conjugated() -> Quaternion3D {
        .init(x: -x, y: -y, z: -z, w: w)
    }

    /// Returns the inverted quaternion.
    @inline(__always) 
    public func inverted() -> Quaternion3D {
        let lenSq = lengthSquared
        guard lenSq > 0 else { return self }
        let conjugate = conjugated()
        let inverse = 1.0 / lenSq
        return .init(
            x: conjugate.x * inverse,
            y: conjugate.y * inverse,
            z: conjugate.z * inverse,
            w: conjugate.w * inverse
        )
    }

    /// Returns the normalized quaternion.
    public var normalized: Quaternion3D {
        let magnitude = length
        guard magnitude > 0 else { return self }
        let inverse = 1.0 / magnitude
        return Quaternion3D(
            x: x * inverse,
            y: y * inverse,
            z: z * inverse,
            w: w * inverse
        )
    }

    /// Returns the product of two quaternions.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand-side quaternion.
    ///   - rhs: The right-hand-side quaternion.
    /// - Returns: The product of the two quaternions.
    /// - Complexity: O(1)
    @inline(__always)
    public static func * (lhs: Quaternion3D, rhs: Quaternion3D) -> Quaternion3D {
        .init(
            x: lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.w * rhs.y - lhs.x * rhs.z + lhs.y * rhs.w + lhs.z * rhs.x,
            z: lhs.w * rhs.z + lhs.x * rhs.y - lhs.y * rhs.x + lhs.z * rhs.w,
            w: lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z
        )
    }
}

extension Quaternion3D : CustomStringConvertible {

    /// A textual representation of the quaternion.
    public var description: String {
        return "(x: \(x), y: \(y), z: \(z), w: \(w))"
    }
}

extension Quaternion3D : ExpressibleByArrayLiteral {

    /// Creates a quaternion from the specified array literal.
    /// 
    /// - Parameter elements: An array of double-precision values.
    @inline(__always)
    public init(arrayLiteral elements: Double...) {
        precondition(elements.count == 4, "Invalid array literal for \(Self.self)")
        self.init(x: elements[0], y: elements[1], z: elements[2], w: elements[3])
    }
}

extension Quaternion3D : Primitive3D {

    /// Returns a Boolean value that indicates whether the quaternion is finite.
    public var isFinite: Bool {
        x.isFinite && y.isFinite && z.isFinite && w.isFinite
    }

    /// Returns a Boolean value that indicates whether the quaternion contains any NaN values.
    public var isNaN: Bool {
        x.isNaN || y.isNaN || z.isNaN || w.isNaN
    }

    /// Returns a Boolean value that indicates whether the quaternion is zero.
    public var isZero: Bool {
        x == 0 && y == 0 && z == 0 && w == 0
    }

    /// Returns a quaternion with infinite values.
    public static var infinity: Quaternion3D {
        .init(x: .infinity, y: .infinity, z: .infinity, w: .infinity)
    }
    
    /// Returns a quaternion with zero values.
    public static var zero: Quaternion3D {
        .init(x: 0, y: 0, z: 0, w: 0)
    }

    /// Returns a new quaternion created by applying an affine transform.
    /// 
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new quaternion created by applying the affine transform.
    /// - Complexity: O(1)
    @inline(__always)
    public func applying(_ transform: AffineTransform3D) -> Quaternion3D {
        let w = 0.5 * Angle2D.sqrt(1 + transform.matrix[0][0] + transform.matrix[1][1] + transform.matrix[2][2])      
        let x = 0.5 * Angle2D.sqrt(1 + transform.matrix[0][0] - transform.matrix[1][1] - transform.matrix[2][2])
        let y = 0.5 * Angle2D.sqrt(1 + transform.matrix[1][1] - transform.matrix[0][0] - transform.matrix[2][2])
        let z = 0.5 * Angle2D.sqrt(1 + transform.matrix[2][2] - transform.matrix[0][0] - transform.matrix[1][1])

        return Quaternion3D(x: x, y: y, z: z, w: w)
    }
}