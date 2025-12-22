import Foundation

/// A vector that represents three Euler angles and specifies the angle ordering.
@frozen
public struct EulerAngles : Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Initializers

    /// Creates a new Euler angles structure.
    @inline(__always)
    public init() {
        self.x = .zero
        self.y = .zero
        self.z = .zero
        self.order = .xyz
    }

    /// Creates a new Euler angles structure from the specified angle structures and order.
    /// 
    /// - Parameters:
    ///   - x: The angle around the x-axis.
    ///   - y: The angle around the y-axis.
    ///   - z: The angle around the z-axis.
    ///   - order: The order of the angles.
    @inline(__always)
    public init(x: Angle2D, y: Angle2D, z: Angle2D, order: EulerAngles.Order) {
        (self.x, self.y, self.z, self.order) = (x, y, z, order)
    }

    // MARK: - Checking characteristics

    /// The angle around the x-axis (Pitch)
    public var x: Angle2D

    /// The angle around the y-axis (Yaw).
    public var y: Angle2D

    /// The angle around the z-axis (Roll).
    public var z: Angle2D

    /// The order of the angles.
    public var order: EulerAngles.Order

    /// A three-element vector that specifies the Euler angles.
    public var angles: [Angle2D] { 
        [x, y, z] 
    }
}

extension EulerAngles : CustomStringConvertible {

    /// A textual representation of the Euler angles.
    public var description: String {
        return "(x: \(x.radians), y: \(y.radians), z: \(z.radians), order: \(order.rawValue))"
    }
}

extension EulerAngles {

    /// The order of the Euler angles.
    public enum Order : String, CaseIterable, Codable, Equatable, Hashable, Sendable {
        
        /// The angles are applied in the order of x, y, z.
        case xyz

        /// The angles are applied in the order of z, x, y.
        case zxy
    }
}