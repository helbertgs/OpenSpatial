
// ProjectiveTransformable3D.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

public protocol ProjectiveTransformable3D {

    /// Returns a transformed copy of the value.
    /// - Parameter transform: A transform the function applies to the value.
    func applying(_ transform: ProjectiveTransform3D) -> Self
}
