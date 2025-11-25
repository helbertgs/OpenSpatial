import Testing
@testable import OpenSpatial

struct Angle2DTests {

    // MARK: - Creating an angle structure

    @Test func initializationWithRadians() {
        let angle = Angle2D(radians: Double.pi / 4)
        #expect(angle.radians == Double.pi / 4)
    }

    @Test func initializationWithDegrees() {
        let angle = Angle2D(degrees: 90.0)
        #expect(angle.degrees == 90.0)
    }

    @Test func testInitializationUsingRadiansFloatingPoint() {
        let angle = Angle2D(radians: Double(Double.pi / 2))
        #expect(angle.radians == Double.pi / 2)
    }

    @Test func testInitializationUsingDegreesFloatingPoint() {
        let angle = Angle2D(degrees: Double(180.0))
        #expect(angle.degrees == 180.0)
    }

    @Test func testInitializationUsingZero() {
        let angle = Angle2D()
        #expect(angle.radians == 0.0)
    }

    @Test func testInitializationIntergerLiteral() {
        let angle: Angle2D = 0
        #expect(angle.radians == 0.0)
        #expect(angle.degrees == 0.0)
    }

    @Test func testInitializationFloatingPointLiteral() {
        let angle: Angle2D = 1.5708 // Approx. π/2
        #expect(angle.radians == 1.5708)
    }

    // MARK: - AdditiveArithmetic

    @Test func testAddition() {
        let angle1 = Angle2D(radians: Double.pi / 4)
        let angle2 = Angle2D(radians: Double.pi / 4)
        let result = angle1 + angle2
        #expect(result.radians == Double.pi / 2)
    }

    @Test func testSubtraction() {
        let angle1 = Angle2D(radians: Double.pi / 2)
        let angle2 = Angle2D(radians: Double.pi / 4)
        let result = angle1 - angle2
        #expect(result.radians == Double.pi / 4)
    }

    // MARK: - Comparable

    @Test func testComparison() {
        let angle1 = Angle2D(radians: Double.pi / 4)
        let angle2 = Angle2D(radians: Double.pi / 2)
        #expect(angle1 < angle2)
        #expect(angle2 > angle1)
        #expect(angle1 <= angle2)
        #expect(angle2 >= angle1)
    }
}