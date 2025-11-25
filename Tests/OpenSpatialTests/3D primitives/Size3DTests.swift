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

    @Test func testSubscriptAccess() {
        let size = Size3D(width: 7.0, height: 8.0, depth: 9.0)
        #expect(size[0] == 7.0)
        #expect(size[1] == 8.0)
        #expect(size[2] == 9.0)
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

    @Test func testInfinityVector() {
        let infinitySize = Size3D.infinity
        #expect(infinitySize.width == Double.infinity)
        #expect(infinitySize.height == Double.infinity)
        #expect(infinitySize.depth == Double.infinity)
    }
}