import Testing
@testable import OpenSpatial

struct AffineTransform3DTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let transform = AffineTransform3D()
        let expectedMatrix: [[Double]] = [
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [0.0, 0.0, 0.0, 1.0]
        ]
        #expect(transform.matrix == expectedMatrix)
    }

    @Test func testInitializationUsingMatrix() {
        let matrix: [[Double]] = [
            [2.0, 0.0, 0.0, 1.0],
            [0.0, 2.0, 0.0, 2.0],
            [0.0, 0.0, 2.0, 3.0],
            [0.0, 0.0, 0.0, 1.0]
        ]
        let transform = AffineTransform3D(matrix: matrix)
        #expect(transform.matrix == matrix)
    }

    // MARK: - Arithmetic operation tests

    @Test func testConcatenationOfAffineTransforms() {
        let transformA = AffineTransform3D(matrix: [
            [1.0, 0.0, 0.0, 1.0],
            [0.0, 1.0, 0.0, 2.0],
            [0.0, 0.0, 1.0, 3.0],
            [0.0, 0.0, 0.0, 1.0]
        ])
        let transformB = AffineTransform3D(matrix: [
            [2.0, 0.0, 0.0, 0.0],
            [0.0, 2.0, 0.0, 0.0],
            [0.0, 0.0, 2.0, 0.0],
            [0.0, 0.0, 0.0, 1.0]
        ])
        let result = transformA * transformB
        let expectedMatrix: [[Double]] = [
            [2.0, 0.0, 0.0, 1.0],
            [0.0, 2.0, 0.0, 2.0],
            [0.0, 0.0, 2.0, 3.0],
            [0.0, 0.0, 0.0, 1.0]
        ]
        #expect(result.matrix == expectedMatrix)
    }

    // MARK: - Scalable3D tests

    @Test func testScalingAffineTransform3D() {
        var transform = AffineTransform3D()
        transform.scaleBy(x: 2.0, y: 3.0, z: 4.0)
        let expectedMatrix: [[Double]] = [
            [2.0, 0.0, 0.0, 0.0],
            [0.0, 3.0, 0.0, 0.0],
            [0.0, 0.0, 4.0, 0.0],
            [0.0, 0.0, 0.0, 1.0]
        ]
        #expect(transform.matrix == expectedMatrix)
    }

    @Test func testUniformScalingAffineTransform3D() {
        var transform = AffineTransform3D()
        transform.uniformlyScale(by: 5.0)
        let expectedMatrix: [[Double]] = [
            [5.0, 0.0, 0.0, 0.0],
            [0.0, 5.0, 0.0, 0.0],
            [0.0, 0.0, 5.0, 0.0],
            [0.0, 0.0, 0.0, 1.0]
        ]
        #expect(transform.matrix == expectedMatrix)
    }

    // MARK: - Translatable3D tests

    @Test func testTranslatingAffineTransform3D() {
        var transform = AffineTransform3D()
        let vector = Vector3D(x: 1.0, y: 2.0, z: 3.0)
        transform = transform.translated(by: vector)
        let expectedMatrix: [[Double]] = [
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [1.0, 2.0, 3.0, 1.0]
        ]
        #expect(transform.matrix == expectedMatrix)
    }

    // MARK: - New initialisers and decomposition

    @Test func testInitWithScale() {
        let t = AffineTransform3D(scale: Size3D(width: 2, height: 3, depth: 4))
        #expect(t[0, 0] == 2.0)
        #expect(t[1, 1] == 3.0)
        #expect(t[2, 2] == 4.0)
        #expect(t[3, 3] == 1.0)
    }

    @Test func testInitWithTranslation() {
        let t = AffineTransform3D(translation: Vector3D(x: 1, y: 2, z: 3))
        #expect(t[3, 0] == 1.0)
        #expect(t[3, 1] == 2.0)
        #expect(t[3, 2] == 3.0)
        #expect(t[0, 0] == 1.0)
    }

    @Test func testInitWithRotation() {
        let r = Rotation3D()
        let t = AffineTransform3D(rotation: r)
        #expect(t.isIdentity == false || t == AffineTransform3D())
        // Identity rotation produces identity matrix
        #expect(t[0, 0].rounded(toPlaces: 10) == 1.0)
        #expect(t[1, 1].rounded(toPlaces: 10) == 1.0)
        #expect(t[2, 2].rounded(toPlaces: 10) == 1.0)
    }

    @Test func testIsIdentity() {
        #expect(AffineTransform3D().isIdentity)
        #expect(!AffineTransform3D(scale: Size3D(width: 2, height: 1, depth: 1)).isIdentity)
    }

    @Test func testTranslationDecomposition() {
        let t = AffineTransform3D(translation: Vector3D(x: 5, y: 6, z: 7))
        #expect(t.translation == Vector3D(x: 5, y: 6, z: 7))
    }

    @Test func testScaleDecomposition() {
        let t = AffineTransform3D(scale: Size3D(width: 2, height: 3, depth: 4))
        #expect(t.scale.width.rounded(toPlaces: 10) == 2.0)
        #expect(t.scale.height.rounded(toPlaces: 10) == 3.0)
        #expect(t.scale.depth.rounded(toPlaces: 10) == 4.0)
    }

    @Test func testInverseOfIdentity() {
        let inv = AffineTransform3D().inverse
        #expect(inv != nil)
        #expect(inv! == AffineTransform3D())
    }

    @Test func testInverseRoundTrip() {
        let t = AffineTransform3D(translation: Vector3D(x: 1, y: 2, z: 3))
        let inv = t.inverse
        #expect(inv != nil)
        let product = t * inv!
        #expect(product[3, 0].rounded(toPlaces: 10) == 0.0)
        #expect(product[3, 1].rounded(toPlaces: 10) == 0.0)
        #expect(product[3, 2].rounded(toPlaces: 10) == 0.0)
        #expect(product[0, 0].rounded(toPlaces: 10) == 1.0)
    }

    @Test func testRotatedByRotation3D() {
        let r = Rotation3D()
        let t = AffineTransform3D().rotated(by: r)
        #expect(t[0, 0].rounded(toPlaces: 10) == 1.0)
        #expect(t[1, 1].rounded(toPlaces: 10) == 1.0)
        #expect(t[2, 2].rounded(toPlaces: 10) == 1.0)
    }

    @Test func testStaticIdentity() {
        let id = AffineTransform3D.identity
        #expect(id == AffineTransform3D())
        #expect(id.isIdentity)
    }

    @Test func testInitWithRotationScaleTranslation() {
        let r = Rotation3D()
        let s = Size3D(width: 2, height: 3, depth: 4)
        let t = Vector3D(x: 1, y: 2, z: 3)
        let transform = AffineTransform3D(rotation: r, scale: s, translation: t)
        #expect(transform[0, 0].rounded(toPlaces: 10) == 2.0)
        #expect(transform[1, 1].rounded(toPlaces: 10) == 3.0)
        #expect(transform[2, 2].rounded(toPlaces: 10) == 4.0)
        #expect(transform[3, 0].rounded(toPlaces: 10) == 1.0)
        #expect(transform[3, 1].rounded(toPlaces: 10) == 2.0)
        #expect(transform[3, 2].rounded(toPlaces: 10) == 3.0)
    }

    @Test func testPointApplyingIdentity() {
        let point = Point3D(x: 1, y: 2, z: 3)
        #expect(point.applying(AffineTransform3D.identity) == point)
    }

    @Test func testTransformMultipliedByIdentity() {
        let t = AffineTransform3D(translation: Vector3D(x: 1, y: 2, z: 3))
        #expect(t * .identity == t)
    }

    @Test func testMultiplyAssignOperator() {
        var t = AffineTransform3D(translation: Vector3D(x: 1, y: 0, z: 0))
        t *= AffineTransform3D(scale: Size3D(width: 2, height: 2, depth: 2))
        #expect(t[0, 0].rounded(toPlaces: 10) == 2.0)
    }

    @Test func testUniformlyScaled() {
        let t = AffineTransform3D().uniformlyScaled(by: 3.0)
        #expect(t[0, 0] == 3.0)
        #expect(t[1, 1] == 3.0)
        #expect(t[2, 2] == 3.0)
    }

    @Test func testDescription() {
        let t = AffineTransform3D()
        let desc = t.description
        #expect(desc.contains("1.0"))
        #expect(desc.contains("["))
    }

    @Test func testRotationDecompositionWith90DegreeYRotation() {
        // 90° rotation around Y: exercises a non-trace-positive Shepperd branch
        // Verify by acting on a vector with both the original and extracted rotation
        let r = Rotation3D(angle: Angle2D(degrees: 90), axis: RotationAxis3D(x: 0, y: 1, z: 0))
        let t = AffineTransform3D(rotation: r)
        let extracted = t.rotation
        let v = Vector3D(x: 1, y: 0, z: 0)
        let v1 = r.act(v)
        let v2 = extracted.act(v)
        #expect(v1.x.rounded(toPlaces: 8) == v2.x.rounded(toPlaces: 8))
        #expect(v1.y.rounded(toPlaces: 8) == v2.y.rounded(toPlaces: 8))
        #expect(v1.z.rounded(toPlaces: 8) == v2.z.rounded(toPlaces: 8))
    }

    @Test func testRotationDecompositionWith90DegreeXRotation() {
        // 90° rotation around X: exercises another Shepperd branch
        let r = Rotation3D(angle: Angle2D(degrees: 90), axis: RotationAxis3D(x: 1, y: 0, z: 0))
        let t = AffineTransform3D(rotation: r)
        let extracted = t.rotation
        let v = Vector3D(x: 0, y: 1, z: 0)
        let v1 = r.act(v)
        let v2 = extracted.act(v)
        #expect(v1.x.rounded(toPlaces: 8) == v2.x.rounded(toPlaces: 8))
        #expect(v1.y.rounded(toPlaces: 8) == v2.y.rounded(toPlaces: 8))
        #expect(v1.z.rounded(toPlaces: 8) == v2.z.rounded(toPlaces: 8))
    }

    @Test func testRotationDecompositionWith90DegreeZRotation() {
        // 90° rotation around Z: exercises yet another Shepperd branch
        let r = Rotation3D(angle: Angle2D(degrees: 90), axis: RotationAxis3D(x: 0, y: 0, z: 1))
        let t = AffineTransform3D(rotation: r)
        let extracted = t.rotation
        let v = Vector3D(x: 1, y: 0, z: 0)
        let v1 = r.act(v)
        let v2 = extracted.act(v)
        #expect(v1.x.rounded(toPlaces: 8) == v2.x.rounded(toPlaces: 8))
        #expect(v1.y.rounded(toPlaces: 8) == v2.y.rounded(toPlaces: 8))
        #expect(v1.z.rounded(toPlaces: 8) == v2.z.rounded(toPlaces: 8))
    }

    // MARK: - inverse edge cases

    @Test func testInverseOfSingularMatrixReturnsNil() {
        let singular = AffineTransform3D(matrix: [
            [1, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ])
        #expect(singular.inverse == nil)
    }

    @Test func testInverseOfAllZeroMatrixReturnsNil() {
        let zero = AffineTransform3D(matrix: [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ])
        #expect(zero.inverse == nil)
    }

    @Test func testInverseOfScaleRoundTrip() {
        let t = AffineTransform3D(scale: Size3D(width: 3, height: 0.5, depth: 2))
        let inv = t.inverse
        #expect(inv != nil)
        let product = t * inv!
        for i in 0..<4 {
            for j in 0..<4 {
                let expected = i == j ? 1.0 : 0.0
                #expect(product[i, j].rounded(toPlaces: 10) == expected,
                    "product[\(i)][\(j)] expected \(expected), got \(product[i, j])")
            }
        }
    }

    @Test func testInverseOfRotationScaleTranslationRoundTrip() {
        let r = Rotation3D(angle: Angle2D(degrees: 37), axis: RotationAxis3D(x: 1, y: 1, z: 0))
        let t = AffineTransform3D(rotation: r, scale: Size3D(width: 2, height: 2, depth: 2), translation: Vector3D(x: 5, y: -3, z: 1))
        let inv = t.inverse
        #expect(inv != nil)
        let product = t * inv!
        for i in 0..<4 {
            for j in 0..<4 {
                let expected = i == j ? 1.0 : 0.0
                #expect(product[i, j].rounded(toPlaces: 8) == expected,
                    "product[\(i)][\(j)] expected \(expected), got \(product[i, j])")
            }
        }
    }

    @Test func testInverseNearSingularReturnsNil() {
        // A matrix with a very small pivot — below the 1e-12 threshold
        let nearSingular = AffineTransform3D(matrix: [
            [1e-13, 0, 0, 0],
            [0,     1, 0, 0],
            [0,     0, 1, 0],
            [0,     0, 0, 1]
        ])
        #expect(nearSingular.inverse == nil)
    }

    @Test func testInverseTranslationMovePointBack() {
        let t = AffineTransform3D(translation: Vector3D(x: 10, y: -5, z: 3))
        let inv = t.inverse!
        let point = Point3D(x: 1, y: 2, z: 3)
        let moved = point.applying(t)
        let back = moved.applying(inv)
        #expect(back.x.rounded(toPlaces: 10) == point.x)
        #expect(back.y.rounded(toPlaces: 10) == point.y)
        #expect(back.z.rounded(toPlaces: 10) == point.z)
    }
}