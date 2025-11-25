import Foundation

/// Constants that describe an axis.
@frozen
public struct Axis3D : Codable, Copyable, Equatable, Hashable, RawRepresentable, Sendable {

    // MARK: - Constants
    
    /// The operation is along the x-axis.
    @inline(__always)
    public static let x = Axis3D(rawValue: 1 << 0)
    
    /// The operation is along the y-axis.
    @inline(__always)
    public static let y = Axis3D(rawValue: 1 << 1)
    
    /// The operation is along the z-axis.
    @inline(__always)
    public static let z = Axis3D(rawValue: 1 << 2)

    // MARK: - Inspecting the axis
    
    /// The raw value of the axis.
    public let rawValue: Int

    // MARK: - Creating an axis
    
    /// Creates a new axis with the given raw value.
    ///
    /// - Parameter rawValue: The raw value of the axis.
    @inline(__always)
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}