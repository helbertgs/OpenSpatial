import Foundation

/// A set of methods common to Spatial primitives.
public protocol Primitive3D : Codable, Equatable {

    // MARK: - Instance properties

    /// Returns a Boolean value that indicates whether the primitive is infinite.
    var isFinite: Bool { get }

    /// Returns a Boolean value that indicates whether the primitive contains any NaN values.
    var isNaN: Bool { get }

    /// Returns a Boolean value that indicates whether the primitive is zero.
    var isZero: Bool { get }

    // MARK: - Type properties

    /// A primitive with infinite values.
    static var infinity: Self { get }

    /// A primitive with zero values.
    static var zero: Self { get }

    // MARK: - Transforming primitives

    /// Applies an affine transform.
    /// 
    /// - Parameter transform: The affine transform to apply.
    mutating func apply(_ transform: AffineTransform3D)

    /// Returns a new primitive created by applying an affine transform.
    /// 
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new transformed primitive.
    func applying(_ transform: AffineTransform3D) -> Self
}

extension Primitive3D {

    /// Applies an affine transform.
    /// 
    /// - Parameter transform: The affine transform to apply.
    public mutating func apply(_ transform: AffineTransform3D) {
        self = applying(transform)
    }
}