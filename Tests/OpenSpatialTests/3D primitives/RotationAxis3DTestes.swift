import Testing
@testable import OpenSpatial

struct RotationAxis3DTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let axis = RotationAxis3D()
        #expect(axis.x == 0.0)
        #expect(axis.y == 0.0)
        #expect(axis.z == 0.0)
        #expect(axis.vector == [0.0, 0.0, 0.0])
        #expect(axis.isZero == true)
        #expect(axis.description == "(x: 0.0, y: 0.0, z: 0.0)")
    }

    @Test func testInitializationWithParams() {
        let axis = RotationAxis3D(x: 1.0, y: 2.0, z: 3.0)
        #expect(axis.x == 1.0)
        #expect(axis.y == 2.0)
        #expect(axis.z == 3.0)
        #expect(axis.vector == [1.0, 2.0, 3.0])
        #expect(axis.isZero == false)
        #expect(axis.description == "(x: 1.0, y: 2.0, z: 3.0)")
    }

    @Test func testInitializationWithFloatParams() {
        let axis = RotationAxis3D(x: Float(1.0), y: Float(2.0), z: Float(3.0))
        #expect(axis.x == 1.0)
        #expect(axis.y == 2.0)
        #expect(axis.z == 3.0)
        #expect(axis.vector == [1.0, 2.0, 3.0])
        #expect(axis.isZero == false)
        #expect(axis.description == "(x: 1.0, y: 2.0, z: 3.0)")
    }

    @Test func testInitializationWithArrayLiteral() {
        let axis: RotationAxis3D = [4.0, 5.0, 6.0]
        #expect(axis.x == 4.0)
        #expect(axis.y == 5.0)
        #expect(axis.z == 6.0)
        #expect(axis.vector == [4.0, 5.0, 6.0])
        #expect(axis.isZero == false)
        #expect(axis.description == "(x: 4.0, y: 5.0, z: 6.0)")
    }

    @Test func testInitializationWithVector() {
        let axis = RotationAxis3D(Vector3D(x: 7.0, y: 8.0, z: 9.0))
        #expect(axis.x == 7.0)
        #expect(axis.y == 8.0)
        #expect(axis.z == 9.0)
        #expect(axis.vector == [7.0, 8.0, 9.0])
        #expect(axis.isZero == false)
        #expect(axis.description == "(x: 7.0, y: 8.0, z: 9.0)")
    }

    @Test func testPredefinedAxes() {
        #expect(RotationAxis3D.zero == RotationAxis3D())
        #expect(RotationAxis3D.x == RotationAxis3D(x: 1, y: 0, z: 0))
        #expect(RotationAxis3D.y == RotationAxis3D(x: 0, y: 1, z: 0))
        #expect(RotationAxis3D.z == RotationAxis3D(x: 0, y: 0, z: 1))
        #expect(RotationAxis3D.xy == RotationAxis3D(x: 1, y: 1, z: 0))
        #expect(RotationAxis3D.yz == RotationAxis3D(x: 0, y: 1, z: 1))
        #expect(RotationAxis3D.xz == RotationAxis3D(x: 1, y: 0, z: 1))
        #expect(RotationAxis3D.xyz == RotationAxis3D(x: 1, y: 1, z: 1))
    }
}
