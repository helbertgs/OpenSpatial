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

    // MARK: - Geometry functions

    @Test func testCos() {
        let angle = Angle2D(radians: Double.pi / 3) // 60 degrees
        let cosValue = Angle2D.cos(angle.radians)
        #expect(abs(cosValue - 0.5) < 0.0001)
    }

    @Test func testSin() {
        let angle = Angle2D(radians: Double.pi / 6) // 30 degrees
        let sinValue = Angle2D.sin(angle.radians)
        #expect(abs(sinValue - 0.5) < 0.0001)
    }

    @Test func testAcos() {
        let angle = Angle2D.acos(0.5)
        #expect(abs(angle.radians - (Double.pi / 3)) < 0.0001)
    }

    @Test func testAcosh() {
        let angle = Angle2D.acosh(2.0)
        #expect(abs(angle.radians - 1.31696) < 0.0001)
    }

    @Test func testAsin() {
        let angle = Angle2D.asin(0.5)
        #expect(abs(angle.radians - (Double.pi / 6)) < 0.0001)
    }

    @Test func testAsinh() {
        let angle = Angle2D.asinh(1.0)
        #expect(abs(angle.radians - 0.88137) < 0.0001)
    }

    @Test func testAtan() {
        let angle = Angle2D.atan(1.0)
        #expect(abs(angle.radians - (Double.pi / 4)) < 0.0001)
    }

    @Test func testAtan2() {
        let angle = Angle2D.atan2(y: 1.0, x: 1.0)
        #expect(abs(angle.radians - (Double.pi / 4)) < 0.0001)
    }

    @Test func testAtanh() {
        let angle = Angle2D.atanh(0.5)
        #expect(abs(angle.radians - 0.5493) < 0.0001)
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