//
//  PerformanceTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 6 Mar 2022.
//

import XCTest
@testable import PointOneK

class PerformanceTests: BaseTestCase {

    func testSampleCreation() throws {
        measure {
            for _ in 0..<100 {
                try? dataController.createSampleData()
            }
        }
    }
}
