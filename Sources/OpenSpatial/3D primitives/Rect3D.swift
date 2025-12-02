import Foundation

/// A rectangle in a 3D coordinate system.
public struct Rect3D : Copyable, Codable, Equatable, Hashable {

    // MARK: - Creating a 3D rectangle structure

    /// Creates a rectangle structure.
    @inline(__always)
    public init() {
        self.init(
            origin: Point3D.zero, 
            size: Size3D.zero
        )
    }

    /// Creates a rectangle with the specified center and the specified size from Spatial structures.
    /// 
    /// - Parameters:
    ///  - center: The center point of the rectangle. The default is the origin point
    ///  - size: The size of the rectangle.
    @inline(__always)
    public init(center: Point3D, size: Size3D) {
        self.init(
            origin: Point3D(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                z: center.z - size.depth / 2
            ), 
            size: size
        )
    }

    /// Creates a rectangle with the specified center and the specified size from Spatial vectors.
    /// 
    /// - Parameters:
    ///  - center: The center point of the rectangle. The default is the origin point
    ///  - size: The size of the rectangle.
    @inline(__always)
    public init(center: Vector3D = .zero, size: Vector3D) {
        self.init(
            center: Point3D(x: center.x, y: center.y, z: center.z),
            size: Size3D(width: size.x, height: size.y, depth: size.z)
        )
    }

    /// Creates a rectangle with the specified origin and the specified size from Spatial vectors.
    /// 
    /// - Parameters:
    ///  - origin: The origin point of the rectangle. The default is the origin point
    ///  - size: The size of the rectangle.
    @inline(__always)
    public init(origin: Vector3D = .zero, size: Vector3D) {
        self.init(
            origin: Point3D(x: origin.x, y: origin.y, z: origin.z),
            size: Size3D(width: size.x, height: size.y, depth: size.z)
        )
    }

    /// Creates a rectangle at the specified origin and the specified size from Spatial structures.
    /// 
    /// - Parameters:
    ///   - origin: The origin point of the rectangle. The default is the origin point
    ///   - size: The size of the rectangle.
    @inline(__always)
    public init(origin: Point3D, size: Size3D) {
        self.origin = origin
        self.size = size
    }

    // MARK: - Inspecting a 3D rectangle’s properties

    /// The center of the rectangle.
    @inline(__always)
    public var center: Point3D {
        Point3D(
            x: origin.x + size.width / 2,
            y: origin.y + size.height / 2,
            z: origin.z + size.depth / 2
        )
    }

    /// The corner points of the rectangle.
    @inline(__always)
    public var cornerPoints: [Point3D] {[
        Point3D(x: origin.x, y: origin.y, z: origin.z),
        Point3D(x: origin.x, y: origin.y + size.height, z: origin.z),
        Point3D(x: origin.x + size.width, y: origin.y + size.height, z: origin.z),
        Point3D(x: origin.x + size.width, y: origin.y, z: origin.z),
        Point3D(x: origin.x, y: origin.y, z: origin.z + size.depth),
        Point3D(x: origin.x, y: origin.y + size.height, z: origin.z + size.depth),
        Point3D(x: origin.x + size.width, y: origin.y + size.height, z: origin.z + size.depth),
        Point3D(x: origin.x + size.width, y: origin.y, z: origin.z + size.depth)
    ]}

    /// A point that represents the corner of the rectangle with the largest x-, y-, and z-coordinates.
    @inline(__always)
    public var max: Point3D {
        origin + size
    }

    /// A point that represents the corner of the rectangle with the smallest x-, y-, and z-coordinates.
    @inline(__always)
    public var min: Point3D {
        origin
    }

    /// The origin of the rectangle.
    public private(set) var origin: Point3D

    /// The size of the rectangle.
    public private(set) var size: Size3D

    // MARK: - Checking characteristics

    /// Returns a Boolean value that indicates whether two rectangles intersect.
    /// 
    /// - Parameter other: The other rectangle to compare against.
    /// - Returns: A Boolean value that indicates whether the two rectangles intersect.
    /// - Complexity: O(1)
    @inline(__always)
    public func intersects(_ other: Rect3D) -> Bool {
        !(
            other.min.x > max.x ||
            other.max.x < min.x ||
            other.min.y > max.y ||
            other.max.y < min.y ||
            other.min.z > max.z ||
            other.max.z < min.z
        )
    }

    /// A Boolean value that indicates whether two or three of the dimensions are zero.
    @inline(__always)
    public var isEmpty: Bool {
        size.width == 0 || size.height == 0 || size.depth == 0
    }

    // MARK: - Creating derived 3D rectangles

    @inline(__always)
    public var integral: Rect3D {
        .init(
            origin: Point3D(x: floor(origin.x), y: floor(origin.y), z: floor(origin.z)),
            size: Size3D(width: ceil(size.width), height: ceil(size.height), depth: ceil(size.depth)
            )
        )
    }

    /// A rectangle with positive dimensions.
    @inline(__always)
    public var standardized: Rect3D {
        var newOrigin = origin
        var newSize = size

        if size.width < 0 {
            newOrigin.x += size.width
            newSize.width = -size.width
        }

        if size.height < 0 {
            newOrigin.y += size.height
            newSize.height = -size.height
        }

        if size.depth < 0 {
            newOrigin.z += size.depth
            newSize.depth = -size.depth
        }

        return Rect3D(origin: newOrigin, size: newSize)
    }
}

extension Rect3D : CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// A textual representation of the rectangle.
    public var description: String {
        "(origin: \(origin), size: \(size))"
    }
}

extension Rect3D : Primitive3D {

    // MARK: - Primitive3D

    /// Returns a Boolean value that indicates whether the primitive is infinite.
    public var isFinite: Bool {
        origin.isFinite && size.isFinite
    }

    /// Returns a Boolean value that indicates whether the primitive contains any NaN values.
    public var isNaN: Bool {
        origin.isNaN || size.isNaN
    }

    /// Returns a Boolean value that indicates whether the primitive is zero.
    public var isZero: Bool {
        origin.isZero && size.isZero
    }

    // MARK: - Type properties

    /// A primitive with infinite values.
    public static var infinity: Rect3D {
        .init(origin: Point3D.infinity, size: Size3D.infinity)
    }

    /// A primitive with zero values.
    public static var zero: Rect3D {
        .init(origin: Point3D.zero, size: Size3D.zero)
    }

    // MARK: - Transforming primitives

    /// Applies an affine transform.
    /// 
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new transformed rectangle.
    /// - Complexity: O(1)
    @inline(__always)
    public func applying(_ transform: AffineTransform3D) -> Rect3D {
        .init(origin: origin.applying(transform), size: size.applying(transform))
    }
}

extension Rect3D : Scalable3D {

    // MARK: - Scalable3D

    /// Returns a new rectangle with the scaled size.
    /// 
    /// - Parameter size: The size to scale the rectangle by.
    /// - Returns: A new scaled rectangle.
    /// - Complexity: O(1)
    @inline(__always)
    public func scaled(by size: Size3D) -> Rect3D {
        .init(
            origin: origin.scaled(by: size), 
            size: self.size.scaled(by: size)
        )
    }

    /// Returns a new rectangle with the uniformly scaled size.
    /// 
    /// - Parameter scale: The scale factor.
    /// - Returns: A new uniformly scaled rectangle.
    /// - Complexity: O(1)
    @inline(__always)
    public func uniformlyScaled(by scale: Double) -> Rect3D {
        .init(origin: origin.uniformlyScaled(by: scale), size: size.uniformlyScaled(by: scale))
    }
}

extension Rect3D : Translatable3D {

    // MARK: - Translatable3D

    /// Returns a new rectangle with the translated origin.
    /// 
    /// - Parameter vector: The translation vector.
    /// - Returns: A new translated rectangle.
    /// - Complexity: O(1)
    @inline(__always)
    public func translated(by vector: Vector3D) -> Rect3D {
        .init(origin: origin.translated(by: vector), size: size)
    }
}

extension Rect3D : Volumetric {

    // MARK: - Instance methods

    /// Returns a Boolean value that indicates whether the entity contains the specified volumetric entity.
    /// 
    /// - Parameter other: The volumetric entity that the function compares against.
    /// - Returns: A Boolean value that indicates whether the entity contains the specified volumetric entity
    @inline(__always)
    public func contains(_ other: Rect3D) -> Bool {
        other.min.x >= min.x && other.max.x <= max.x &&
        other.min.y >= min.y && other.max.y <= max.y &&
        other.min.z >= min.z && other.max.z <= max.z
    }

    /// Returns a Boolean value that indicates whether this volume contains the specified point.
    ///
    /// - Parameter point: The point that the function compares against.
    /// - Returns: A Boolean value that indicates whether this volume contains the specified point.
    @inline(__always)
    public func contains(point: Point3D) -> Bool {
        point.x >= min.x && point.x <= max.x &&
        point.y >= min.y && point.y <= max.y &&
        point.z >= min.z && point.z <= max.z
    }

    /// Returns the intersection of this primitive and the specified primitive.
    /// 
    /// - Parameter other: The rectangle to intersect with.
    /// - Returns: The intersection of this primitive and the specified primitive, or `nil` if they do not intersect.
    @inline(__always)
    public func intersection(_ other: Rect3D) -> Rect3D? {
        let newMin = Point3D(x: Swift.max(min.x, other.min.x), y: Swift.max(min.y, other.min.y), z: Swift.max(min.z, other.min.z))
        let newMax = Point3D(x: Swift.min(max.x, other.max.x), y: Swift.min(max.y, other.max.y), z: Swift.min(max.z, other.max.z))

        if newMin.x <= newMax.x && newMin.y <= newMax.y && newMin.z <= newMax.z {
            return Rect3D(origin: newMin, size: Size3D(width: newMax.x - newMin.x, height: newMax.y - newMin.y, depth: newMax.z - newMin.z))
        } else {
            return nil
        }
    }

    /// Returns the union of this rectangle and the specified rectangle.
    ///     
    /// - Parameter other: The rectangle to union with.
    /// - Returns: The union of this rectangle and the specified rectangle.
    @inline(__always)
    public func union(_ other: Rect3D) -> Rect3D {
        let origin = Point3D(x: Swift.min(origin.x, other.origin.x), y: Swift.min(origin.y, other.origin.y), z: Swift.min(origin.z, other.origin.z))
        let size = Size3D(width: Swift.max(size.width, other.size.width), height: Swift.max(size.height, other.size.height), depth: Swift.max(size.depth, other.size.depth))

        return Rect3D(origin: origin, size: size)
    }
}
