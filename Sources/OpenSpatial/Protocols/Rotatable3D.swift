
// Rotatable3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A set of methods that defines the interface to rotate Spatial entities.
public protocol Rotatable3D {

    /// Rotates the entity by a quaternion.
    ///
    /// - Parameter quaternion: The quaternion to apply.
    mutating func rotate(by quaternion: Quaternion3D)

    /// Returns the entity that results from applying the specified quaternion.
    ///
    /// - Parameter quaternion: The quaternion to apply.
    /// - Returns: A new rotated entity.
    func rotated(by quaternion: Quaternion3D) -> Self

    /// Rotates the entity by a rotation.
    ///
    /// - Parameter rotation: The rotation to apply.
    mutating func rotate(by rotation: Rotation3D)

    /// Returns the entity that results from applying the specified rotation.
    ///
    /// - Parameter rotation: The rotation to apply.
    /// - Returns: A new rotated entity.
    func rotated(by rotation: Rotation3D) -> Self
}

extension Rotatable3D {

    // MARK: - Instance methods

    /// Rotates the entity by a quaternion.
    ///
    /// - Parameter quaternion: The quaternion to apply.
    @inline(__always)
    public mutating func rotate(by quaternion: Quaternion3D) {
        self = rotated(by: quaternion)
    }

    /// Rotates the entity by a rotation.
    ///
    /// - Parameter rotation: The rotation to apply.
    @inline(__always)
    public mutating func rotate(by rotation: Rotation3D) {
        self = rotated(by: rotation)
    }

    /// Returns the entity that results from applying the specified rotation.
    ///
    /// - Parameter rotation: The rotation to apply.
    /// - Returns: A new rotated entity.
    @inline(__always)
    public func rotated(by rotation: Rotation3D) -> Self {
        rotated(by: rotation.quaternion)
    }
}
