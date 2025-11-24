import Foundation

/// A three-element vector.
@frozen public struct Vector3D {

    // MARK: - Creating a vector

    /// Creates a vector.
    @inline(__always)
    public init() {
        (x, y, z) = (0, 0, 0)
    }

    // MARK: - Inspecting a vector’s properties

    /// The x-element value.
    public let x: Double

    /// The y-element value.
    public let y: Double

    /// The z-element value.
    public let z: Double
}