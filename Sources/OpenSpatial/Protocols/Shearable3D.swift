
// Shearable3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A set of methods that defines the interface for Spatial entities that can shear.
public protocol Shearable3D {

    /// Returns a sheared entity.
    ///
    /// - Parameter shear: The axis and shear factors.
    /// - Returns The sheared entity.
    func sheared(_ shear: AxisWithFactors) -> Self

    /// Shears the entity.
    ///
    /// - Parameter shear: The axis and shear factors.
    mutating func shear(_ shear: AxisWithFactors)
}

extension Shearable3D {

    /// Shears the entity.
    ///
    /// - Parameter shear: The axis and shear factors.
    public mutating func shear(_ shear: AxisWithFactors) {
        self = sheared(shear)
    }
}
