//
//  AssetTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import Testing
import UIKit

@testable import PointOneK

struct AssetTests {
    @Test func testColorsExist() {
        for color in ProjectV2.colors {
            #expect(UIColor(named: color) != nil, "Failed to load color '\(color)' from asset catalog.")
        }
    }
}
