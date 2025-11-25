import Testing
@testable import OpenSpatial

struct Axis3DTests {

    @Test func testXAxis() {
        #expect(Axis3D.x.rawValue == 1)
    }

    @Test func testYAxis() {
        #expect(Axis3D.y.rawValue == 2)
    }

    @Test func testZAxis() {
        #expect(Axis3D.z.rawValue == 4)
    }
}