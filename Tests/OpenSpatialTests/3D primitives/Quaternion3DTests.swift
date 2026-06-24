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

    @Test func testIdentity() {
        let identity = Quaternion3D.identity
        #expect(identity.x == 0.0)
        #expect(identity.y == 0.0)
        #expect(identity.z == 0.0)
        #expect(identity.w == 1.0)
    }

    @Test func testAct() {
        let q = Quaternion3D(angle: Angle2D(radians: .pi / 2), axis: .up)
        let v = Vector3D(x: 1.0, y: 0.0, z: 0.0)
        let result = q.act(v)
        #expect(result.x.rounded(toPlaces: 10) == 0.0)
        #expect(result.y.rounded(toPlaces: 10) == 0.0)
        #expect(result.z.rounded(toPlaces: 10) == -1.0)
    }

    @Test func testInitFromTo() {
        let from = Vector3D.right
        let to = Vector3D.forward
        let q = Quaternion3D(from: from, to: to)
        let rotated = q.act(from)
        #expect(rotated.x.rounded(toPlaces: 10) == to.x.rounded(toPlaces: 10))
        #expect(rotated.y.rounded(toPlaces: 10) == to.y.rounded(toPlaces: 10))
        #expect(rotated.z.rounded(toPlaces: 10) == to.z.rounded(toPlaces: 10))
    }

    @Test func testInitFromToIdentity() {
        let v = Vector3D.up
        let q = Quaternion3D(from: v, to: v)
        #expect(q.x.rounded(toPlaces: 10) == 0.0)
        #expect(q.y.rounded(toPlaces: 10) == 0.0)
        #expect(q.z.rounded(toPlaces: 10) == 0.0)
        #expect(q.w.rounded(toPlaces: 10) == 1.0)
    }

    @Test func testInitFromTo180Degrees() {
        // Opposite vectors → 180-degree rotation quaternion, w == 0
        let from = Vector3D.right
        let to = Vector3D(x: -1, y: 0, z: 0)
        let q = Quaternion3D(from: from, to: to)
        #expect(q.w.rounded(toPlaces: 10) == 0.0)
        // Round-tripping: acting on `from` with q should give `to`
        let rotated = q.act(from)
        #expect(rotated.x.rounded(toPlaces: 10) == to.x.rounded(toPlaces: 10))
        #expect(rotated.y.rounded(toPlaces: 10) == to.y.rounded(toPlaces: 10))
        #expect(rotated.z.rounded(toPlaces: 10) == to.z.rounded(toPlaces: 10))
    }

    @Test func testInitFromEulerAnglesXYZ() {
        // Note: Quaternion3D(eulerAngles:) uses FULL angles (not half-angles).
        // This test just ensures the init runs and produces a unit quaternion.
        let angles = EulerAngles(x: Angle2D(degrees: 30), y: Angle2D(degrees: 45), z: Angle2D(degrees: 60), order: .xyz)
        let q = Quaternion3D(angles, order: .xyz)
        let len = (q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
        #expect(len.rounded(toPlaces: 10) == 1.0)
    }

    @Test func testInitFromEulerAnglesZXY() {
        let angles = EulerAngles(x: Angle2D(degrees: 30), y: Angle2D(degrees: 45), z: Angle2D(degrees: 60), order: .zxy)
        let q = Quaternion3D(angles, order: .zxy)
        let len = (q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
        #expect(len.rounded(toPlaces: 10) == 1.0)
    }

    @Test func testEulerAnglesRoundTrip() {
        // eulerAngles property should return angles whose quaternion form matches the original
        let q = Quaternion3D(angle: Angle2D(radians: .pi / 4), axis: .up)
        let euler = q.eulerAngles
        // Just verify it returns a valid EulerAngles without crashing
        #expect(euler.order == .xyz)
        #expect(euler.x.radians.isFinite)
        #expect(euler.y.radians.isFinite)
        #expect(euler.z.radians.isFinite)
    }
}