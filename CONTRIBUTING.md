# Contributing to OpenSpatial

Thank you for your interest in contributing! This document explains how to set up your environment, follow the project conventions, and submit a pull request.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Writing Tests](#writing-tests)
- [Documentation](#documentation)
- [Commit Messages](#commit-messages)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Reporting Issues](#reporting-issues)

---

## Code of Conduct

This project follows the [Swift open-source community standards](https://www.swift.org/code-of-conduct/). Be respectful, constructive, and welcoming to all contributors.

---

## Getting Started

### Prerequisites

- Swift 6.0 or later ([swift.org/download](https://www.swift.org/download/))
- Git

### Fork and clone

```bash
# Fork the repo on GitHub, then:
git clone https://github.com/<your-username>/OpenSpatial.git
cd OpenSpatial
```

### Build and test

```bash
swift build
swift test
```

All tests must pass before you open a pull request.

---

## Project Structure

```
OpenSpatial/
├── Sources/OpenSpatial/
│   ├── 2D primitives/          # Angle2D
│   ├── 3D primitives/          # Point3D, Pose3D, Ray3D, Rect3D, …
│   ├── Affine and projective transforms/
│   ├── Converting between coordinate spaces/
│   ├── Data structures/        # Axis3D, Vector3D
│   ├── Enumerations/
│   ├── Protocols/              # Primitive3D, Rotatable3D, Translatable3D, …
│   └── Structures/             # EulerAngles
├── Tests/OpenSpatialTests/     # Mirror of Sources structure
├── Package.swift               # Swift 6.3+
├── Package@swift-6.1.swift     # Swift 6.1 manifest
└── Package@swift-6.2.swift     # Swift 6.2 manifest
```

New types should be placed in the directory that matches their category, mirroring how Apple's Spatial framework organises its API surface.

---

## Development Workflow

1. Create a branch from `main`:
   ```bash
   git checkout -b feat/my-new-type
   ```
2. Make your changes.
3. Run the formatter (see [Code Style](#code-style)).
4. Run the full test suite.
5. Push and open a pull request.

---

## Code Style

The project enforces style via [swift-format](https://github.com/apple/swift-format). The configuration lives in [`.swift-format`](.swift-format). Key rules:

| Rule | Value |
|---|---|
| Indentation | 4 spaces |
| Line length | 100 characters |
| Doc comments | `///` triple-slash only (no `/* */` blocks) |
| Imports | Ordered alphabetically |
| Access level on extensions | Not allowed (`NoAccessLevelOnExtensionDeclaration`) |

### Formatting your changes

```bash
swift package plugin --allow-writing-to-package-directory format-source-code
```

> The CI pipeline treats warnings as errors (`-Xswiftc -warnings-as-errors`), so unformatted code will fail the build.

### General guidelines

- Prefer `@frozen` on value types that are unlikely to gain new stored properties.
- Mark all public API as `public` and give it a `///` documentation comment.
- Use `@inline(__always)` on small, performance-sensitive methods (arithmetic operators, simple getters).
- Add `Sendable` conformance to all new value types.
- Add `Codable`, `Hashable`, and `Equatable` where it makes sense for a mathematical primitive.

---

## Writing Tests

Tests live in `Tests/OpenSpatialTests/` and mirror the source structure. The project uses **Swift Testing** (`import Testing`).

### Checklist for new types

- [ ] Basic initialisation (`init()`, `init(x:y:z:)`, etc.)
- [ ] Identity / zero / infinity constants
- [ ] Arithmetic operators (`+`, `-`, `*`, `/`)
- [ ] `isApproximatelyEqual(to:tolerance:)` where applicable
- [ ] Protocol conformances (`Rotatable3D`, `Translatable3D`, `Scalable3D`, …)
- [ ] Edge cases: `NaN`, `infinity`, zero vectors

### Example test structure

```swift
import Testing
@testable import OpenSpatial

@Suite("Point3D")
struct Point3DTests {

    @Test("Distance between two points")
    func distance() {
        let a = Point3D(x: 0, y: 0, z: 0)
        let b = Point3D(x: 3, y: 4, z: 0)
        #expect(a.distance(to: b) == 5.0)
    }

    @Test("Approximate equality with tolerance")
    func approximateEquality() {
        let a = Point3D(x: 1.0, y: 2.0, z: 3.0)
        let b = Point3D(x: 1.0 + 1e-15, y: 2.0, z: 3.0)
        #expect(a.isApproximatelyEqual(to: b))
    }
}
```

Run tests with coverage locally:

```bash
swift test --enable-code-coverage
```

---

## Documentation

All `public` declarations must have a `///` documentation comment. Comments follow Apple's DocC conventions.

### Format

```swift
/// A short, single-line summary.
///
/// An optional longer description that explains the behaviour in more detail.
///
/// - Parameters:
///   - x: The x-coordinate.
///   - y: The y-coordinate.
/// - Returns: The resulting point.
/// - Complexity: O(1)
public func example(x: Double, y: Double) -> Point3D { … }
```

### Generating docs locally

```bash
swift package --disable-sandbox preview-documentation --target OpenSpatial
```

Or to build a static site:

```bash
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target OpenSpatial \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path OpenSpatial
```

---

## Commit Messages

The project follows [Conventional Commits](https://www.conventionalcommits.org/). Every commit message must start with a type prefix:

| Prefix | When to use |
|---|---|
| `feat:` | A new type, method, or feature |
| `fix:` | A bug fix |
| `docs:` | Documentation-only changes |
| `chore:` | Maintenance, formatting, tooling, dependency bumps |
| `test:` | Adding or fixing tests (no production code change) |
| `refactor:` | Code restructuring with no behaviour change |
| `perf:` | Performance improvements |

**Examples:**

```
feat: add ScaledPose3D and Ray3D
fix: correct quaternion multiplication in Rotation3D
docs: document Clampable3D protocol requirements
chore: update swift-format to latest version
test: add edge-case tests for Rect3D.intersects
```

Keep the subject line under 72 characters and written in the imperative mood ("add", "fix", "update", not "added" or "fixes").

---

## Submitting a Pull Request

1. Make sure the build passes with no warnings:
   ```bash
   swift build -Xswiftc -warnings-as-errors
   ```
2. Run the full test suite:
   ```bash
   swift test
   ```
3. Run the formatter:
   ```bash
   swift package plugin --allow-writing-to-package-directory format-source-code
   ```
4. Push your branch and open a PR against `main` on GitHub.
5. Fill in the PR description explaining *what* changed and *why*.
6. Wait for CI (GitHub Actions) to pass. Address any review feedback.

### PR guidelines

- Keep PRs focused — one feature or fix per PR.
- If the PR introduces a new public type, include tests and documentation.
- Reference any related issues with `Closes #<issue-number>` in the PR description.

---

## Reporting Issues

Please use [GitHub Issues](https://github.com/helbertgs/OpenSpatial/issues) to report bugs or request features. Include:

- Swift version (`swift --version`)
- Platform and OS version
- A minimal code sample that reproduces the problem
- Expected vs. actual behaviour
