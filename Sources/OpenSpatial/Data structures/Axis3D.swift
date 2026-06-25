
// Axis3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

/// Constants that describe an axis.
@frozen
public struct Axis3D: Codable, Copyable, Equatable, Hashable, OptionSet, Sendable {

    // MARK: - Constants

    /// The operation is along the x-axis.
    public static let x = Axis3D(rawValue: 1)

    /// The operation is along the y-axis.
    public static let y = Axis3D(rawValue: 2)

    /// The operation is along the z-axis.
    public static let z = Axis3D(rawValue: 4)

    /// All three axes combined.
    public static let all: Axis3D = [.x, .y, .z]

    // MARK: - Inspecting the axis

    /// The raw value of the axis.
    public var rawValue: Int

    // MARK: - Creating an axis

    /// Creates a new axis with the given raw value.
    ///
    /// - Parameter rawValue: The raw value of the axis.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
