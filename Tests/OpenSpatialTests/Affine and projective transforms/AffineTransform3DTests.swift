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
}