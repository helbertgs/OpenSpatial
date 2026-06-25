import Testing
@testable import OpenSpatial

struct Shearable3DTests {

    // MARK: - Vector3D

    @Test func testVector3DShearXAxis() {
        let v = Vector3D(x: 1, y: 2, z: 3)
        let result = v.sheared(.xAxis(yShearFactor: 2, zShearFactor: 3))
        #expect(result == Vector3D(x: 14, y: 2, z: 3))
    }

    @Test func testVector3DShearYAxis() {
        let v = Vector3D(x: 1, y: 1, z: 1)
        let result = v.sheared(.yAxis(xShearFactor: 1, zShearFactor: 1))
        #expect(result == Vector3D(x: 1, y: 3, z: 1))
    }

    @Test func testVector3DShearZAxis() {
        let v = Vector3D(x: 1, y: 1, z: 1)
        let result = v.sheared(.zAxis(xShearFactor: 1, yShearFactor: 1))
        #expect(result == Vector3D(x: 1, y: 1, z: 3))
    }

    // MARK: - AffineTransform3D

    @Test func testAffineTransform3DShearXAxisMatrix() {
        let result = AffineTransform3D.identity.sheared(.xAxis(yShearFactor: 2, zShearFactor: 3))
        #expect(result.matrix[1][0] == 2)
        #expect(result.matrix[2][0] == 3)
    }

    // MARK: - Rect3D

    @Test func testRect3DShearIdentity() {
        let rect = Rect3D(origin: Point3D(x: 1, y: 2, z: 3), size: Size3D(width: 4, height: 5, depth: 6))
        let result = rect.sheared(.xAxis(yShearFactor: 0, zShearFactor: 0))
        #expect(result.origin.x == rect.origin.x)
        #expect(result.origin.y == rect.origin.y)
        #expect(result.origin.z == rect.origin.z)
        #expect(result.size.width == rect.size.width)
        #expect(result.size.height == rect.size.height)
        #expect(result.size.depth == rect.size.depth)
    }

    // MARK: - Size3D

    @Test func testSize3DShearYAxis() {
        let s = Size3D(width: 2, height: 3, depth: 4)
        let result = s.sheared(.yAxis(xShearFactor: 1, zShearFactor: 0))
        #expect(result.width == 2)
        #expect(result.height == 5)
        #expect(result.depth == 4)
    }
}
