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