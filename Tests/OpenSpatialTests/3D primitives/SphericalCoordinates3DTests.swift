import Foundation
import Testing
@testable import OpenSpatial

struct SphericalCoordinates3DTests {

    // MARK: - Initialization

    @Test func testInitWithComponents() {
        let s = SphericalCoordinates3D(
            radius: 5.0,
            inclination: Angle2D(radians: .pi / 4),
            azimuth: Angle2D(radians: .pi / 6)
        )
        #expect(s.radius == 5.0)
        #expect(s.inclination.radians == .pi / 4)
        #expect(s.azimuth.radians == .pi / 6)
    }

    @Test func testInitFromPointOnPosXAxis() {
        // (1, 0, 0) → radius=1, inclination=π/2, azimuth=0
        let s = SphericalCoordinates3D(Point3D(x: 1, y: 0, z: 0))
        #expect(s.radius.rounded(toPlaces: 10) == 1.0)
        #expect(s.inclination.radians.rounded(toPlaces: 10) == (.pi / 2).rounded(toPlaces: 10))
        #expect(s.azimuth.radians.rounded(toPlaces: 10) == 0.0)
    }

    @Test func testInitFromPointOnPosYAxis() {
        // (0, 1, 0) → radius=1, inclination=0, azimuth=0
        let s = SphericalCoordinates3D(Point3D(x: 0, y: 1, z: 0))
        #expect(s.radius.rounded(toPlaces: 10) == 1.0)
        #expect(s.inclination.radians.rounded(toPlaces: 10) == 0.0)
        #expect(s.azimuth.radians.rounded(toPlaces: 10) == 0.0)
    }

    @Test func testInitFromPointOnPosZAxis() {
        // (0, 0, 1) → radius=1, inclination=π/2, azimuth=π/2
        let s = SphericalCoordinates3D(Point3D(x: 0, y: 0, z: 1))
        #expect(s.radius.rounded(toPlaces: 10) == 1.0)
        #expect(s.inclination.radians.rounded(toPlaces: 10) == (.pi / 2).rounded(toPlaces: 10))
        #expect(s.azimuth.radians.rounded(toPlaces: 10) == (.pi / 2).rounded(toPlaces: 10))
    }

    @Test func testInitFromOriginProducesZeroAngles() {
        let s = SphericalCoordinates3D(Point3D(x: 0, y: 0, z: 0))
        #expect(s.radius == 0.0)
        #expect(s.inclination.radians == 0.0)
        #expect(s.azimuth.radians == 0.0)
    }

    // MARK: - Point conversion

    @Test func testPointFromComponents() {
        let s = SphericalCoordinates3D(
            radius: 2.0,
            inclination: Angle2D(radians: .pi / 2),
            azimuth: Angle2D(radians: 0)
        )
        // Should give (2, 0, 0)
        #expect(s.point.x.rounded(toPlaces: 10) == 2.0)
        #expect(s.point.y.rounded(toPlaces: 10) == 0.0)
        #expect(s.point.z.rounded(toPlaces: 10) == 0.0)
    }

    @Test func testPointFromYAxisComponents() {
        let s = SphericalCoordinates3D(
            radius: 3.0,
            inclination: Angle2D(radians: 0),
            azimuth: Angle2D(radians: 0)
        )
        // inclination=0 → points along +y axis
        #expect(s.point.x.rounded(toPlaces: 10) == 0.0)
        #expect(s.point.y.rounded(toPlaces: 10) == 3.0)
        #expect(s.point.z.rounded(toPlaces: 10) == 0.0)
    }

    // MARK: - Round-trip

    @Test func testRoundTripXAxis() {
        let original = Point3D(x: 3, y: 0, z: 0)
        let roundTrip = SphericalCoordinates3D(original).point
        #expect(roundTrip.x.rounded(toPlaces: 10) == original.x.rounded(toPlaces: 10))
        #expect(roundTrip.y.rounded(toPlaces: 10) == original.y.rounded(toPlaces: 10))
        #expect(roundTrip.z.rounded(toPlaces: 10) == original.z.rounded(toPlaces: 10))
    }

    @Test func testRoundTripYAxis() {
        let original = Point3D(x: 0, y: 5, z: 0)
        let roundTrip = SphericalCoordinates3D(original).point
        #expect(roundTrip.x.rounded(toPlaces: 10) == original.x.rounded(toPlaces: 10))
        #expect(roundTrip.y.rounded(toPlaces: 10) == original.y.rounded(toPlaces: 10))
        #expect(roundTrip.z.rounded(toPlaces: 10) == original.z.rounded(toPlaces: 10))
    }

    @Test func testRoundTripArbitraryPoint() {
        let original = Point3D(x: 1, y: 2, z: 3)
        let roundTrip = SphericalCoordinates3D(original).point
        #expect(roundTrip.x.rounded(toPlaces: 10) == original.x.rounded(toPlaces: 10))
        #expect(roundTrip.y.rounded(toPlaces: 10) == original.y.rounded(toPlaces: 10))
        #expect(roundTrip.z.rounded(toPlaces: 10) == original.z.rounded(toPlaces: 10))
    }

    @Test func testRoundTripNegativeCoordinates() {
        let original = Point3D(x: -2, y: -1, z: -3)
        let roundTrip = SphericalCoordinates3D(original).point
        #expect(roundTrip.x.rounded(toPlaces: 10) == original.x.rounded(toPlaces: 10))
        #expect(roundTrip.y.rounded(toPlaces: 10) == original.y.rounded(toPlaces: 10))
        #expect(roundTrip.z.rounded(toPlaces: 10) == original.z.rounded(toPlaces: 10))
    }

    // MARK: - isApproximatelyEqual

    @Test func testIsApproximatelyEqualSame() {
        let s = SphericalCoordinates3D(radius: 1, inclination: Angle2D(radians: .pi / 4), azimuth: Angle2D(radians: .pi / 3))
        #expect(s.isApproximatelyEqual(to: s))
    }

    @Test func testIsApproximatelyEqualWithinTolerance() {
        let s1 = SphericalCoordinates3D(radius: 1.0, inclination: Angle2D(radians: .pi / 4), azimuth: Angle2D(radians: .pi / 3))
        let s2 = SphericalCoordinates3D(radius: 1.0 + 1e-15, inclination: Angle2D(radians: .pi / 4), azimuth: Angle2D(radians: .pi / 3))
        #expect(s1.isApproximatelyEqual(to: s2))
    }

    @Test func testIsNotApproximatelyEqual() {
        let s1 = SphericalCoordinates3D(radius: 1.0, inclination: Angle2D(radians: .pi / 4), azimuth: Angle2D(radians: .pi / 3))
        let s2 = SphericalCoordinates3D(radius: 2.0, inclination: Angle2D(radians: .pi / 4), azimuth: Angle2D(radians: .pi / 3))
        #expect(!s1.isApproximatelyEqual(to: s2))
    }

    @Test func testIsApproximatelyEqualWithCustomTolerance() {
        let s1 = SphericalCoordinates3D(radius: 1.0, inclination: Angle2D(radians: 0), azimuth: Angle2D(radians: 0))
        let s2 = SphericalCoordinates3D(radius: 1.05, inclination: Angle2D(radians: 0), azimuth: Angle2D(radians: 0))
        #expect(s1.isApproximatelyEqual(to: s2, tolerance: 0.1))
        #expect(!s1.isApproximatelyEqual(to: s2, tolerance: 0.01))
    }

    // MARK: - Codable

    @Test func testCodableRoundTrip() throws {
        let s = SphericalCoordinates3D(radius: 3.0, inclination: Angle2D(radians: .pi / 4), azimuth: Angle2D(radians: .pi / 6))
        let data = try JSONEncoder().encode(s)
        let decoded = try JSONDecoder().decode(SphericalCoordinates3D.self, from: data)
        #expect(decoded == s)
    }

    // MARK: - CustomStringConvertible

    @Test func testDescription() {
        let s = SphericalCoordinates3D(radius: 1.0, inclination: Angle2D(radians: 0), azimuth: Angle2D(radians: 0))
        let desc = s.description
        #expect(desc.contains("radius"))
        #expect(desc.contains("1.0"))
    }
}
