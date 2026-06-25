# Changelog

All notable changes to OpenSpatial will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.1.0] - 2026-06-24

### Added

- Initial implementation of OpenSpatial framework
- Core 2D and 3D mathematical primitives:
  - Point3D, Vector3D, Size3D, Rect3D
  - Ray3D, Pose3D, ScaledPose3D
  - Rotation3D, Quaternion3D, EulerAngles
  - SphericalCoordinates3D
- Transform system:
  - AffineTransform3D
  - ProjectiveTransform3D
- Coordinate space abstractions:
  - CoordinateSpace3D
  - CoordinateSpaceValue3D
  - WorldReferenceCoordinateSpace
- Protocol-based architecture:
  - Primitive3D
  - Rotatable3D
  - Translatable3D
  - Scalable3D
  - Shearable3D
  - Clampable3D
  - Volumetric
- Full unit test suite (Swift Testing)
- Cross-platform CI pipelines (macOS, Linux, Windows)
- Codecov integration for coverage tracking
- DocC documentation generation and GitHub Pages deployment
- Swift Package Index configuration

### Notes

- This is the first public release of OpenSpatial.
- API is considered unstable during the 0.x series.
- Future releases may introduce breaking changes as the API stabilizes.