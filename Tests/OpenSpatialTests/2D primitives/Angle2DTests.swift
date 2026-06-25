import Foundation
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

    @Test func testIsApproximatelyEqual() {
        let a = Angle2D(degrees: 90)
        let b = Angle2D(radians: Double.pi / 2)
        #expect(a.isApproximatelyEqual(to: b))
    }

    @Test func testIsApproximatelyEqualWithTolerance() {
        let a = Angle2D(radians: 1.0)
        let b = Angle2D(radians: 1.0 + 1e-10)
        #expect(a.isApproximatelyEqual(to: b, tolerance: 1e-8))
    }

    @Test func testComparableRadiansOnly() {
        #expect(Angle2D(degrees: 90) < Angle2D(degrees: 180))
        #expect(Angle2D(radians: .pi) < Angle2D(radians: 2 * .pi))
    }

    // MARK: - Private math functions (validated via public API surface)
    // These functions are used internally by the library and validated
    // by comparing results against Foundation's reference implementations.

    @Test func testDegreesToRadiansRoundTrip() {
        for deg in stride(from: -360.0, through: 360.0, by: 45.0) {
            let angle = Angle2D(degrees: deg)
            #expect(abs(angle.degrees - deg) < 1e-10, "Round-trip failed for \(deg)°")
        }
    }

    @Test func testRadiansToDegreesKnownValues() {
        #expect(Angle2D(radians: 0).degrees == 0)
        #expect(abs(Angle2D(radians: .pi / 2).degrees - 90.0) < 1e-10)
        #expect(abs(Angle2D(radians: .pi).degrees - 180.0) < 1e-10)
        #expect(abs(Angle2D(radians: 2 * .pi).degrees - 360.0) < 1e-10)
        #expect(abs(Angle2D(radians: -.pi / 2).degrees - (-90.0)) < 1e-10)
    }

    @Test func testQuaternionFromAngleAxisUsesCorrectTrig() {
        // Quaternion(angle:axis:) calls Foundation.sin/cos with the angle/2.
        // Validate that a 90° rotation around Y produces the expected quaternion components.
        let q = Quaternion3D(angle: Angle2D(degrees: 90), axis: Vector3D(x: 0, y: 1, z: 0))
        let expected = Foundation.sin(Double.pi / 4)  // sin(45°)
        #expect(abs(q.y - expected) < 1e-10)
        #expect(abs(q.w - Foundation.cos(Double.pi / 4)) < 1e-10)
    }

    @Test func testQuaternionFromEulerAnglesXYZ() {
        // Euler(45°, 0°, 0°) in xyz order via Rotation3D which uses half-angle:
        // hx = 22.5°, q.x ≈ sin(22.5°), q.w ≈ cos(22.5°)
        let euler = EulerAngles(x: .init(degrees: 45), y: .init(degrees: 0), z: .init(degrees: 0), order: .xyz)
        let r = Rotation3D(eulerAngles: euler)
        let q = r.quaternion
        let halfRad = Double.pi / 8  // 22.5° in radians
        #expect(abs(q.x - Foundation.sin(halfRad)) < 1e-10)
        #expect(abs(q.w - Foundation.cos(halfRad)) < 1e-10)
        #expect(abs(q.y) < 1e-10)
        #expect(abs(q.z) < 1e-10)
    }

    @Test func testAngleAdditionIdentity() {
        let zero = Angle2D.zero
        let angle = Angle2D(degrees: 45)
        #expect((zero + angle).radians == angle.radians)
        #expect((angle + zero).radians == angle.radians)
    }

    @Test func testAngleNegation() {
        let angle = Angle2D(degrees: 90)
        let negated = Angle2D.zero - angle
        #expect(negated.degrees == -90.0)
    }
}