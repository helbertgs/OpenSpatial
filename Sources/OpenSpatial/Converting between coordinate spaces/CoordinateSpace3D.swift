
// CoordinateSpace3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// A type that represents a coordinate space which you can use to convert
/// values to and from other coordinate spaces.
public protocol CoordinateSpace3D: Sendable {

    associatedtype AncestorCoordinateSpace: CoordinateSpace3D

    /// An ancestor coordinate space.
    ///
    /// A `nil` ancestor indicates this space is a root.
    var ancestorSpace: Self.AncestorCoordinateSpace? { get }

    /// This space's transform relative to its ancestor.
    func ancestorFromSpaceTransform() throws -> ProjectiveTransform3D

    /// Returns a transform of this coordinate space from the target
    /// coordinate space.
    ///
    /// - Parameters:
    ///   - targetCoordinateSpace: Another coordinate space.
    ///
    /// This method is dedicated for converting between coordinate spaces
    /// of the same type. Implementations may be more efficient than the
    /// general purpose convert functions, but results should be the same.
    /// A default implementation is provided which uses root level conversions.
    func transform(from targetCoordinateSpace: Self) throws -> ProjectiveTransform3D

    /// Returns the accumulated transform from this space up to the root,
    /// expressed as the chain selfFromRoot = t1 * t2 * ... * tN where t1 is
    /// the space's own ancestorFromSpaceTransform and tN is the root's.
    func _transformToRoot() throws -> ProjectiveTransform3D
}

extension CoordinateSpace3D {

    /// Default implementation: multiply this space's ancestorFromSpaceTransform
    /// by the ancestor's chain to root.
    public func _transformToRoot() throws -> ProjectiveTransform3D {
        guard ancestorSpace != nil else {
            return .identity
        }
        let t = try ancestorFromSpaceTransform()
        let parentChain = try ancestorSpace!._transformToRoot()
        return t * parentChain
    }
}

extension CoordinateSpace3D {

    /// Returns a modified version of the coordinate space.
    ///
    /// - Parameter baseFromMapTransform: A closure which takes in the base coordinate space
    ///  and returns a transform that represents the modification to that space.
    public func transformSpace(
        _ baseFromMapTransform: @escaping @Sendable (Self) -> ProjectiveTransform3D
    ) -> some CoordinateSpace3D {
        _MappedCoordinateSpace(base: self, transform: baseFromMapTransform)
    }
}

extension CoordinateSpace3D {

    /// Returns a transform of this coordinate space from the target coordinate space.
    ///
    /// Traverses both spaces to their respective roots and returns
    /// `selfFromRoot.inverse * targetFromRoot`.
    ///
    /// - Parameter target: Another coordinate space.
    public func transform<Space>(from target: Space) throws -> ProjectiveTransform3D
    where Space: CoordinateSpace3D {
        let selfFromRoot = try _transformToRoot()
        let targetFromRoot = try target._transformToRoot()
        guard let selfFromRootInverse = selfFromRoot.inverse else {
            throw Error.noAncestorSpace
        }
        return selfFromRootInverse * targetFromRoot
    }

    /// Converts a value from this coordinate space to another.
    ///
    /// - Parameters:
    ///   - value: The value to convert, expressed in this coordinate space.
    ///   - targetCoordinateSpace: The destination coordinate space.
    /// - Returns: The value converted to the target coordinate space.
    public func convert<T, Space>(value: T, to targetCoordinateSpace: Space) throws -> T
    where T: ProjectiveTransformable3D, Space: CoordinateSpace3D {
        let t = try transform(from: targetCoordinateSpace)
        return value.applying(t)
    }

    /// Converts a value from a source coordinate space to this one.
    ///
    /// - Parameters:
    ///   - value: The value to convert, expressed in the source coordinate space.
    ///   - sourceCoordinateSpace: The source coordinate space.
    /// - Returns: The value converted to this coordinate space.
    public func convert<T, Space>(value: T, from sourceCoordinateSpace: Space) throws -> T
    where T: ProjectiveTransformable3D, Space: CoordinateSpace3D {
        let t = try sourceCoordinateSpace.transform(from: self)
        return value.applying(t)
    }

    /// Converts a value from this coordinate space to another of the same type.
    ///
    /// - Parameters:
    ///   - value: The value to convert, expressed in this coordinate space.
    ///   - targetCoordinateSpace: The destination coordinate space.
    /// - Returns: The value converted to the target coordinate space.
    public func convert<T>(value: T, to targetCoordinateSpace: Self) throws -> T
    where T: ProjectiveTransformable3D {
        let t = try transform(from: targetCoordinateSpace)
        return value.applying(t)
    }

    /// Converts a value from a source coordinate space of the same type to this one.
    ///
    /// - Parameters:
    ///   - value: The value to convert, expressed in the source coordinate space.
    ///   - sourceCoordinateSpace: The source coordinate space.
    /// - Returns: The value converted to this coordinate space.
    public func convert<T>(value: T, from sourceCoordinateSpace: Self) throws -> T
    where T: ProjectiveTransformable3D {
        let t = try sourceCoordinateSpace.transform(from: self)
        return value.applying(t)
    }
}

extension CoordinateSpace3D {

    /// Returns a transform of this coordinate space from the target coordinate space
    /// when both spaces are of the same type.
    ///
    /// Delegates to the generic `transform(from:)` overload.
    public func transform(from target: Self) throws -> ProjectiveTransform3D {
        let selfFromRoot = try _transformToRoot()
        let targetFromRoot = try target._transformToRoot()
        guard let selfFromRootInverse = selfFromRoot.inverse else {
            throw Error.noAncestorSpace
        }
        return selfFromRootInverse * targetFromRoot
    }
}

/// An internal wrapper that applies a transform closure on top of a base coordinate space.
struct _MappedCoordinateSpace<Base: CoordinateSpace3D>: CoordinateSpace3D {

    typealias AncestorCoordinateSpace = Base

    let base: Base
    let transform: @Sendable (Base) -> ProjectiveTransform3D

    var ancestorSpace: Base? { base }

    func ancestorFromSpaceTransform() throws -> ProjectiveTransform3D {
        transform(base)
    }

    func transform(from target: _MappedCoordinateSpace<Base>) throws -> ProjectiveTransform3D {
        let selfFromRoot = try _transformToRoot()
        let targetFromRoot = try target._transformToRoot()
        guard let selfFromRootInverse = selfFromRoot.inverse else {
            throw Error.noAncestorSpace
        }
        return selfFromRootInverse * targetFromRoot
    }
}

extension Never: CoordinateSpace3D {

    public typealias AncestorCoordinateSpace = Never

    public var ancestorSpace: Never? { nil }

    public func ancestorFromSpaceTransform() throws -> ProjectiveTransform3D {
        fatalError("Never cannot be instantiated")
    }

    public func transform(from targetCoordinateSpace: Never) throws -> ProjectiveTransform3D {
        fatalError("Never cannot be instantiated")
    }

    public func _transformToRoot() throws -> ProjectiveTransform3D {
        fatalError("Never cannot be instantiated")
    }
}
