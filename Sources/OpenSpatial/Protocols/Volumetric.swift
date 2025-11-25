import Foundation

/// A set of methods for working with Spatial primitives with volume.
public protocol Volumetric {

    // MARK: - Instance properties

    /// The size of the volume.
    var size: Size3D { get }

    // MARK: - Instance methods

    /// Returns a Boolean value that indicates whether the entity contains the specified volumetric entity.
    /// 
    /// - Parameter other: The volumetric entity that the function compares against.
    /// - Returns: A Boolean value that indicates whether the entity contains the specified volumetric entity
    func contains(_ other: Self) -> Bool

    /// Returns a Boolean value that indicates whether this volume contains the specified point.
    ///
    /// - Parameter point: The point that the function compares against.
    /// - Returns: A Boolean value that indicates whether this volume contains the specified point.
    func contains(point: Point3D) -> Bool

    /// Returns a Boolean value that indicates whether this volume contains any of the specified points.
    /// 
    /// - Parameter points: The array of points that the function compares against.
    /// - Returns: A Boolean value that indicates whether this volume contains any of the specified points
    func contains(anyOf points: [Point3D]) -> Bool

    /// Sets the primitive to the intersection of itself and the specified primitive.
    /// 
    /// - Parameter other: The primitive to intersect with.
    mutating func formIntersection(_ other: Self)

    /// Sets the primitive to the union of itself and the specified primitive.
    /// 
    /// - Parameter other: The primitive to union with.
    mutating func formUnion(_ other: Self)

    /// Returns the intersection of this primitive and the specified primitive.
    /// 
    /// - Parameter other: The primitive to intersect with.
    /// - Returns: The intersection of this primitive and the specified primitive, or `nil` if they do not intersect.
    func intersection(_ other: Self) -> Self?

    /// Returns the union of this primitive and the specified primitive.
    /// 
    /// - Parameter other: The primitive to union with.
    /// - Returns: The union of this primitive and the specified primitive.
    func union(_ other: Self) -> Self
}

extension Volumetric {

    // MARK: - Instance methods

    /// Returns a Boolean value that indicates whether this volume contains any of the specified points.
    /// 
    /// - Parameter points: The array of points that the function compares against.
    /// - Returns: A Boolean value that indicates whether this volume contains any of the specified points
    public func contains(anyOf points: [Point3D]) -> Bool {
        for point in points {
            if contains(point: point) {
                return true
            }
        }

        return false
    }
}