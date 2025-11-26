import Testing
@testable import OpenSpatial

struct Size3DTests {

    // MARK: - Initialization tests

    @Test func testInitialization() {
        let size = Size3D()
        #expect(size.width == 0.0)
        #expect(size.height == 0.0)
        #expect(size.depth == 0.0)
    }
    @Test func testInitializationUsingDefaultParams() {
        let size = Size3D(width: 2.0, height: 1.0)
        #expect(size.width == 2.0)
        #expect(size.height == 1.0)
        #expect(size.depth == 0.0)
    }
    @Test func testInitializationUsingFloatingPoint() {
        let size = Size3D(width: Float(3.5), height: Float(4.5), depth: Float(5.5))
        #expect(size.width == 3.5)
        #expect(size.height == 4.5)
        #expect(size.depth == 5.5)
    }
    @Test func testInitializationUsingArrayLiteral() {
        let size: Size3D = [1.0, 2.0, 3.0]
        #expect(size.width == 1.0)
        #expect(size.height == 2.0)
        #expect(size.depth == 3.0)
    }

    @Test func testInitializationUsingVector3D() {
        let vector = Vector3D(x: 4.0, y: 5.0, z: 6.0)
        let size = Size3D(vector)
        #expect(size.width == 4.0)
        #expect(size.height == 5.0)
        #expect(size.depth == 6.0)
    }

    @Test func testSubscriptAccess() throws {
        let size = Size3D(width: 7.0, height: 8.0, depth: 9.0)
        #expect(try size[0] == 7.0)
        #expect(try size[1] == 8.0)
        #expect(try size[2] == 9.0)
    }

    @Test func testSubscriptError() throws {
        let size = Size3D(width: 7.0, height: 8.0, depth: 9.0)
        #expect(throws: OpenSpatial.Error.self) {
            try size[4] == 0
        }
    }

    // MARK: - Creating derived 3D sizes

    @Test func testIntersection() {
        let size1 = Size3D(width: 5.0, height: 7.0, depth: 9.0)
        let size2 = Size3D(width: 6.0, height: 4.0, depth: 10.0)
        
        let intersectionSize = size1.intersection(size2)
        #expect(intersectionSize?.width == 5.0)
        #expect(intersectionSize?.height == 4.0)
        #expect(intersectionSize?.depth == 9.0)
    }

    // MARK: - Applying arithmetic operations

    @Test func testZerioSize() {
        let zeroSize = Size3D.zero
        #expect(zeroSize.width == 0.0)
        #expect(zeroSize.height == 0.0)
        #expect(zeroSize.depth == 0.0)
    }

    @Test func testOneSize() {
        let oneSize = Size3D.one
        #expect(oneSize.width == 1.0)
        #expect(oneSize.height == 1.0)
        #expect(oneSize.depth == 1.0)
    }

    @Test func testMultiplication() {
        let size = Size3D(width: 2.0, height: 3.0, depth: 4.0)
        let scaledSize = size * 2.0
        #expect(scaledSize.width == 4.0)
        #expect(scaledSize.height == 6.0)
        #expect(scaledSize.depth == 8.0)
    }

    @Test func testMultiplication2() {
        var size = Size3D(width: 2.0, height: 3.0, depth: 4.0)
        size *= 2.0
        #expect(size.width == 4.0)
        #expect(size.height == 6.0)
        #expect(size.depth == 8.0)
    }

    @Test func testAddition() {
        let size1 = Size3D(width: 1.0, height: 2.0, depth: 3.0)
        let size2 = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        let sum = size1 + size2
        #expect(sum.width == 5.0)
        #expect(sum.height == 7.0)
        #expect(sum.depth == 9.0)
    }

    @Test func testAddition2() {
        var size1 = Size3D(width: 1.0, height: 2.0, depth: 3.0)
        let size2 = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        size1 += size2
        #expect(size1.width == 5.0)
        #expect(size1.height == 7.0)
        #expect(size1.depth == 9.0)
    }

    @Test func testSubtraction() {
        let size1 = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        let size2 = Size3D(width: 1.0, height: 2.0, depth: 3.0)
        let difference = size1 - size2
        #expect(difference.width == 3.0)
        #expect(difference.height == 3.0)
        #expect(difference.depth == 3.0)
    }

    @Test func testSubtraction2() {
        var size1 = Size3D(width: 4.0, height: 5.0, depth: 6.0)
        let size2 = Size3D(width: 1.0, height: 2.0, depth: 3.0)
        size1 -= size2
        #expect(size1.width == 3.0)
        #expect(size1.height == 3.0)
        #expect(size1.depth == 3.0)
    }

    @Test func testDivision() {
        let size = Size3D(width: 4.0, height: 8.0, depth: 12.0)
        let dividedSize = size / 2.0
        #expect(dividedSize.width == 2.0)
        #expect(dividedSize.height == 4.0)
        #expect(dividedSize.depth == 6.0)
    }

    @Test func testDivision2() {
        var size = Size3D(width: 4.0, height: 8.0, depth: 12.0)
        size /= 2.0
        #expect(size.width == 2.0)
        #expect(size.height == 4.0)
        #expect(size.depth == 6.0)
    }

    // MARK: - Primitive3D tests

    @Test func testIsFinite() {
        let size = Size3D(width: 1.0, height: 2.0, depth: 3.0)
        #expect(size.isFinite == true)
    }

    @Test func testIsNotFinite() {
        let size = Size3D(width: Double.infinity, height: 2.0, depth: 3.0)
        #expect(size.isFinite == false)
    }

    @Test func testIsZero() {
        let size = Size3D.zero
        #expect(size.isZero == true)
    }

    @Test func testIsNaN() {
        let size = Size3D(width: Double.nan, height: 2.0, depth: 3.0)
        #expect(size.isNaN == true)
    }

    @Test func testInfinity() {
        let infinity = Size3D.infinity
        #expect(infinity.width == Double.infinity)
        #expect(infinity.height == Double.infinity)
        #expect(infinity.depth == Double.infinity)
    }

    @Test func testApplyingAffineTransform() {
        let size1 = Size3D.one
        let size2 = size1.applying(.init())

        #expect(size2 == .one)
    }

    // MARK: - Scalable3D tests

    @Test func testScaledBy() {
        let size = Size3D(width: 2.0, height: 3.0, depth: 4.0)
        let scaledSize = size.scaled(by: .init(width: 3, height: 3, depth: 3))
        #expect(scaledSize.width == 6.0)
        #expect(scaledSize.height == 9.0)
        #expect(scaledSize.depth == 12.0)
    }

    @Test func testUniformScale() {
        let size = Size3D(width: 2.0, height: 3.0, depth: 4.0)
        let uniformScaledSize = size.uniformlyScaled(by: 2.0)
        #expect(uniformScaledSize.width == 4.0)
        #expect(uniformScaledSize.height == 6.0)
        #expect(uniformScaledSize.depth == 8.0)
    }

    // MARK: - Volumetric3D tests

    @Test func testSize() {
        let size1 = Size3D(width: 5.0, height: 5.0, depth: 5.0)
        #expect(size1.size == Size3D(width: 5.0, height: 5.0, depth: 5.0))
    }

    @Test func testContains() {
        let size1 = Size3D(width: 5.0, height: 5.0, depth: 5.0)
        let size2 = Size3D(width: 3.0, height: 3.0, depth: 3.0)
        #expect(size1.contains(size2) == true)
    }

    @Test func testContainsPoint() {
        let size = Size3D(width: 5.0, height: 5.0, depth: 5.0)
        let point = Point3D(x: 2.0, y: 2.0, z: 2.0)
        #expect(size.contains(point: point) == true)
    }

    @Test func testIntersectionWithNoOverlap() {
        let size1 = Size3D(width: 2.0, height: 2.0, depth: 2.0)
        let size2 = Size3D(width: 2.0, height: 2.0, depth: 2.0)
        
        let intersectionSize = size1.intersection(size2)
        #expect(intersectionSize?.width == 2.0)
        #expect(intersectionSize?.height == 2.0)
        #expect(intersectionSize?.depth == 2.0)
    }

    @Test func testIntersectionWithPartialOverlap() {
        let size1 = Size3D(width: 4.0, height: 4.0, depth: 4.0)
        let size2 = Size3D(width: 3.0, height: 5.0, depth: 2.0)
        
        let intersectionSize = size1.intersection(size2)
        #expect(intersectionSize?.width == 3.0)
        #expect(intersectionSize?.height == 4.0)
        #expect(intersectionSize?.depth == 2.0)
    }

    @Test func testIntersectionWithCompleteOverlap() {
        let size1 = Size3D(width: 5.0, height: 5.0, depth: 5.0)
        let size2 = Size3D(width: 5.0, height: 5.0, depth: 5.0)
        
        let intersectionSize = size1.intersection(size2)
        #expect(intersectionSize?.width == 5.0)
        #expect(intersectionSize?.height == 5.0)
        #expect(intersectionSize?.depth == 5.0)
    }

    @Test func testIntersectionWithEdgeTouching() {
        let size1 = Size3D(width: 3.0, height: 3.0, depth: 3.0)
        let size2 = Size3D(width: 3.0, height: 3.0, depth: 3.0)
        
        let intersectionSize = size1.intersection(size2)
        #expect(intersectionSize?.width == 3.0)
        #expect(intersectionSize?.height == 3.0)
        #expect(intersectionSize?.depth == 3.0)
    }

    @Test func testIntersectionNil() {
        let size1 = Size3D(width: 3.0, height: 3.0, depth: 3.0)
        let size2 = Size3D(width: -4.0, height: -8.0, depth: -2.0)
        
        let intersectionSize = size1.intersection(size2)
        #expect(intersectionSize == nil)
    }

    @Test func testUnion() {
        let size1 = Size3D(width: 2.0, height: 3.0, depth: 4.0)
        let size2 = Size3D(width: 5.0, height: 6.0, depth: 7.0)
        
        let unionSize = size1.union(size2)
        #expect(unionSize.width == 5.0)
        #expect(unionSize.height == 6.0)
        #expect(unionSize.depth == 7.0)
    }

    @Test func testDescription() {
        let size = Size3D(width: 1.0, height: 2.0, depth: 3.0)
        #expect(size.description == "(width: 1.0, height: 2.0, depth: 3.0)")
    }
}