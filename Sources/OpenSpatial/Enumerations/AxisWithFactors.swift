
// AxisWithFactors.swift
// This source file is part of the OpenSpatial open source project
//
// Copyright (c) 2026 Helbert Gomes. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation

/// The axis of a shear transform.
public enum AxisWithFactors {

    /// The shear is on the _x_ axis using the _y_ and _z_ shear factors.
    case xAxis(yShearFactor: Double, zShearFactor: Double)

    /// The shear is on the _y_ axis using the _x_ and _z_ shear factors.
    case yAxis(xShearFactor: Double, zShearFactor: Double)

    /// The shear is on the _z_ axis using the _x_ and _y_ shear factors.
    case zAxis(xShearFactor: Double, yShearFactor: Double)
}
