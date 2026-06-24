import Foundation
import Testing
@testable import OpenSpatial

struct ProjectiveTransform3DTests {

    // MARK: - Initialization

    @Test func testDefaultInit() {
        let t = ProjectiveTransform3D()
        let expected: [[Double]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]
        #expect(t.matrix == expected)
    }

    @Test func testInitWithMatrix() {
        let m: [[Double]] = [
            [2, 0, 0, 0],
            [0, 3, 0, 0],
            [0, 0, 4, 0],
            [0, 0, 0, 1]
        ]
        let t = ProjectiveTransform3D(matrix: m)
        #expect(t.matrix == m)
    }

    @Test func testInitFromAffineTransform() {
        let a = AffineTransform3D(scale: Size3D(width: 2, height: 3, depth: 4))
        let p = ProjectiveTransform3D(a)
        #expect(p.matrix == a.matrix)
    }

    // MARK: - Identity

    @Test func testIdentityProperty() {
        let identity = ProjectiveTransform3D.identity
        #expect(identity == ProjectiveTransform3D())
    }

    @Test func testIsIdentityTrue() {
        #expect(ProjectiveTransform3D().isIdentity)
    }

    @Test func testIsIdentityFalse() {
        let m: [[Double]] = [
            [2, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]
        #expect(!ProjectiveTransform3D(matrix: m).isIdentity)
    }

    // MARK: - isAffine

    @Test func testIsAffineTrue() {
        let t = ProjectiveTransform3D(AffineTransform3D())
        #expect(t.isAffine)
    }

    @Test func testIsAffineFalse() {
        let m: [[Double]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0.1, 0, 0, 1]
        ]
        #expect(!ProjectiveTransform3D(matrix: m).isAffine)
    }

    // MARK: - Subscript

    @Test func testSubscriptGet() {
        let t = ProjectiveTransform3D()
        #expect(t[0, 0] == 1.0)
        #expect(t[1, 1] == 1.0)
        #expect(t[0, 1] == 0.0)
    }

    @Test func testSubscriptSet() {
        var t = ProjectiveTransform3D()
        t[0, 0] = 5.0
        #expect(t[0, 0] == 5.0)
    }

    // MARK: - Inverse

    @Test func testInverseOfIdentity() {
        let inv = ProjectiveTransform3D().inverse
        #expect(inv != nil)
        #expect(inv! == ProjectiveTransform3D())
    }

    @Test func testInverseRoundTrip() {
        let m: [[Double]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [2, 3, 4, 1]
        ]
        let t = ProjectiveTransform3D(matrix: m)
        let inv = t.inverse
        #expect(inv != nil)
        let product = t * inv!
        #expect(product[0, 0].rounded(toPlaces: 10) == 1.0)
        #expect(product[3, 0].rounded(toPlaces: 10) == 0.0)
        #expect(product[3, 1].rounded(toPlaces: 10) == 0.0)
        #expect(product[3, 2].rounded(toPlaces: 10) == 0.0)
    }

    @Test func testInverseOfSingularReturnsNil() {
        let m: [[Double]] = [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ]
        #expect(ProjectiveTransform3D(matrix: m).inverse == nil)
    }

    // MARK: - Concatenation

    @Test func testConcatenating() {
        let a = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 1, y: 2, z: 3)))
        let b = ProjectiveTransform3D(AffineTransform3D(translation: Vector3D(x: 4, y: 5, z: 6)))
        let result = a.concatenating(b)
        #expect(result[3, 0].rounded(toPlaces: 10) == 5.0)
        #expect(result[3, 1].rounded(toPlaces: 10) == 7.0)
        #expect(result[3, 2].rounded(toPlaces: 10) == 9.0)
    }

    @Test func testMultiplyOperator() {
        let a = ProjectiveTransform3D()
        let b = ProjectiveTransform3D()
        let result = a * b
        #expect(result == ProjectiveTransform3D())
    }

    @Test func testMultiplyAssignOperator() {
        var a = ProjectiveTransform3D()
        let b = ProjectiveTransform3D(AffineTransform3D(scale: Size3D(width: 2, height: 2, depth: 2)))
        a *= b
        #expect(a[0, 0] == 2.0)
        #expect(a[1, 1] == 2.0)
        #expect(a[2, 2] == 2.0)
    }

    // MARK: - CustomStringConvertible

    @Test func testDescription() {
        let t = ProjectiveTransform3D()
        let desc = t.description
        #expect(desc.contains("1.0"))
        #expect(desc.contains("["))
    }

    // MARK: - isAffine additional cases

    @Test func testIsAffineWithNonZeroM30() {
        var t = ProjectiveTransform3D()
        t[3, 0] = 0.5
        #expect(!t.isAffine)
    }

    @Test func testIsAffineWithNonZeroM31() {
        var t = ProjectiveTransform3D()
        t[3, 1] = -1.0
        #expect(!t.isAffine)
    }

    @Test func testIsAffineWithNonZeroM32() {
        var t = ProjectiveTransform3D()
        t[3, 2] = 0.001
        #expect(!t.isAffine)
    }

    @Test func testIsAffineWithM33NotOne() {
        var t = ProjectiveTransform3D()
        t[3, 3] = 2.0
        #expect(!t.isAffine)
    }

    @Test func testIsAffineUpperBlockChangesDoNotAffectIsAffine() {
        // Changing only the 3×3 upper-left block does NOT affect isAffine.
        var t = ProjectiveTransform3D()
        t[0, 0] = 5.0
        t[1, 1] = 3.0
        t[2, 2] = 7.0
        #expect(t.isAffine)
    }

    @Test func testIsAffineIdentityIsAffine() {
        #expect(ProjectiveTransform3D.identity.isAffine)
    }

    @Test func testIsAffinePureScaleIsAffine() {
        let t = ProjectiveTransform3D(AffineTransform3D(scale: Size3D(width: 2, height: 3, depth: 4)))
        #expect(t.isAffine)
    }

    @Test func testIsAffinePureRotationIsAffine() {
        let r = Rotation3D(angle: Angle2D(degrees: 45), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let t = ProjectiveTransform3D(AffineTransform3D(rotation: r))
        #expect(t.isAffine)
    }
}
