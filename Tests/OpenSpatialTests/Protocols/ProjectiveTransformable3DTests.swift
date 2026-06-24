import Testing
@testable import OpenSpatial

struct ProjectiveTransformable3DTests {

    @Test func testPoint3DApplyingIdentity() {
        let point = Point3D(x: 1, y: 2, z: 3)
        let result = point.applying(ProjectiveTransform3D.identity)
        #expect(result == point)
    }

    @Test func testVector3DApplyingIdentity() {
        let vector = Vector3D(x: 1, y: 2, z: 3)
        let result = vector.applying(ProjectiveTransform3D.identity)
        #expect(result == vector)
    }

    @Test func testRect3DApplyingIdentity() {
        let rect = Rect3D(origin: Point3D(x: 1, y: 2, z: 3), size: Size3D(width: 4, height: 5, depth: 6))
        let result = rect.applying(ProjectiveTransform3D.identity)
        #expect(result == rect)
    }

    @Test func testRotation3DApplyingIdentity() {
        let rotation = Rotation3D()
        let result = rotation.applying(ProjectiveTransform3D.identity)
        #expect(result.isIdentity)
    }

    @Test func testPose3DApplyingIdentity() {
        let pose = Pose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D())
        let result = pose.applying(ProjectiveTransform3D.identity)
        #expect(result.position == pose.position)
        #expect(result.rotation.isIdentity)
    }
}
