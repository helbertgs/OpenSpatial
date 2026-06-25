import Testing
@testable import OpenSpatial

struct Rotation3DTests {

    // MARK: - Initialization

    @Test func testIdentityInit() {
        let r = Rotation3D()
        #expect(r.quaternion.x == 0.0)
        #expect(r.quaternion.y == 0.0)
        #expect(r.quaternion.z == 0.0)
        #expect(r.quaternion.w == 1.0)
        #expect(r.isIdentity)
    }

    @Test func testInitWithQuaternion() {
        let q = Quaternion3D(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
        let r = Rotation3D(quaternion: q)
        #expect(r.quaternion.x.rounded(toPlaces: 10) == 0.0)
        #expect(r.quaternion.y.rounded(toPlaces: 10) == 1.0)
        #expect(r.quaternion.z.rounded(toPlaces: 10) == 0.0)
        #expect(r.quaternion.w.rounded(toPlaces: 10) == 0.0)
    }

    @Test func testInitWithEulerAngles60Degrees() {
        let deg60 = Angle2D(degrees: 60)
        let eulerAngles = EulerAngles(x: deg60, y: deg60, z: deg60, order: .xyz)
        let r = Rotation3D(eulerAngles: eulerAngles)

        #expect(r.angle.radians.rounded(toPlaces: 4) == 1.3697)
        #expect(r.axis.x.rounded(toPlaces: 4) == 0.2506)
        #expect(r.axis.y.rounded(toPlaces: 4) == 0.9351)
        #expect(r.axis.z.rounded(toPlaces: 4) == 0.2506)
        #expect(r.quaternion.x.rounded(toPlaces: 4) == 0.1585)
        #expect(r.quaternion.y.rounded(toPlaces: 4) == 0.5915)
        #expect(r.quaternion.z.rounded(toPlaces: 4) == 0.1585)
        #expect(r.quaternion.w.rounded(toPlaces: 4) == 0.7745)
    }

    @Test func testInitWithAngleAxis() {
        let r = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        #expect(r.quaternion.x.rounded(toPlaces: 10) == 0.0)
        #expect(r.quaternion.y.rounded(toPlaces: 4) == 0.7071)
        #expect(r.quaternion.z.rounded(toPlaces: 10) == 0.0)
        #expect(r.quaternion.w.rounded(toPlaces: 4) == 0.7071)
    }

    // MARK: - Properties

    @Test func testVector() {
        let r = Rotation3D()
        #expect(r.vector == [0.0, 0.0, 0.0, 1.0])
    }

    @Test func testIsIdentityTrue() {
        #expect(Rotation3D().isIdentity)
    }

    @Test func testIsIdentityFalse() {
        let r = Rotation3D(angle: Angle2D(radians: 0.1), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        #expect(!r.isIdentity)
    }

    // MARK: - Inverse

    @Test func testInverse() {
        let r = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let inv = r.inverse
        let composed = r.quaternion * inv.quaternion
        #expect(composed.x.rounded(toPlaces: 10) == 0.0)
        #expect(composed.y.rounded(toPlaces: 10) == 0.0)
        #expect(composed.z.rounded(toPlaces: 10) == 0.0)
        #expect(composed.w.rounded(toPlaces: 10) == 1.0)
    }

    // MARK: - Look-at and forward initialisers

    @Test func testInitForwardIsIdentity() {
        let r = Rotation3D(forward: Vector3D.forward)
        #expect(r.quaternion.x.rounded(toPlaces: 10) == 0.0)
        #expect(r.quaternion.y.rounded(toPlaces: 10) == 0.0)
        #expect(r.quaternion.z.rounded(toPlaces: 10) == 0.0)
        #expect(r.quaternion.w.rounded(toPlaces: 10) == 1.0)
    }

    @Test func testInitForwardNormalisedQuaternion() {
        let r = Rotation3D(forward: Vector3D(x: 1, y: 0, z: 1))
        let len = r.quaternion.length
        #expect(len.rounded(toPlaces: 10) == 1.0)
    }

    @Test func testInitForwardUpNormalisedQuaternion() {
        let r = Rotation3D(forward: Vector3D(x: 0, y: 0, z: -1), up: Vector3D(x: 0, y: 1, z: 0))
        let len = r.quaternion.length
        #expect(len.rounded(toPlaces: 10) == 1.0)
    }

    @Test func testInitPositionTargetUpNormalisedQuaternion() {
        let r = Rotation3D(
            position: Point3D(x: 0, y: 0, z: 0),
            target: Point3D(x: 1, y: 0, z: 0),
            up: Vector3D(x: 0, y: 1, z: 0)
        )
        let len = r.quaternion.length
        #expect(len.rounded(toPlaces: 10) == 1.0)
    }

    // MARK: - Act

    @Test func testAct() {
        let r = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let v = Vector3D(x: 1.0, y: 0.0, z: 0.0)
        let result = r.act(v)
        #expect(result.x.rounded(toPlaces: 10) == 0.0)
        #expect(result.y.rounded(toPlaces: 10) == 0.0)
        #expect(result.z.rounded(toPlaces: 10) == -1.0)
    }

    // MARK: - Rotatable3D conformance with Rotation3D

    @Test func testVector3DRotatedByRotation3D() {
        let r = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let v = Vector3D(x: 1.0, y: 0.0, z: 0.0)
        let result = v.rotated(by: r)
        #expect(result.x.rounded(toPlaces: 10) == 0.0)
        #expect(result.y.rounded(toPlaces: 10) == 0.0)
        #expect(result.z.rounded(toPlaces: 10) == -1.0)
    }

    @Test func testVector3DRotateByRotation3D() {
        let r = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        var v = Vector3D(x: 1.0, y: 0.0, z: 0.0)
        v.rotate(by: r)
        #expect(v.x.rounded(toPlaces: 10) == 0.0)
        #expect(v.y.rounded(toPlaces: 10) == 0.0)
        #expect(v.z.rounded(toPlaces: 10) == -1.0)
    }

    @Test func testPoint3DRotatedByRotation3D() {
        let r = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let p = Point3D(x: 1.0, y: 0.0, z: 0.0)
        let result = p.rotated(by: r)
        #expect(result.x.rounded(toPlaces: 10) == 0.0)
        #expect(result.y.rounded(toPlaces: 10) == 0.0)
        #expect(result.z.rounded(toPlaces: 10) == -1.0)
    }
}
