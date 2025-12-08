import Testing
@testable import OpenSpatial

struct Quaternion3DTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let quaternion = Quaternion3D()
        #expect(quaternion.x == 0)
        #expect(quaternion.y == 0)
        #expect(quaternion.z == 0)
        #expect(quaternion.w == 1)

        #expect(quaternion.vector == [ 0.0, 0.0, 0.0, 1.0 ])
        #expect(quaternion.lengthSquared == 1.0)
        #expect(quaternion.length == 1.0)
        #expect(quaternion.conjugated() == Quaternion3D(x: 0, y: 0, z: 0, w: 1))
        #expect(quaternion.inverted() == Quaternion3D(x: 0, y: 0, z: 0, w: 1))
        #expect(quaternion.normalized == Quaternion3D(x: 0, y: 0, z: 0, w: 1))
        #expect(quaternion.isZero == false)
        #expect(quaternion.isNaN == false)
        #expect(quaternion.isFinite == true)
        #expect(quaternion.description == "(x: 0.0, y: 0.0, z: 0.0, w: 1.0)")
    }

    @Test func testInitializationUsingDefaultParams() {
        let quaternion = Quaternion3D(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
        #expect(quaternion.x == 1.0)
        #expect(quaternion.y == 2.0)
        #expect(quaternion.z == 3.0)
        #expect(quaternion.w == 4.0)
    }

    @Test func testInitializationUsingArrayLiteral() {
        let quaternion: Quaternion3D = [0.0, 0.0, 0.0, 0.0]
        #expect(quaternion.x == 0.0)
        #expect(quaternion.y == 0.0)
        #expect(quaternion.z == 0.0)
        #expect(quaternion.w == 0.0)

        #expect(quaternion == .zero)
    }

    @Test func testInitializationUsingInfinityValues() {
        let quaternion = Quaternion3D(x: .infinity, y: .infinity, z: .infinity, w: .infinity)
        #expect(quaternion == .infinity)
        #expect(quaternion.isFinite == false)
    }

    // MARK: - Subscripting tests

    @Test func testSubscriptGetter() throws {
        let quaternion = Quaternion3D(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
        #expect(try quaternion[0] == 1.0)
        #expect(try quaternion[1] == 2.0)
        #expect(try quaternion[2] == 3.0)
        #expect(try quaternion[3] == 4.0)
    }

    @Test func testSubscriptError() throws {
        let quaternion = Quaternion3D.zero
        #expect(throws: OpenSpatial.Error.self) {
            try quaternion[5] == 0
        }
    }

    @Test func testMultiplication() {
        let q1 = Quaternion3D(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
        let q2 = Quaternion3D(x: 5.0, y: 6.0, z: 7.0, w: 8.0)
        let result = q1 * q2
        #expect(result.x == 24.0)
        #expect(result.y == 48.0)
        #expect(result.z == 48.0)
        #expect(result.w == -6.0)
    }

    // @Test func testInitializationUsingAngleAndAxisXYZ() {
    //     let quaternion = Quaternion3D(angle: Angle2D(radians: Double.pi / 2), axis: Vector3D(x: 1.0, y: 1.0, z: 1.0))
    //     #expect(quaternion.x == 0.7071067811865475)
    //     #expect(quaternion.y == 0.7071067811865475)
    //     #expect(quaternion.z == 0.7071067811865475)
    //     #expect(quaternion.w == 0.7071067811865476)
    // }

    // @Test func testInitializationUsingAngleAndAxisXY() {
    //     let quaternion = Quaternion3D(angle: Angle2D(radians: Double.pi / 2), axis: Vector3D(x: 1.0, y: 1.0, z: 0.0))
    //     #expect(quaternion.x == 0.7071067811865475)
    //     #expect(quaternion.y == 0.7071067811865475)
    //     #expect(quaternion.z == 0.0)
    //     #expect(quaternion.w == 0.7071067811865476)
    // }
}   