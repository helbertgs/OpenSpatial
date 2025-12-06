import Foundation

/// A set of methods that defines the interface to rotate Spatial entities.
public protocol Rotatable3D {

    /// Rotates the entity by a quaternion.
    /// 
    /// - Parameter quaternion: The quaternion to apply.
    mutating func rotate(by quaternion: Quaternion3D)

    /// Returns the entity that results from applying the specified quaternion.
    /// 
    /// - Parameter quaternion: The quaternion to apply.
    /// - Returns: A new rotated entity.
    func rotated(by quaternion: Quaternion3D) -> Self
}

extension Rotatable3D {

    // MARK: - Instance methods

    /// Rotates the entity by a quaternion.
    /// 
    /// - Parameter quaternion: The quaternion to apply.
    @inline(__always)
    public mutating func rotate(by quaternion: Quaternion3D) {
        self = rotated(by: quaternion)
    }
}