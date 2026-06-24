
// WorldReferenceCoordinateSpace.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A coordinate space that represents a world reference point.
public struct WorldReferenceCoordinateSpace: CoordinateSpace3D, Equatable, Hashable, Sendable {

    public typealias AncestorCoordinateSpace = Never

    public init() {}

    /// An ancestor coordinate space.
    ///
    /// Always `nil` — world reference is the root space with no ancestor.
    public var ancestorSpace: Never? {
        nil
    }

    /// This space's transform relative to its ancestor.
    ///
    /// Always throws because the world reference space has no ancestor.
    public func ancestorFromSpaceTransform() throws -> ProjectiveTransform3D {
        throw Error.noAncestorSpace
    }

    /// Returns the transform from this space to itself, which is always the identity.
    public func transform(from target: WorldReferenceCoordinateSpace) throws
        -> ProjectiveTransform3D
    {
        .identity
    }
}

extension CoordinateSpace3D where Self == WorldReferenceCoordinateSpace {

    /// A coordinate space that represents the world root for all other coordinate spaces.
    public static var worldReference: WorldReferenceCoordinateSpace {
        WorldReferenceCoordinateSpace()
    }
}
