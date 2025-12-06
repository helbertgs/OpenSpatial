import Testing
@testable import OpenSpatial

// struct Rotation3DTests {

//     // MARK: - Initialization tests

//     @Test func testInitialization() {
//         let rotation = Rotation3D()
//         #expect(rotation.angle == 0)
//         #expect(rotation.axis == .zero)
//         #expect(rotation.quaternion == .zero)
//     }

//     @Test func testInitializationUsingDefaultParams() {
//         let angle = Angle2D(radians: Double.pi / 2)
//         let rotation = Rotation3D(eulerAngles: EulerAngles(x: angle, y: angle, z: angle, order: .xyz))

//         #expect(rotation.angle.radians == 1.5707963267948966)
//         #expect(rotation.axis == .init(x: 6.503535905665379e-17, y: 1.0, z: 6.503535905665379e-17))
//         #expect(rotation.quaternion == .init(x: 4.598694340586186e-17, y: 0.7071067811865478, z: 4.598694340586186e-17, w: 0.7071067811865478))
//     }
// }