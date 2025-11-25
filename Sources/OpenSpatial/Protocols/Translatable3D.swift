import Foundation

/// A set of methods that defines the interface to translate Spatial entities.
public protocol Translatable3D : Equatable {

    // MARK: - Instance methods

    /// Translates the entity by the specified vector.
    /// 
    /// - Parameter vector: The vector by which to translate the entity.
    mutating func translate(by vector: Vector3D)

    /// Returns a new entity translated by the specified vector.
    /// 
    /// - Parameter vector: The vector by which to translate the entity.
    /// - Returns: A new translated entity.
    func translated(by vector: Vector3D) -> Self
}

extension Translatable3D {

    // MARK: - Instance methods

    /// Translates the entity by the specified vector.
    /// 
    /// - Parameter vector: The vector by which to translate the entity.
    /// - Complexity: O(1)
    @inline(__always)
    public mutating func translate(by vector: Vector3D) {
        self = translated(by: vector)
    }
}