import Testing
@testable import OpenSpatial

struct Vector3DTests {
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
}