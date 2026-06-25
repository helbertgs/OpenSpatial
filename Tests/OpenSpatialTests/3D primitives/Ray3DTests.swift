import Testing
import Foundation
@testable import OpenSpatial

struct Ray3DTests {

    // MARK: - Initialization

    @Test func testDefaultInit() {
        let ray = Ray3D()
        #expect(ray.origin == .zero)
        #expect(ray.direction == .zero)
    }

    @Test func testInitNormalizesDirection() {
        let dir = Vector3D(x: 3, y: 0, z: 0)
        let ray = Ray3D(origin: .zero, direction: dir)
        #expect(ray.direction.x.rounded(toPlaces: 10) == 1.0)
        #expect(ray.direction.y.rounded(toPlaces: 10) == 0.0)
        #expect(ray.direction.z.rounded(toPlaces: 10) == 0.0)
    }

    @Test func testInitDiagonalDirectionNormalized() {
        let dir = Vector3D(x: 1, y: 1, z: 1)
        let ray = Ray3D(origin: .zero, direction: dir)
        let expectedLen = dir.length
        #expect(abs(ray.direction.x - 1.0 / expectedLen) < 1e-10)
        #expect(abs(ray.direction.y - 1.0 / expectedLen) < 1e-10)
        #expect(abs(ray.direction.z - 1.0 / expectedLen) < 1e-10)
    }

    @Test func testInitWithOrigin() {
        let origin = Point3D(x: 1, y: 2, z: 3)
        let dir = Vector3D(x: 0, y: 0, z: 1)
        let ray = Ray3D(origin: origin, direction: dir)
        #expect(ray.origin == origin)
        #expect(ray.direction == dir)
    }

    @Test func testInitDefaultOriginIsZero() {
        let ray = Ray3D(direction: Vector3D(x: 0, y: 1, z: 0))
        #expect(ray.origin == .zero)
    }

    // MARK: - Static properties

    @Test func testZeroRay() {
        let ray = Ray3D.zero
        #expect(ray.origin == .zero)
        #expect(ray.direction == .zero)
    }

    @Test func testInfinityRay() {
        let ray = Ray3D.infinity
        #expect(ray.origin.x.isInfinite)
        #expect(ray.origin.y.isInfinite)
        #expect(ray.origin.z.isInfinite)
    }

    // MARK: - Primitive3D properties

    @Test func testIsNaNFalseForNormal() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        #expect(!ray.isNaN)
    }

    @Test func testIsNaNTrueWhenOriginNaN() {
        let ray = Ray3D(origin: Point3D(x: .nan, y: 0, z: 0), direction: Vector3D(x: 0, y: 0, z: 1))
        #expect(ray.isNaN)
    }

    @Test func testIsNaNTrueWhenDirectionNaN() {
        var ray = Ray3D()
        ray.direction = Vector3D(x: .nan, y: 0, z: 0)
        #expect(ray.isNaN)
    }

    @Test func testIsFiniteTrueForNormal() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        #expect(ray.isFinite)
    }

    @Test func testIsFiniteFalseForInfinityRay() {
        #expect(!Ray3D.infinity.isFinite)
    }

    @Test func testIsZeroTrueForDefaultInit() {
        #expect(Ray3D().isZero)
    }

    @Test func testIsZeroFalseForNonZero() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        #expect(!ray.isZero)
    }

    // MARK: - description

    @Test func testDescription() {
        let ray = Ray3D(origin: Point3D(x: 1, y: 2, z: 3), direction: Vector3D(x: 0, y: 0, z: 1))
        let desc = ray.description
        #expect(desc.contains("origin:"))
        #expect(desc.contains("direction:"))
    }

    // MARK: - Translatable3D

    @Test func testTranslatedByMovesOrigin() {
        let ray = Ray3D(origin: Point3D(x: 1, y: 2, z: 3), direction: Vector3D(x: 0, y: 0, z: 1))
        let translated = ray.translated(by: Vector3D(x: 1, y: 0, z: 0))
        #expect(translated.origin == Point3D(x: 2, y: 2, z: 3))
        #expect(translated.direction == ray.direction)
    }

    @Test func testTranslateByMutates() {
        var ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 1, z: 0))
        ray.translate(by: Vector3D(x: 5, y: 0, z: 0))
        #expect(ray.origin == Point3D(x: 5, y: 0, z: 0))
    }

    // MARK: - Rotatable3D

    @Test func testRotatedByRotation3D() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 1, y: 0, z: 0))
        let rotation = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 0, z: 1))
        let rotated = ray.rotated(by: rotation)
        #expect(abs(rotated.direction.x) < 1e-10)
        #expect(abs(rotated.direction.y - 1.0) < 1e-10)
    }

    @Test func testRotatedByQuaternion() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 1, y: 0, z: 0))
        let q = Quaternion3D(x: 0, y: 0, z: 0, w: 1)
        let rotated = ray.rotated(by: q)
        #expect(abs(rotated.direction.x - 1.0) < 1e-10)
    }

    @Test func testRotationDoesNotMoveOrigin() {
        let origin = Point3D(x: 5, y: 5, z: 5)
        let ray = Ray3D(origin: origin, direction: Vector3D(x: 1, y: 0, z: 0))
        let rotation = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let rotated = ray.rotated(by: rotation)
        #expect(rotated.origin == origin)
    }

    @Test func testRotatedAroundPivotRotation3D() {
        let pivot = Point3D(x: 1, y: 0, z: 0)
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let rotation = Rotation3D(angle: Angle2D(radians: .pi / 2), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let rotated = ray.rotated(by: rotation, around: pivot)
        #expect(abs(rotated.origin.y) < 1e-10)
    }

    @Test func testRotatedAroundPivotQuaternion() {
        let pivot = Point3D(x: 1, y: 0, z: 0)
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let q = Quaternion3D(angle: Angle2D(radians: .pi / 2), axis: Vector3D(x: 0, y: 1, z: 0))
        let rotated = ray.rotated(by: q, around: pivot)
        #expect(abs(rotated.origin.y) < 1e-10)
    }

    // MARK: - Intersects Rect3D

    @Test func testIntersectsRectHit() {
        let ray = Ray3D(origin: Point3D(x: 0, y: 0, z: -5), direction: Vector3D(x: 0, y: 0, z: 1))
        let rect = Rect3D(origin: Point3D(x: -1, y: -1, z: 0), size: Size3D(width: 2, height: 2, depth: 2))
        #expect(ray.intersects(rect))
    }

    @Test func testIntersectsRectMiss() {
        let ray = Ray3D(origin: Point3D(x: 5, y: 0, z: -5), direction: Vector3D(x: 0, y: 0, z: 1))
        let rect = Rect3D(origin: Point3D(x: -1, y: -1, z: 0), size: Size3D(width: 2, height: 2, depth: 2))
        #expect(!ray.intersects(rect))
    }

    @Test func testIntersectsRectOriginInsideBox() {
        let ray = Ray3D(origin: Point3D(x: 0, y: 0, z: 1), direction: Vector3D(x: 0, y: 0, z: 1))
        let rect = Rect3D(origin: Point3D(x: -1, y: -1, z: 0), size: Size3D(width: 2, height: 2, depth: 2))
        #expect(ray.intersects(rect))
    }

    @Test func testIntersectsRectBehindRay() {
        let ray = Ray3D(origin: Point3D(x: 0, y: 0, z: 10), direction: Vector3D(x: 0, y: 0, z: 1))
        let rect = Rect3D(origin: Point3D(x: -1, y: -1, z: 0), size: Size3D(width: 2, height: 2, depth: 2))
        #expect(!ray.intersects(rect))
    }

    // MARK: - Pose3D transforms

    @Test func testApplyingPose3D() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let pose = Pose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D())
        let result = ray.applying(pose)
        #expect(result.origin.x.rounded(toPlaces: 10) == 1.0)
        #expect(abs(result.direction.z - 1.0) < 1e-10)
    }

    @Test func testApplyPose3DMutating() {
        var ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let pose = Pose3D(position: Point3D(x: 2, y: 0, z: 0), rotation: Rotation3D())
        ray.apply(pose)
        #expect(ray.origin.x.rounded(toPlaces: 10) == 2.0)
    }

    @Test func testUnapplyingPose3D() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let pose = Pose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D())
        let applied = ray.applying(pose)
        let unapplied = applied.unapplying(pose)
        #expect(abs(unapplied.origin.x) < 1e-10)
        #expect(abs(unapplied.origin.y) < 1e-10)
        #expect(abs(unapplied.origin.z) < 1e-10)
    }

    // MARK: - ScaledPose3D transforms

    @Test func testApplyingScaledPose3D() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let scaledPose = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 1.0)
        let result = ray.applying(scaledPose)
        #expect(abs(result.origin.x - 1.0) < 1e-10)
    }

    @Test func testUnapplyingScaledPose3D() {
        let ray = Ray3D(origin: Point3D(x: 1, y: 0, z: 0), direction: Vector3D(x: 0, y: 0, z: 1))
        let scaledPose = ScaledPose3D(position: Point3D(x: 1, y: 0, z: 0), rotation: Rotation3D(), scale: 1.0)
        let result = ray.unapplying(scaledPose)
        #expect(abs(result.origin.x) < 1e-10)
    }

    // MARK: - AffineTransform3D transforms

    @Test func testApplyingAffineTransform() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let transform = AffineTransform3D(translation: Vector3D(x: 3, y: 0, z: 0))
        let result = ray.applying(transform)
        #expect(abs(result.origin.x - 3.0) < 1e-10)
        #expect(abs(result.direction.z - 1.0) < 1e-10)
    }

    @Test func testUnapplyingAffineTransform() {
        let ray = Ray3D(origin: Point3D(x: 3, y: 0, z: 0), direction: Vector3D(x: 0, y: 0, z: 1))
        let transform = AffineTransform3D(translation: Vector3D(x: 3, y: 0, z: 0))
        let result = ray.unapplying(transform)
        #expect(abs(result.origin.x) < 1e-10)
    }

    // MARK: - ProjectiveTransform3D transforms

    @Test func testApplyingProjectiveTransform() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let transform = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 1, y: 0, z: 0)))
        let result = ray.applying(transform)
        #expect(abs(result.origin.x - 1.0) < 1e-10)
    }

    @Test func testUnapplyingProjectiveTransform() {
        let ray = Ray3D(origin: Point3D(x: 1, y: 0, z: 0), direction: Vector3D(x: 0, y: 0, z: 1))
        let transform = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 1, y: 0, z: 0)))
        let result = ray.unapplying(transform)
        #expect(abs(result.origin.x) < 1e-10)
    }

    // MARK: - Equatable & Hashable & Codable

    @Test func testEquatable() {
        let ray1 = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let ray2 = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        #expect(ray1 == ray2)
    }

    @Test func testNotEqual() {
        let ray1 = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        let ray2 = Ray3D(origin: Point3D(x: 1, y: 0, z: 0), direction: Vector3D(x: 0, y: 0, z: 1))
        #expect(ray1 != ray2)
    }

    @Test func testHashable() {
        let ray = Ray3D(origin: .zero, direction: Vector3D(x: 0, y: 0, z: 1))
        var set = Set<Ray3D>()
        set.insert(ray)
        #expect(set.contains(ray))
    }

    @Test func testCodableRoundTrip() throws {
        let ray = Ray3D(origin: Point3D(x: 1, y: 2, z: 3), direction: Vector3D(x: 0, y: 0, z: 1))
        let data = try JSONEncoder().encode(ray)
        let decoded = try JSONDecoder().decode(Ray3D.self, from: data)
        #expect(decoded == ray)
    }
}
