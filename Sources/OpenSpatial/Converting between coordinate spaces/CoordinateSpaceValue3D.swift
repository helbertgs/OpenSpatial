
// CoordinateSpaceValue3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// An opaque value which can be resolved to a concrete value
/// in a `CoordinateSpace3D`
public protocol CoordinateSpaceValue3D<Value> {

    associatedtype Value: ProjectiveTransformable3D

    /// Resolves the associated value in the given coordinate space.
    ///
    /// - Parameter space: A coordinate space the function resolves the value in.
    /// - Returns: A concrete value converted to the provided space.
    func resolve<Space>(in otherSpace: Space) throws -> Self.Value where Space: CoordinateSpace3D
}
