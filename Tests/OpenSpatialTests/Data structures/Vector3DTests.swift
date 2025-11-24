import Testing
@testable import OpenSpatial

struct Vector3DTests {
    @Test func testInitialization() {
        let vector = Vector3D()
        #expect(vector.x == 0)
        #expect(vector.y == 0)
        #expect(vector.z == 0)
    }
}