import Testing
@testable import OpenSpatial

// A simple concrete coordinate space used only in tests.
// Each instance holds a fixed ProjectiveTransform3D as its "offset from parent".
private struct TestSpace: CoordinateSpace3D {
    typealias AncestorCoordinateSpace = WorldReferenceCoordinateSpace

    let ancestorSpace: WorldReferenceCoordinateSpace? = WorldReferenceCoordinateSpace()
    let offsetTransform: ProjectiveTransform3D

    func ancestorFromSpaceTransform() throws -> ProjectiveTransform3D {
        offsetTransform
    }

    func transform(from target: TestSpace) throws -> ProjectiveTransform3D {
        let selfFromRoot = try _transformToRoot()
        let targetFromRoot = try target._transformToRoot()
        guard let inv = selfFromRoot.inverse else { throw Error.noAncestorSpace }
        return inv * targetFromRoot
    }
}

struct CoordinateSpace3DTests {

    @Test func testWorldReferenceAncestorSpaceIsNil() {
        let world = WorldReferenceCoordinateSpace()
        #expect(world.ancestorSpace == nil)
    }

    @Test func testWorldReferenceAncestorFromSpaceTransformThrows() {
        let world = WorldReferenceCoordinateSpace()
        #expect(throws: (any Swift.Error).self) {
            try world.ancestorFromSpaceTransform()
        }
    }

    @Test func testWorldReferenceStaticProperty() {
        let world: WorldReferenceCoordinateSpace = .worldReference
        #expect(world.ancestorSpace == nil)
    }

    @Test func testWorldReferenceTransformFromSelfIsIdentity() throws {
        let world = WorldReferenceCoordinateSpace()
        let t = try world.transform(from: world)
        #expect(t.isIdentity)
    }

    @Test func testWorldReferenceConvertPointToSelf() throws {
        let world = WorldReferenceCoordinateSpace()
        let point = Point3D(x: 1, y: 2, z: 3)
        let result = try world.convert(value: point, to: world)
        #expect(result == point)
    }

    // MARK: - TestSpace (child of world)

    @Test func testChildSpaceTransformToRootIsItsOwnTransform() throws {
        let offset = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 5, y: 0, z: 0)))
        let child = TestSpace(offsetTransform: offset)
        let toRoot = try child._transformToRoot()
        #expect(toRoot[3, 0].rounded(toPlaces: 10) == 5.0)
    }

    @Test func testTransformBetweenTwoChildSpaces() throws {
        // childA is offset +10 on X from world, childB is offset +3 on X from world.
        // transform(from: childB) as seen by childA should give -7 on X (childB - childA).
        let offsetA = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 10, y: 0, z: 0)))
        let offsetB = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 3, y: 0, z: 0)))
        let childA = TestSpace(offsetTransform: offsetA)
        let childB = TestSpace(offsetTransform: offsetB)
        let t = try childA.transform(from: childB)
        let point = Point3D(x: 0, y: 0, z: 0)
        let converted = point.applying(t)
        #expect(converted.x.rounded(toPlaces: 8) == -7.0)
        #expect(converted.y.rounded(toPlaces: 8) == 0.0)
        #expect(converted.z.rounded(toPlaces: 8) == 0.0)
    }

    @Test func testConvertValueBetweenChildSpaces() throws {
        // childA has offset Y+5 from world, childB has offset Y+2 from world.
        // The point Y=0 in childA sits at Y=5 in world.
        // From childB's perspective (offset Y+2), that world-Y=5 point is at Y=5-2=3
        // in childB... BUT the transform is: selfFromRoot⁻¹ * targetFromRoot.
        // selfFromRoot for childA is the translation +5; its inverse is -5.
        // targetFromRoot for childB is +2.
        // Combined: inverse(+5) * (+2) = (-5) + 2 applied to origin = -5+2 = -3.
        // So converting point(0,0,0) from childA to childB gives y=-3.
        let offsetA = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 0, y: 5, z: 0)))
        let offsetB = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 0, y: 2, z: 0)))
        let childA = TestSpace(offsetTransform: offsetA)
        let childB = TestSpace(offsetTransform: offsetB)
        let point = Point3D(x: 0, y: 0, z: 0)
        let result = try childA.convert(value: point, to: childB)
        #expect(result.y.rounded(toPlaces: 8) == -3.0)
    }

    @Test func testConvertValueFromChildSpaceToWorld() throws {
        // world.convert(value: p, from: child) calls child.transform(from: world) applied to p.
        // child.transform(from: world) = childFromRoot⁻¹ * worldFromRoot
        //   = inverse(translation(0,0,7)) * identity = translation(0,0,-7)
        // So point(1,2,3) becomes (1, 2, 3-7) = (1, 2, -4).
        let offset = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 0, y: 0, z: 7)))
        let child = TestSpace(offsetTransform: offset)
        let world = WorldReferenceCoordinateSpace()
        let point = Point3D(x: 1, y: 2, z: 3)
        let result = try world.convert(value: point, from: child)
        #expect(result.z.rounded(toPlaces: 8) == -4.0)
    }

    @Test func testTransformFromSelfIsIdentity() throws {
        let offset = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 4, y: 4, z: 4)))
        let child = TestSpace(offsetTransform: offset)
        let t = try child.transform(from: child)
        #expect(t.isIdentity)
    }

    @Test func testTransformSpaceModifiesConversion() throws {
        let world = WorldReferenceCoordinateSpace()
        // Add a 2× uniform scale via transformSpace
        let scaled = world.transformSpace { _ in
            ProjectiveTransform3D(AffineTransform3D(scale: Size3D(width: 2, height: 2, depth: 2)))
        }
        let toRoot = try scaled._transformToRoot()
        // The scale should appear in the transform chain
        #expect(toRoot[0, 0].rounded(toPlaces: 8) == 2.0)
        #expect(toRoot[1, 1].rounded(toPlaces: 8) == 2.0)
        #expect(toRoot[2, 2].rounded(toPlaces: 8) == 2.0)
    }
}
