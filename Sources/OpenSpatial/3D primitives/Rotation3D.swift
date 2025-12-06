import Foundation

/* TODO: Add support for other rotation types
Examples:
Quando inicializar a estrutura de rotação usando o constructor com EulerAngles (x: 1.0471975511965976, y: 1.0471975511965976, z: 1.0471975511965976, order: .xyz) o 
valor da propriedade angulo, deve ser: 1.3696838321801164, o valor do axis deve ser: (x: 0.2505628070857317, y: 0.9351131265310293, z: 0.2505628070857317), o valor da propriedade quaternion deve
ser (x: 0.15849364905389038, y: 0.5915063509461095, z: 0.15849364905389038, w: 0.774519052838329) e vector deve ser: [0.15849364905389038, 0.5915063509461095, 0.15849364905389038, 0.774519052838329]
*/ 

/// A rotation in three dimensions.
public struct Rotation3D : Copyable, Codable, Equatable, Hashable, Sendable {

    // MARK: - Creating a 3D rotation structure

    /// Creates a rotation
    @inline(__always)
    public init() {
        fatalError("Not implemented")
    }

    /// Creates a rotation structure with the specified Euler angles.
    /// 
    /// - Parameter eulerAngles: A structure that specifies the order and values of the Euler angles.
    @inline(__always)
    public init(eulerAngles: EulerAngles) {
        fatalError("Not implemented")
    }

    /// Creates a rotation structure with the specified quaternion.
    /// 
    /// - Parameter quaternion: A quaternion that represents the rotation.
    @inline(__always)
    public init(quaternion: Quaternion3D) {
        fatalError("Not implemented")
    }

    /// Creates a rotation structure with the specified axis and angle.
    /// 
    /// - Parameter angle: The angle of the rotation.
    /// - Parameter axis: The axis of the rotation.
    @inline(__always)
    public init(angle: Angle2D, axis: RotationAxis3D) {
        fatalError("Not implemented")
    }

    /// Creates a rotation structure with the specified position, target, and up vector.
    /// 
    /// - Parameter position: The position of the rotation.
    /// - Parameter target: The target of the rotation.
    /// - Parameter up: The up vector of the rotation.
    @inline(__always)
    public init(position: Point3D, target: Point3D, up: Vector3D) { 
        fatalError("Not implemented")
    }

    /// Creates a rotation structure with the specified forward vector.
    /// 
    /// - Parameter forward: The forward vector of the rotation.
    @inline(__always)
    public init(forward: Vector3D) { 
        fatalError("Not implemented")
    }

    /// Creates a rotation structure with the specified forward and up vectors.
    /// 
    /// - Parameter forward: The forward vector of the rotation.
    /// - Parameter up: The up vector of the rotation.
    @inline(__always)
    public init(forward: Vector3D, up: Vector3D) { 
        fatalError("Not implemented")
    }

    // MARK: - Inspecting a 3D rotation’s properties

    /// The angle of the rotation.
    public var angle: Angle2D

    /// The axis of the rotation.
    public var axis: RotationAxis3D

    /// A quaternion that represents the rotation.
    public var quaternion: Quaternion3D

    /// The underlying vector of the rotation.
    public var vector: [Double] {
        [quaternion.x, quaternion.y, quaternion.z, quaternion.w]
    }
}