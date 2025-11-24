import Testing
@testable import OpenSpatial

struct Vector3DTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let vector = Vector3D()
        #expect(vector.x == 0.0)
        #expect(vector.y == 0.0)
        #expect(vector.z == 0.0)
    }

    @Test func testInitializationUsingDefaultParams() {
        let vector = Vector3D(x: 2.0, y: 1.0)
        #expect(vector.x == 2.0)
        #expect(vector.y == 1.0)
        #expect(vector.z == 0.0)
    }

    @Test func testInitializationUsingFloatingPoint() {
        let vector = Vector3D(x: Float(3.5), y: Float(4.5), z: Float(5.5))
        #expect(vector.x == 3.5)
        #expect(vector.y == 4.5)
        #expect(vector.z == 5.5)
    }

    @Test func testInitializationUsingArrayLiteral() {
        let vector: Vector3D = [1.0, 2.0, 3.0]
        #expect(vector.x == 1.0)
        #expect(vector.y == 2.0)
        #expect(vector.z == 3.0)
    }

    // MARK: - Geometry functions tests

    @Test func testDotProduct() {
        let vector1 = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        let vector2 = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let dotProduct = vector1.dot(vector2)
        #expect(dotProduct == 32.0) // 1*4 + 2*5 + 3*6 = 32
    }

    @Test func testCrossProduct() {
        let vector1 = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        let vector2 = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let crossProduct = vector1.cross(vector2)
        #expect(crossProduct == Vector3D(x: -3.0, y: 6.0, z: -3.0)) // Cross product result
    }

    @Test func testLength() {
        let vector = Vector3D(x: 3.0, y: 4.0, z: 0.0)
        #expect(vector.length == 5.0) // sqrt(3^2 + 4^2 + 0^2) = 5
    }

    @Test func testLengthSquared() {
        let vector = Vector3D(x: 3.0, y: 4.0, z: 0.0)
        #expect(vector.lengthSquared == 25.0) // 3^2 + 4^2 + 0^2 = 25
    }

    @Test func testNormalization() {
        var vector = Vector3D(x: 3.0, y: 4.0, z: 0.0)
        vector.normalize()
        #expect(vector.x.rounded(toPlaces: 2) == 0.6) // 3/5
        #expect(vector.y.rounded(toPlaces: 2) == 0.8) // 4/5
        #expect(vector.z.rounded(toPlaces: 2) == 0.0)
    }

    @Test func testNormalizedVector() {
        let vector = Vector3D(x: 3.0, y: 4.0, z: 0.0)
        let normalizedVector = vector.normalized
        #expect(normalizedVector.x.rounded(toPlaces: 2) == 0.6) // 3/5
        #expect(normalizedVector.y.rounded(toPlaces: 2) == 0.8) // 4/5
        #expect(normalizedVector.z.rounded(toPlaces: 2) == 0.0)
    }

    @Test func testProjectedVector() {
        let vector = Vector3D(x: 3.0, y: 4.0, z: 0.0)
        let ontoVector = Vector3D(x: 1.0, y: 0.0, z: 0.0)
        let projectedVector = vector.projected(ontoVector)
        #expect(projectedVector == Vector3D(x: 3.0, y: 0.0, z: 0.0))
    }

    @Test func testReflectedVector() {
        let vector = Vector3D(x: 1.0, y: -1.0, z: 0.0)
        let normal = Vector3D(x: 0.0, y: 1.0, z: 0.0)
        let reflectedVector = vector.reflected(normal)
        #expect(reflectedVector == Vector3D(x: 1.0, y: 1.0, z: 0.0))
    }

    // MARK: - Type properties

    @Test func testBackwardVector() {
        let backward = Vector3D.backward
        #expect(backward == Vector3D(x: 0.0, y: 0.0, z: -1.0))
    }

    @Test func testForwardVector() {
        let forward = Vector3D.forward
        #expect(forward == Vector3D(x: 0.0, y: 0.0, z: 1.0))
    }

    @Test func testLeftVector() {
        let left = Vector3D.left
        #expect(left == Vector3D(x: -1.0, y: 0.0, z: 0.0))
    }

    @Test func testRightVector() {
        let right = Vector3D.right
        #expect(right == Vector3D(x: 1.0, y: 0.0, z: 0.0))
    }

    @Test func testUpVector() {
        let up = Vector3D.up
        #expect(up == Vector3D(x: 0.0, y: 1.0, z: 0.0))
    }

    @Test func testDownVector() {
        let down = Vector3D.down
        #expect(down == Vector3D(x: 0.0, y: -1.0, z: 0.0))
    }

    // MARK: - AdditiveArithmetic tests

    @Test func testZeroVector() {
        let zeroVector = Vector3D.zero
        #expect(zeroVector == Vector3D(x: 0.0, y: 0.0, z: 0.0))
    }

    @Test func testMultiplication() async throws {
        let vector = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        let scaledVector = vector * 3.0
        #expect(scaledVector == Vector3D(x: 3.0, y: 6.0, z: 9.0))
    }

    @Test func testMultiplication2() {
        var vector = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        vector *= 3.0
        #expect(vector == Vector3D(x: 3.0, y: 6.0, z: 9.0))
    }

    @Test func testAddition() {
        let vector1 = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        let vector2 = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let sum = vector1 + vector2
        #expect(sum == Vector3D(x: 5.0, y: 7.0, z: 9.0))
    }

    @Test func testAddition2() {
        var vector1 = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        let vector2 = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        vector1 += vector2
        #expect(vector1 == Vector3D(x: 5.0, y: 7.0, z: 9.0))
    }

    @Test func testSubtraction() {
        let vector1 = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let vector2 = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        let difference = vector1 - vector2
        #expect(difference == Vector3D(x: 3.0, y: 3.0, z: 3.0))
    }

    @Test func testSubtraction2() {
        var vector1 = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let vector2 = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        vector1 -= vector2
        #expect(vector1 == Vector3D(x: 3.0, y: 3.0, z: 3.0))
    }

    @Test func testDivision() {
        let vector = Vector3D(x: 4.0, y: 8.0, z: 12.0)
        let dividedVector = vector / 4.0
        #expect(dividedVector == Vector3D(x: 1.0, y: 2.0, z: 3.0))
    }

    @Test func testDivision2() {
        var vector = Vector3D(x: 4.0, y: 8.0, z: 12.0)
        vector /= 4.0
        #expect(vector == Vector3D(x: 1.0, y: 2.0, z: 3.0))
    }

    // MARK: - Primitive3D tests

    @Test func testIsFinite() {
        let vector = Vector3D.zero
        #expect(vector.isFinite == true)
    }

    @Test func testIsNotFinite() {
        let vector = Vector3D.infinity
        #expect(vector.isFinite == false)
    }

    @Test func testIsNaN() {
        let vector = Vector3D(x: Double.nan, y: 0.0, z: 0.0)
        #expect(vector.isNaN == true)
    }

    @Test func testIsZero() {
        let vector = Vector3D(x: 0.0, y: 0.0, z: 0.0)
        #expect(vector.isZero == true)
    }

    @Test func testInfinityVector() {
        let infinityVector = Vector3D.infinity
        #expect(infinityVector.x == Double.infinity)
        #expect(infinityVector.y == Double.infinity)
        #expect(infinityVector.z == Double.infinity)
    }

    @Test func testNaNVector() {
        let nanVector = Vector3D(x: Double.nan, y: Double.nan, z: Double.nan)
        #expect(nanVector.x.isNaN)
        #expect(nanVector.y.isNaN)
        #expect(nanVector.z.isNaN)
    }

    @Test func testApplyingAffineTransform() {
        let vector = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        let transform = AffineTransform3D(matrix: [
            [10.0, 0.0, 0.0, 0.0],
            [0.0, 20.0, 0.0, 0.0],
            [0.0, 0.0, 30.0, 0.0],
            [0.0, 0.0, 0.0,  1.0]
        ])
        
        let transformedVector = vector.applying(transform)
        #expect(transformedVector == Vector3D(x: 10.0, y: 40.0, z: 90.0))
    }
}