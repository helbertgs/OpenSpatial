import Testing
@testable import OpenSpatial

struct Clampable3DTests {

    @Test func testClampedInsideRect() {
        let rect = Rect3D(origin: Point3D(x: 0, y: 0, z: 0), size: Size3D(width: 10, height: 10, depth: 10))
        let point = Point3D(x: 5, y: 5, z: 5)
        let result = point.clamped(to: rect)
        #expect(result == point)
    }

    @Test func testClampedXBelowMin() {
        let rect = Rect3D(origin: Point3D(x: 1, y: 0, z: 0), size: Size3D(width: 10, height: 10, depth: 10))
        let point = Point3D(x: -3, y: 5, z: 5)
        let result = point.clamped(to: rect)
        #expect(result.x == 1)
        #expect(result.y == 5)
        #expect(result.z == 5)
    }

    @Test func testClampedAllAboveMax() {
        let rect = Rect3D(origin: Point3D(x: 0, y: 0, z: 0), size: Size3D(width: 5, height: 5, depth: 5))
        let point = Point3D(x: 10, y: 20, z: 30)
        let result = point.clamped(to: rect)
        #expect(result.x == 5)
        #expect(result.y == 5)
        #expect(result.z == 5)
    }

    @Test func testMutatingClampMatchesClamped() {
        let rect = Rect3D(origin: Point3D(x: 0, y: 0, z: 0), size: Size3D(width: 10, height: 10, depth: 10))
        var point = Point3D(x: -1, y: 15, z: 5)
        let expected = point.clamped(to: rect)
        point.clamp(to: rect)
        #expect(point == expected)
    }
}
