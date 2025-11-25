import Foundation

/// A protocol that defines scalable 3D types.
public protocol Scalable3D {

    // MARK: - Instance methods

    /// Scales the entity by the specified size.
    /// 
    /// - Parameter size: A size that contains the scale factors for each axis.
    mutating func scale(by size: Size3D)

    /// Scales the entity by the specified factors.
    /// 
    /// - Parameters:
    ///   - x: A double-precision value that specifies the scale factor for the x-axis.
    ///   - y: A double-precision value that specifies the scale factor for the y-axis.
    ///   - z: A double-precision value that specifies the scale factor for the z-axis.
    mutating func scaleBy(x: Double, y: Double, z: Double)

    /// Returns a new entity scaled by the specified size.
    /// 
    /// - Parameter size: A size that contains the scale factors for each axis.
    /// - Returns: A new scaled entity.
    func scaled(by size: Size3D) -> Self

    /// Scales the entity uniformly by the specified factor.
    /// 
    /// - Parameter scale: A double-precision value that specifies the uniform scale factor.
    mutating func uniformlyScale(by scale: Double)

    /// Returns a new entity scaled uniformly by the specified factor.
    /// 
    /// - Parameter scale: A double-precision value that specifies the uniform scale factor.
    /// - Returns: A new scaled entity.
    func uniformlyScaled(by scale: Double) -> Self
}

extension Scalable3D {

    /// Scales the entity by the specified size.
    /// 
    /// - Parameter size: A size that contains the scale factors for each axis.
    public mutating func scale(by size: Size3D) {
        self = self.scaled(by: size)
    }

    /// Scales the entity by the specified factors.
    /// 
    /// - Parameters:
    ///   - x: A double-precision value that specifies the scale factor for the x-axis.
    ///   - y: A double-precision value that specifies the scale factor for the y-axis.
    ///   - z: A double-precision value that specifies the scale factor for the z-axis.
    public mutating func scaleBy(x: Double, y: Double, z: Double) {
        self.scale(by: Size3D(width: x, height: y, depth: z))
    }

    /// Scales the entity uniformly by the specified factor.
    /// 
    /// - Parameter scale: A double-precision value that specifies the uniform scale factor.
    public mutating func uniformlyScale(by scale: Double) {
        self.scale(by: Size3D(width: scale, height: scale, depth: scale))
    }
}