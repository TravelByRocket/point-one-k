//
//  PerformanceTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 6 Mar 2022.
//

@testable import PointOneK
import XCTest

class PerformanceTests: XCTestCase {
    @MainActor func testSampleCreation() throws {
        let btc = BaseTestCase()
        measure {
            for _ in 0 ..< 100 {
                try? btc.dataController.createSampleData()
            }
        }
    }
}
