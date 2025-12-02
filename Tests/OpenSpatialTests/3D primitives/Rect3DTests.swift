import Testing
@testable import OpenSpatial

struct Rect3DTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let rect = Rect3D()
        #expect(rect.origin == Point3D.zero)
        #expect(rect.min == Point3D.zero)
        #expect(rect.max == Point3D.zero)
        #expect(rect.center == Point3D.zero)
    }

    @Test func testInitializationWithOriginAndSize() {
        let origin = Point3D(x: -1.0, y: -1.0, z: -1.0)
        let size = Size3D(width: 2.0, height: 2.0, depth: 2.0)
        let rect = Rect3D(origin: origin, size: size)
        #expect(rect.origin == origin)
        #expect(rect.min == origin)
        #expect(rect.max == Point3D(x: 1.0, y: 1.0, z: 1.0))
        #expect(rect.center == Point3D(x: 0.0, y: 0.0, z: 0.0))
    }

    @Test func testInitializationWithCenterAndSize() {
        let center = Point3D(x: 3, y: -2, z: 9)
        let size = Size3D(width: 2.5, height: 3.71, depth: 1.44)
        let rect = Rect3D(center: center, size: size)

        #expect(rect.origin == Point3D(x: 1.75, y: -3.855, z: 8.28))
        #expect(rect.min == Point3D(x: 1.75, y: -3.855, z: 8.28))
        #expect(rect.center == Point3D(x: 3.0, y: -2.0, z: 9.0))
        #expect(rect.max == Point3D(x: 4.25, y: -0.14500000000000002, z: 9.719999999999999))
        #expect(rect.cornerPoints == [
                .init(x: 1.75, y: -3.855, z: 8.28), 
                .init(x: 1.75, y: -0.14500000000000002, z: 8.28), 
                .init(x: 4.25, y: -0.14500000000000002, z: 8.28), 
                .init(x: 4.25, y: -3.855, z: 8.28), 
                .init(x: 1.75, y: -3.855, z: 9.719999999999999), 
                .init(x: 1.75, y: -0.14500000000000002, z: 9.719999999999999),
                .init(x: 4.25, y: -0.14500000000000002, z: 9.719999999999999), 
                .init(x: 4.25, y: -3.855, z: 9.719999999999999)
            ]
        )
        // #expect(rect.integral == Rect3D(origin: Point3D(x: 3.0, y: -2.0, z: 9.0), size: Size3D(width: 3.0, height: 4.0, depth: 2.0)))
        // #expect(rect.standardized == Rect3D(origin: Point3D(x: 3.0, y: -2.0, z: 9.0), size: Size3D(width: 2.5, height: 3.71, depth: 1.44)))
    }

    // MARK: - Primitive3D tests

    @Test func testApplyingAffineTransform() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let transform = AffineTransform3D(matrix: [
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [2.0, 4.0, 6.0, 1.0]
        ])
        let transformed = rect.applying(transform)
        #expect(transformed == Rect3D(origin: Point3D(x: 3.0, y: 6.0, z: 9.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0)))
    }

    // MARK: - Scalable3D tests

    @Test func testScalingRect3D() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let scaled = rect.scaled(by: Size3D(width: 2.0, height: 3.0, depth: 4.0))
        #expect(scaled == Rect3D(origin: Point3D(x: 2.0, y: 6.0, z: 12.0), size: Size3D(width: 8.0, height: 15.0, depth: 24.0)))
    }

    @Test func testUniformlyScalingRect3D() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let uniformlyScaled = rect.uniformlyScaled(by: 2.0)
        #expect(uniformlyScaled == Rect3D(origin: Point3D(x: 2.0, y: 4.0, z: 6.0), size: Size3D(width: 8.0, height: 10.0, depth: 12.0)))
    }

    // MARK: - Translatable3D tests

    @Test func testTranslatingRect3D() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let translated = rect.translated(by: Vector3D(x: 1.0, y: 2.0, z: 3.0))
        #expect(translated == Rect3D(origin: Point3D(x: 2.0, y: 4.0, z: 6.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0)))
    }

    // MARK: - Volumetric tests

    @Test func testContains() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let point = Point3D(x: 2.0, y: 3.0, z: 4.0)
        #expect(rect.contains(point: point) == true)
    }

    @Test func testContainsRect3D() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let otherRect = Rect3D(origin: Point3D(x: 2.0, y: 3.0, z: 4.0), size: Size3D(width: 3.0, height: 4.0, depth: 5.0))
        #expect(rect.contains(otherRect) == true)
    }

    @Test func testContainsAnyOf() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let points = [Point3D(x: 2.0, y: 3.0, z: 4.0), Point3D(x: 5.0, y: 6.0, z: 7.0)]
        #expect(rect.contains(anyOf: points) == true)
    }

    @Test func testFormIntersection() {
        var rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let otherRect = Rect3D(origin: Point3D(x: 2.0, y: 3.0, z: 4.0), size: Size3D(width: 3.0, height: 4.0, depth: 5.0))
        rect.formIntersection(otherRect)
        #expect(rect == Rect3D(origin: Point3D(x: 2.0, y: 3.0, z: 4.0), size: Size3D(width: 3.0, height: 4.0, depth: 5.0)))
    }

    @Test func testFormUnion() {
        var rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let otherRect = Rect3D(origin: Point3D(x: 2.0, y: 3.0, z: 4.0), size: Size3D(width: 3.0, height: 4.0, depth: 5.0))
        rect.formUnion(otherRect)
        #expect(rect == Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0)))
    }

    @Test func testIntersection() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let otherRect = Rect3D(origin: Point3D(x: 2.0, y: 3.0, z: 4.0), size: Size3D(width: 3.0, height: 4.0, depth: 5.0))
        let intersection = rect.intersection(otherRect)
        #expect(intersection == Rect3D(origin: Point3D(x: 2.0, y: 3.0, z: 4.0), size: Size3D(width: 3.0, height: 4.0, depth: 5.0)))
    }

    @Test func testUnion() {
        let rect = Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0))
        let otherRect = Rect3D(origin: Point3D(x: 2.0, y: 3.0, z: 4.0), size: Size3D(width: 3.0, height: 4.0, depth: 5.0))
        let union = rect.union(otherRect)
        #expect(union == Rect3D(origin: Point3D(x: 1.0, y: 2.0, z: 3.0), size: Size3D(width: 4.0, height: 5.0, depth: 6.0)))
    }
}
