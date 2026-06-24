import Testing
import Foundation
@testable import OpenSpatial

struct ScaledPose3DTests {

    // MARK: - Initialization

    @Test func testDefaultInit() {
        let pose = ScaledPose3D()
        #expect(pose.position == .zero)
        #expect(pose.rotation.isIdentity)
        #expect(pose.scale == 1.0)
    }

    @Test func testInitPositionRotationScale() {
        let position = Point3D(x: 1, y: 2, z: 3)
        let rotation = Rotation3D()
        let pose = ScaledPose3D(position: position, rotation: rotation, scale: 2.0)
        #expect(pose.position == position)
        #expect(pose.rotation == rotation)
        #expect(pose.scale == 2.0)
    }

    @Test func testInitWithDefaultsRotation3D() {
        let rotation = Rotation3D(angle: Angle2D(degrees: 45), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let pose = ScaledPose3D(position: .zero, rotation: rotation, scale: 1.0)
        #expect(pose.position == .zero)
        #expect(pose.scale == 1.0)
        #expect(pose.rotation == rotation)
    }

    @Test func testInitWithQuaternion() {
        let q = Quaternion3D(x: 0, y: 0, z: 0, w: 1)
        let pose = ScaledPose3D(rotation: q)
        #expect(pose.rotation.isIdentity)
        #expect(pose.scale == 1.0)
    }

    @Test func testInitLookAt() {
        let position = Point3D(x: 0, y: 0, z: 0)
        let target = Point3D(x: 0, y: 0, z: 1)
        let pose = ScaledPose3D(position: position, target: target, scale: 1.0)
        #expect(!pose.rotation.isIdentity || pose.rotation.isIdentity)
        #expect(pose.position == position)
        #expect(pose.scale == 1.0)
    }

    @Test func testInitForward() {
        let forward = Vector3D(x: 0, y: 0, z: 1)
        let pose = ScaledPose3D(forward: forward)
        #expect(pose.position == .zero)
        #expect(pose.scale == 1.0)
    }

    // MARK: - Identity

    @Test func testIdentity() {
        let identity = ScaledPose3D.identity
        #expect(identity.isIdentity)
        #expect(identity.position == .zero)
        #expect(identity.rotation.isIdentity)
        #expect(identity.scale == 1.0)
    }

    @Test func testIsIdentityFalseNonUnitScale() {
        let pose = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 2.0)
        #expect(!pose.isIdentity)
    }

    @Test func testIsIdentityFalseNonZeroPosition() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 1.0)
        #expect(!pose.isIdentity)
    }

    // MARK: - Matrix

    @Test func testMatrixIsCorrectSize() {
        let pose = ScaledPose3D()
        let m = pose.matrix
        #expect(m.count == 4)
        #expect(m.allSatisfy { $0.count == 4 })
    }

    @Test func testIdentityMatrix() {
        let pose = ScaledPose3D.identity
        let m = pose.matrix
        #expect(abs(m[0][0] - 1.0) < 1e-10)
        #expect(abs(m[1][1] - 1.0) < 1e-10)
        #expect(abs(m[2][2] - 1.0) < 1e-10)
        #expect(abs(m[3][3] - 1.0) < 1e-10)
        #expect(abs(m[3][0]) < 1e-10)
        #expect(abs(m[3][1]) < 1e-10)
        #expect(abs(m[3][2]) < 1e-10)
    }

    @Test func testMatrixEncodesTranslation() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        let m = pose.matrix
        #expect(abs(m[3][0] - 1.0) < 1e-10)
        #expect(abs(m[3][1] - 2.0) < 1e-10)
        #expect(abs(m[3][2] - 3.0) < 1e-10)
    }

    @Test func testMatrixRoundTrip() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 2.0)
        let recovered = ScaledPose3D(pose.matrix)
        #expect(recovered != nil)
        #expect(abs(recovered!.scale - 2.0) < 1e-6)
        #expect(recovered!.position.isApproximatelyEqual(to: pose.position, tolerance: 1e-6))
    }

    @Test func testMatrixInitFromDoubleMatrix() {
        let identity: [[Double]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]
        let pose = ScaledPose3D(identity)
        #expect(pose != nil)
        #expect(pose!.isIdentity)
    }

    @Test func testMatrixInitNilForNonUniformScale() {
        let nonUniform: [[Double]] = [
            [2, 0, 0, 0],
            [0, 3, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]
        let pose = ScaledPose3D(nonUniform)
        #expect(pose == nil)
    }

    @Test func testMatrixInitFromFloatMatrix() {
        let identity: [[Float]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]
        let pose = ScaledPose3D(identity)
        #expect(pose != nil)
        #expect(pose!.isIdentity)
    }

    @Test func testInitFromAffineTransform() {
        let transform = AffineTransform3D(translation: Vector3D(x: 1, y: 2, z: 3))
        let pose = ScaledPose3D(transform: transform)
        #expect(pose != nil)
        #expect(pose!.position.isApproximatelyEqual(to: Point3D(x: 1, y: 2, z: 3), tolerance: 1e-6))
    }

    @Test func testInitFromProjectiveTransform() {
        let affine = AffineTransform3D(translation: Vector3D(x: 1, y: 0, z: 0))
        let projective = ProjectiveTransform3D(affine)
        let pose = ScaledPose3D(transform: projective)
        #expect(pose != nil)
    }

    // MARK: - Inverse

    @Test func testInverseOfIdentity() {
        let identity = ScaledPose3D.identity
        let inv = identity.inverse
        #expect(inv.isIdentity)
    }

    @Test func testInverseRoundTrip() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 2.0)
        let composed = pose * pose.inverse
        #expect(composed.isApproximatelyEqual(to: .identity, tolerance: 1e-10))
    }

    // MARK: - Operators and Concatenation

    @Test func testMultiplyScaledPoseByScaledPose() {
        let a = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 2.0)
        let b = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 1.0)
        let result = a * b
        #expect(result.scale == 2.0)
    }

    @Test func testMultiplyScaledPoseByPose3D() {
        let a = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 2.0)
        let b = Pose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D())
        let result = a * b
        #expect(result.scale == 2.0)
    }

    @Test func testMultiplyPose3DByScaledPose() {
        let a = Pose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D())
        let b = ScaledPose3D(position: Point3D(x: 0, y: 0, z: 0), rotation: Rotation3D(), scale: 3.0)
        let result = a * b
        #expect(result.scale == 3.0)
    }

    @Test func testMultiplyAssign() {
        var pose = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 2.0)
        let rhs = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 3.0)
        pose *= rhs
        #expect(pose.scale == 6.0)
    }

    @Test func testConcatenatingScaledPose() {
        let a = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 2.0)
        let b = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let result = a.concatenating(b)
        #expect(result.scale == 2.0)
    }

    @Test func testConcatenatingPose3D() {
        let a = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let b = Pose3D(position: Point3D(x: 2, y: 0, z: 0), rotation: Rotation3D())
        let result = a.concatenating(b)
        #expect(abs(result.position.x - 2.0) < 1e-10)
    }

    // MARK: - Flip

    @Test func testFlippedAlongX() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        let flipped = pose.flipped(along: .x)
        #expect(flipped.position.x == -1.0)
        #expect(flipped.position.y == 2.0)
        #expect(flipped.position.z == 3.0)
    }

    @Test func testFlippedAlongY() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        let flipped = pose.flipped(along: .y)
        #expect(flipped.position.x == 1.0)
        #expect(flipped.position.y == -2.0)
        #expect(flipped.position.z == 3.0)
    }

    @Test func testFlippedAlongZ() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        let flipped = pose.flipped(along: .z)
        #expect(flipped.position.x == 1.0)
        #expect(flipped.position.y == 2.0)
        #expect(flipped.position.z == -3.0)
    }

    @Test func testFlipMutating() {
        var pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        pose.flip(along: .x)
        #expect(pose.position.x == -1.0)
    }

    @Test func testFlippedAlongXYAxes() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        let flipped = pose.flipped(along: [.x, .y])
        #expect(flipped.position.x == -1.0)
        #expect(flipped.position.y == -2.0)
        #expect(flipped.position.z == 3.0)
    }

    @Test func testFlippedAlongAllAxes() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        let flipped = pose.flipped(along: [.x, .y, .z])
        #expect(flipped.position.x == -1.0)
        #expect(flipped.position.y == -2.0)
        #expect(flipped.position.z == -3.0)
    }

    @Test func testFlippedPreservesRotationAndScale() {
        let rotation = Rotation3D(angle: Angle2D(degrees: 45), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let pose = ScaledPose3D(position: Point3D(x: 5, y: 0, z: 0), rotation: rotation, scale: 3.0)
        let flipped = pose.flipped(along: .x)
        #expect(flipped.rotation == rotation)
        #expect(flipped.scale == 3.0)
        #expect(flipped.position.x == -5.0)
    }

    @Test func testFlippedZeroPositionIsNoOp() {
        let pose = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let flipped = pose.flipped(along: [.x, .y, .z])
        #expect(flipped.position == .zero)
    }

    @Test func testFlipMutatingAllAxes() {
        var pose = ScaledPose3D(position: Point3D(x: -4, y: 7, z: 2), rotation: Rotation3D(), scale: 1.0)
        pose.flip(along: [.x, .y, .z])
        #expect(pose.position.x == 4.0)
        #expect(pose.position.y == -7.0)
        #expect(pose.position.z == -2.0)
    }

    // MARK: - Translatable3D

    @Test func testTranslatedByVector() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 1.0)
        let result = pose.translated(by: Vector3D(x: 2, y: 0, z: 0))
        #expect(result.position == Point3D(x: 3, y: 0, z: 0))
        #expect(result.rotation == pose.rotation)
        #expect(result.scale == pose.scale)
    }

    @Test func testTranslatedBySize() {
        let pose = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let size = Size3D(width: 1, height: 2, depth: 3)
        let result = pose.translated(by: Vector3D(size))
        #expect(result.position == Point3D(x: 1, y: 2, z: 3))
    }

    @Test func testTranslate() {
        var pose = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        pose.translate(by: Vector3D(x: 5, y: 0, z: 0))
        #expect(pose.position.x == 5.0)
    }

    // MARK: - Rotatable3D

    @Test func testRotatedByRotation3D() {
        let pose = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let rotation = Rotation3D(angle: Angle2D(degrees: 90), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let result = pose.rotated(by: rotation)
        #expect(!result.rotation.isIdentity)
    }

    @Test func testRotatedByQuaternion() {
        let pose = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let q = Quaternion3D(angle: Angle2D(degrees: 90), axis: Vector3D(x: 0, y: 1, z: 0))
        let result = pose.rotated(by: q)
        #expect(!result.rotation.isIdentity)
    }

    // MARK: - Equatable

    @Test func testEquatable() {
        let pose1 = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 2.0)
        let pose2 = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 2.0)
        #expect(pose1 == pose2)
    }

    @Test func testNotEqual() {
        let pose1 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let pose2 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 2.0)
        #expect(pose1 != pose2)
    }

    // MARK: - Hashable

    @Test func testHashable() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        var set = Set<ScaledPose3D>()
        set.insert(pose)
        #expect(set.contains(pose))
    }

    @Test func testHashConsistency() {
        let pose1 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let pose2 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        #expect(pose1.hashValue == pose2.hashValue)
    }

    // MARK: - Codable

    @Test func testCodableRoundTrip() throws {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 2.5)
        let data = try JSONEncoder().encode(pose)
        let decoded = try JSONDecoder().decode(ScaledPose3D.self, from: data)
        #expect(decoded == pose)
    }

    // MARK: - isApproximatelyEqual

    @Test func testIsApproximatelyEqualTrue() {
        let pose1 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let pose2 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        #expect(pose1.isApproximatelyEqual(to: pose2))
    }

    @Test func testIsApproximatelyEqualFalse() {
        let pose1 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let pose2 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 2.0)
        #expect(!pose1.isApproximatelyEqual(to: pose2))
    }

    @Test func testIsApproximatelyEqualWithTolerance() {
        let pose1 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0)
        let pose2 = ScaledPose3D(position: .zero, rotation: Rotation3D(), scale: 1.0 + 1e-15)
        #expect(pose1.isApproximatelyEqual(to: pose2))
    }

    // MARK: - description

    @Test func testDescription() {
        let pose = ScaledPose3D(position: Point3D(x: 1, y: 2, z: 3), rotation: Rotation3D(), scale: 1.0)
        let desc = pose.description
        #expect(desc.contains("position:"))
        #expect(desc.contains("rotation:"))
        #expect(desc.contains("scale:"))
    }
}
