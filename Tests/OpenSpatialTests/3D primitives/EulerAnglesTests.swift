import Testing
@testable import OpenSpatial

struct EulerAnglesTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let eulerAngles = EulerAngles()
        #expect(eulerAngles.x == 0.0)
        #expect(eulerAngles.y == 0.0)
        #expect(eulerAngles.z == 0.0)
        #expect(eulerAngles.angles == [0.0, 0.0, 0.0])

        #expect(eulerAngles.description == "(x: 0.0, y: 0.0, z: 0.0, order: xyz)")
    }

    @Test func testInitializationWithParameters() {
        let eulerAngles = EulerAngles(x: 30.0, y: 45.0, z: 60.0, order: .zxy)
        #expect(eulerAngles.x == 30.0)
        #expect(eulerAngles.y == 45.0)
        #expect(eulerAngles.z == 60.0)
        #expect(eulerAngles.angles == [30.0, 45.0, 60.0])

        #expect(eulerAngles.description == "(x: 30.0, y: 45.0, z: 60.0, order: zxy)")
    }
}