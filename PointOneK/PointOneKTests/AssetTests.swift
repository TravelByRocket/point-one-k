//
//  AssetTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

@testable import PointOneK
import Testing
import UIKit

struct AssetTests {
    @Test func testColorsExist() {
        for color in ProjectOld.colors {
            #expect(UIColor(named: color) != nil, "Failed to load color '\(color)' from asset catalog.")
        }
    }
}
