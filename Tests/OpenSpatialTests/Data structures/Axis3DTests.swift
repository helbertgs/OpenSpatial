import Testing
@testable import OpenSpatial

struct Axis3DTests {

    @Test func testRawValues() {
        #expect(Axis3D.x.rawValue == 1)
        #expect(Axis3D.y.rawValue == 2)
        #expect(Axis3D.z.rawValue == 4)
    }

    @Test func testAll() {
        #expect(Axis3D.all == Axis3D(rawValue: 7))
        #expect(Axis3D.all == [.x, .y, .z])
    }

    @Test func testUnion() {
        let xy = Axis3D.x.union(.y)
        #expect(xy.rawValue == 3)
        #expect(xy.contains(.x))
        #expect(xy.contains(.y))
        #expect(!xy.contains(.z))
    }

    @Test func testIntersection() {
        let xy: Axis3D = [.x, .y]
        let yz: Axis3D = [.y, .z]
        let intersection = xy.intersection(yz)
        #expect(intersection == .y)
    }

    @Test func testOptionSetLiteralSyntax() {
        let axes: Axis3D = [.x, .z]
        #expect(axes.rawValue == 5)
        #expect(axes.contains(.x))
        #expect(!axes.contains(.y))
        #expect(axes.contains(.z))
    }
}
