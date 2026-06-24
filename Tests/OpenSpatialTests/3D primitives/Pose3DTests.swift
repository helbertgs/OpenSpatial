import Foundation
import Testing
@testable import OpenSpatial

struct Pose3DTests {

    // MARK: - Initialization tests

    @Test func testDefaultInit() {
        let pose = Pose3D()
        #expect(pose.position == Point3D())
        #expect(pose.rotation == Rotation3D())
    }

    @Test func testInitWithPositionAndRotation() {
        let position = Point3D(x: 1, y: 2, z: 3)
        let rotation = Rotation3D()
        let pose = Pose3D(position: position, rotation: rotation)
        #expect(pose.position == position)
        #expect(pose.rotation == rotation)
    }

    @Test func testInitWithForwardAndUp() {
        let forward = Vector3D(x: 0, y: 0, z: 1)
        let up = Vector3D(x: 0, y: 1, z: 0)
        let pose = Pose3D(forward: forward, up: up)
        #expect(pose.position == Point3D())
        #expect(pose.rotation == Rotation3D(forward: forward, up: up))
    }

    // MARK: - Identity

    @Test func testIdentity() {
        let identity = Pose3D.identity
        #expect(identity.position == Point3D())
        #expect(identity.rotation == Rotation3D())
    }

    @Test func testIsIdentityTrue() {
        let pose = Pose3D()
        #expect(pose.isIdentity)
    }

    @Test func testIsIdentityFalsePosition() {
        let pose = Pose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D())
        #expect(!pose.isIdentity)
    }

    @Test func testIsIdentityFalseRotation() {
        let rotation = Rotation3D(angle: Angle2D(degrees: 90), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let pose = Pose3D(position: Point3D(), rotation: rotation)
        #expect(!pose.isIdentity)
    }

    // MARK: - Inverse

    @Test func testInverseOfIdentity() {
        let pose = Pose3D()
        let inv = pose.inverse
        #expect(inv.position.x.rounded(toPlaces: 10) == 0.0)
        #expect(inv.position.y.rounded(toPlaces: 10) == 0.0)
        #expect(inv.position.z.rounded(toPlaces: 10) == 0.0)
        #expect(inv.rotation.isIdentity)
    }

    @Test func testInverseRoundTrip() {
        let position = Point3D(x: 1, y: 2, z: 3)
        let rotation = Rotation3D(angle: Angle2D(degrees: 90), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let pose = Pose3D(position: position, rotation: rotation)
        let inv = pose.inverse

        let composed = Rotation3D(quaternion: pose.rotation.quaternion * inv.rotation.quaternion)
        #expect(composed.isIdentity)
    }

    // MARK: - Translatable3D conformance

    @Test func testTranslatedBy() {
        let pose = Pose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D())
        let result = pose.translated(by: Vector3D(x: 1, y: 0, z: 0))
        #expect(result.position == Point3D(x: 2, y: 2, z: 3))
        #expect(result.rotation == pose.rotation)
    }

    @Test func testTranslateBy() {
        var pose = Pose3D(position: Point3D(x: 0, y: 0, z: 0), rotation: Rotation3D())
        pose.translate(by: Vector3D(x: 5, y: 0, z: 0))
        #expect(pose.position == Point3D(x: 5, y: 0, z: 0))
    }

    // MARK: - Rotatable3D conformance

    @Test func testRotatedByRotation3D() {
        let pose = Pose3D()
        let rotation = Rotation3D()
        let result = pose.rotated(by: rotation)
        #expect(result.rotation.isIdentity)
        #expect(result.position == pose.position)
    }

    @Test func testRotatedByQuaternion() {
        let pose = Pose3D()
        let q = Quaternion3D(x: 0, y: 0, z: 0, w: 1)
        let result = pose.rotated(by: q)
        #expect(result.rotation.isIdentity)
    }

    // MARK: - Applying transform

    @Test func testApplyingIdentityTransform() {
        let pose = Pose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D())
        let result = pose.applying(AffineTransform3D())
        #expect(result.position.x.rounded(toPlaces: 10) == 1.0)
        #expect(result.position.y.rounded(toPlaces: 10) == 2.0)
        #expect(result.position.z.rounded(toPlaces: 10) == 3.0)
    }

    @Test func testApplyingTranslationTransform() {
        let pose = Pose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D())
        let t = AffineTransform3D(translation: Vector3D(x: 2, y: 3, z: 4))
        let result = pose.applying(t)
        #expect(result.position.x.rounded(toPlaces: 10) == 3.0)
        #expect(result.position.y.rounded(toPlaces: 10) == 3.0)
        #expect(result.position.z.rounded(toPlaces: 10) == 4.0)
    }

    // MARK: - Codable conformance

    @Test func testCodableRoundTrip() throws {
        let pose = Pose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D())
        let encoder = JSONEncoder()
        let data = try encoder.encode(pose)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Pose3D.self, from: data)
        #expect(decoded == pose)
    }
}
