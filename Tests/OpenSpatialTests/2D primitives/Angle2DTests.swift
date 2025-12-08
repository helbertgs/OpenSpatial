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
        let angle = Angle2D(radians: Float(Float.pi / 2))
        #expect(angle.radians == Double(Float.pi / 2))
    }

    @Test func testInitializationUsingDegreesFloatingPoint() {
        let angle = Angle2D(degrees: Float(180.0))
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

    @Test func testInitializationUsingStaticDegrees() {
        let angle = Angle2D.degrees(90)
        #expect(angle.radians == Double.pi / 2)
    }

     @Test func testInitializationUsingStaticRadians() {
        let angle = Angle2D.radians(Double.pi / 2)
        #expect(angle.degrees == 90)
    }

    // MARK: - AdditiveArithmetic

    @Test func testZero() {
        let angle = Angle2D.zero
        #expect(angle.degrees == 0)
        #expect(angle.radians == 0)
    }

    @Test func testAddition() {
        let angle1 = Angle2D(radians: Double.pi / 4)
        let angle2 = Angle2D(radians: Double.pi / 4)
        let result = angle1 + angle2
        #expect(result.radians == Double.pi / 2)
    }

    @Test func testAddition2() {
        var angle1 = Angle2D(radians: Double.pi / 4)
        let angle2 = Angle2D(radians: Double.pi / 4)
        angle1 += angle2
        #expect(angle1.radians == Double.pi / 2)
    }

    @Test func testSubtraction() {
        let angle1 = Angle2D(radians: Double.pi / 2)
        let angle2 = Angle2D(radians: Double.pi / 4)
        let result = angle1 - angle2
        #expect(result.radians == Double.pi / 4)
    }

    @Test func testSubtraction2() {
        var angle1 = Angle2D(radians: Double.pi / 2)
        let angle2 = Angle2D(radians: Double.pi / 4)
        angle1 -= angle2
        #expect(angle1.radians == Double.pi / 4)
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

    @Test func testPi() {
        let pi = Angle2D.pi
        #expect(pi == Double.pi)
    }

    @Test func testSqrt() {
        let value = 25.0
        let sqrt = Angle2D.sqrt(value)
        #expect(sqrt == 5.0)
    }

    @Test func testNormalizeAngle() {
        let angle = Angle2D(radians: 4 * Double.pi)
        let normalized = Angle2D.normalize(angle)
        #expect(normalized == 0.0)
    }

    @Test func testNormalizeValue() {
        let value = 5 * Double.pi / 2
        let normalized = Angle2D.normalize(value)
        #expect(normalized == Double.pi / 2)
    }

    @Test func testSine() {
        let angle = Double.pi / 2
        let sine = Angle2D.sin(angle)
        #expect(sine.rounded(toPlaces: 2) == 1.0)
    }

    @Test func testCosine() {
        let angle = Double.pi
        let cosine = Angle2D.cos(angle)
        #expect(cosine.rounded(toPlaces: 2) == -1.0)
    }

    @Test func testTangent() {
        let angle = Double.pi / 4
        let tangent = Angle2D.tan(angle)
        #expect(tangent.rounded(toPlaces: 2) == 1.0)
    }
}