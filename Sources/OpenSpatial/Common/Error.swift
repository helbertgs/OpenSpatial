
// Error.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

public enum Error: Swift.Error {
    case outOfRage
    case noAncestorSpace
}

extension Error {
    public var localizedDescription: String {
        "Index out of range. Valid indices are 0, 1, and 2."
    }
}
