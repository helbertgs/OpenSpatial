import Testing
@testable import OpenSpatial

struct Point3DTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let point = Point3D()
        #expect(point.x == 0.0)
        #expect(point.y == 0.0)
        #expect(point.z == 0.0)
    }

    @Test func testInitializationUsingDefaultParams() {
        let point = Point3D(x: 2.0, y: 1.0)
        #expect(point.x == 2.0)
        #expect(point.y == 1.0)
        #expect(point.z == 0.0)
    }

    @Test func testInitializationUsingFloatingPoint() {
        let point = Point3D(x: Float(3.5), y: Float(4.5), z: Float(5.5))
        #expect(point.x == 3.5)
        #expect(point.y == 4.5)
        #expect(point.z == 5.5)
    }

    @Test func testInitializationUsingArrayLiteral() {
        let point: Point3D = [1.0, 2.0, 3.0]
        #expect(point.x == 1.0)
        #expect(point.y == 2.0)
        #expect(point.z == 3.0)
    }

     @Test func testInitializationUsingSize3D() {
        let size = Size3D(width: 3, height: 5, depth: 8)
        let point = Point3D(size)
        #expect(point.x == size.width)
        #expect(point.y == size.height)
        #expect(point.z == size.depth)
    }

    @Test func testInitializationUsingVector3D() {
        let vector = Vector3D(x: 3, y: 5, z: 8)
        let point = Point3D(vector)
        #expect(point.x == vector.x)
        #expect(point.y == vector.y)
        #expect(point.z == vector.z)
    }

    // MARK: - Subscripting tests

    @Test func testSubscriptGetter() throws {
        let point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        #expect(try point[0] == 1.0)
        #expect(try point[1] == 2.0)
        #expect(try point[2] == 3.0)
    }

    @Test func testSubscriptError() throws {
        let point = Point3D.zero
        #expect(throws: OpenSpatial.Error.self) {
            try point[4] == 0
        }
    }

    // MARK: - Inspecting a 3D point’s properties

    @Test func testMagnitude() {
        let point = Point3D(x: 3.0, y: 4.0, z: 0.0)
        #expect(point.magnitudeSquared == 25.0) // sqrt(3^2 + 4^2 + 0^2) = 5
    }

    // MARK: - Checking characteristics

    @Test func testDistanceToAnotherPoint() {
        let point1 = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let point2 = Point3D(x: 4.0, y: 6.0, z: 3.0)
        let distance = point1.distance(to: point2)
        #expect(distance == 5.0) // sqrt((4-1)^2 + (6-2)^2 + (3-3)^2) = 5
    }

    // MARK: - Comparing values

    @Test func testIsApproximatelyEqual() {
        let point1 = Point3D(x: 1.000001, y: 2.000001, z: 3.000001)
        let point2 = Point3D(x: 1.000002, y: 2.000002, z: 3.000002)
        #expect(point1.isApproximatelyEqual(to: point2, tolerance: 0.00001) == true)
    }

    // MARK: - Applying arithmetic operations

    @Test func testAddition() {
        let point1 = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let point2 = Point3D(x: 4.0, y: 5.0, z: 6.0)
        let result = point1 + point2
        #expect(result == Point3D(x: 5.0, y: 7.0, z: 9.0))
    }

    @Test func testAddition2() {
        var point1 = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let point2 = Point3D(x: 4.0, y: 5.0, z: 6.0)
        point1 += point2
        #expect(point1 == Point3D(x: 5.0, y: 7.0, z: 9.0))
    }

    @Test func testAddingVector() {
        let point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let vector = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let result = point + vector
        #expect(result == Point3D(x: 5.0, y: 7.0, z: 9.0))
    }

    @Test func testAddingVector2() {
        var point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let vector = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        point += vector
        #expect(point == Point3D(x: 5.0, y: 7.0, z: 9.0))
    }

    @Test func testAddingSize() {
        let point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let size = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        let result = point + size
        #expect(result == Point3D(x: 5.0, y: 7.0, z: 9.0))
    }

    @Test func testAddingSize2() {
        let point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let size = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        let result = size + point
        #expect(result == Point3D(x: 5.0, y: 7.0, z: 9.0))
    }


    @Test func testSubtractingPoint() {
        let point1 = Point3D(x: 5.0, y: 7.0, z: 9.0)
        let point2 = Point3D(x: 4.0, y: 5.0, z: 6.0)
        let result = point1 - point2
        #expect(result == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testSubtractingPoint2() {
        var point1 = Point3D(x: 5.0, y: 7.0, z: 9.0)
        let point2 = Point3D(x: 4.0, y: 5.0, z: 6.0)
        point1 -= point2
        #expect(point1 == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testSubtractingSize() {
        let point = Point3D(x: 5.0, y: 7.0, z: 9.0)
        let size = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        let result = point - size
        #expect(result == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testSubtractingSize2() {
        let point = Point3D(x: 5.0, y: 7.0, z: 9.0)
        let size = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        let result = size - point
        #expect(result == Point3D(x: -1.0, y: -2.0, z: -3.0))
    }

    @Test func testSubtractingSize3() {
        var point = Point3D(x: 5.0, y: 7.0, z: 9.0)
        let size = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        point -= size
        #expect(point == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testSubtractingVector() {
        let point = Point3D(x: 5.0, y: 7.0, z: 9.0)
        let vector = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let result = point - vector
        #expect(result == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testSubtractingVector2() {
        var point = Point3D(x: 5.0, y: 7.0, z: 9.0)
        let vector = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        point -= vector
        #expect(point == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testMultiplication() {
        let point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let scaledPoint = point * 3.0
        #expect(scaledPoint == Point3D(x: 3.0, y: 6.0, z: 9.0))
    }

    @Test func testMultiplication2() {
        let point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let scaledPoint = 3.0 * point
        #expect(scaledPoint == Point3D(x: 3.0, y: 6.0, z: 9.0))
    }

    @Test func testMultiplication3() {
        var point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        point *= 3.0
        #expect(point == Point3D(x: 3.0, y: 6.0, z: 9.0))
    }

    @Test func testMultiplication4() {
        let affine = AffineTransform3D()
        let point1 = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let point2 = affine * point1
        #expect(point2 == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testDivision() {
        let point = Point3D(x: 4.0, y: 8.0, z: 12.0)
        let dividedPoint = point / 4.0
        #expect(dividedPoint == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testDivision2() {
        var point = Point3D(x: 4.0, y: 8.0, z: 12.0)
        point /= 4.0
        #expect(point == Point3D(x: 1.0, y: 2.0, z: 3.0))
    }

    // MARK: - Primitive3D tests

    @Test func testIsFinite() {
        let point = Point3D.zero
        #expect(point.isFinite == true)
    }

    @Test func testIsNotFinite() {
        let point = Point3D.infinity
        #expect(point.isFinite == false)
    }

    @Test func testIsNaN() {
        let point = Point3D(x: Double.nan, y: 0.0, z: 0.0)
        #expect(point.isNaN == true)
    }

    @Test func testIsZero() {
        let point = Point3D(x: 0.0, y: 0.0, z: 0.0)
        #expect(point.isZero == true)
    }

    @Test func testInfinity() {
        let point = Point3D.infinity
        #expect(point.x == Double.infinity)
        #expect(point.y == Double.infinity)
        #expect(point.z == Double.infinity)
    }

    @Test func testNaN() {
        let point = Point3D(x: Double.nan, y: Double.nan, z: Double.nan)
        #expect(point.x.isNaN)
        #expect(point.y.isNaN)
        #expect(point.z.isNaN)
    }

    @Test func testApplyingAffineTransform() {
        let point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let transform = AffineTransform3D(matrix: [
            [10.0, 0.0, 0.0, 0.0],
            [0.0, 20.0, 0.0, 0.0],
            [0.0, 0.0, 30.0, 0.0],
            [0.0, 0.0, 0.0,  1.0]
        ])
        
        let transformed = point.applying(transform)
        #expect(transformed == Point3D(x: 10.0, y: 40.0, z: 90.0))
    }

    // MARK: - Scalable3D tests

    @Test func testScalingPoint3D() {
        var point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        point.scaleBy(x: 2.0, y: 3.0, z: 4.0)
        #expect(point == Point3D(x: 2.0, y: 6.0, z: 12.0))
    }

    @Test func testUniformlyScale() {
        var point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        point.uniformlyScale(by: 3.0)
        #expect(point == Point3D(x: 3.0, y: 6.0, z: 9.0))
    }

    @Test func testUniformlyScaled() {
        let point1 = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let point2 = point1.uniformlyScaled(by: 3.0)
        #expect(point2 == Point3D(x: 3.0, y: 6.0, z: 9.0))
    }

    // MARK: - Translatable3D tests

    @Test func testTranslatingPoint3D() {
        var point = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let vector = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        point = point.translated(by: vector)
        #expect(point == Point3D(x: 5.0, y: 7.0, z: 9.0))
    }

    // MARK: - CustomStringConvertible

    @Test func testDescription() {
        let point = Point3D.zero
        #expect(point.description == "(x: 0.0, y: 0.0, z: 0.0)")
    }
}