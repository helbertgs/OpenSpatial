
// Clampable3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A set of methods that defines the interface for Spatial entities that can be clamped to a volume.
public protocol Clampable3D {

    /// Returns the entity with coordinates clamped to the specified rectangle.
    ///
    /// - Parameter rect: The rectangle that defines the clamp volume.
    /// - Returns An entity that's clamped to the specified rectangle.
    func clamped(to rect: Rect3D) -> Self

    /// Clamps the mutable entity to the specified rectangle.
    ///
    /// - Parameter rect: The rectangle that defines the clamp volume.
    mutating func clamp(to rect: Rect3D)
}

extension Clampable3D {

    /// Clamps the mutable entity to the specified rectangle.
    ///
    /// - Parameter rect: The rectangle that defines the clamp volume.
    @inlinable public mutating func clamp(to rect: Rect3D) {
        self = clamped(to: rect)
    }
}
