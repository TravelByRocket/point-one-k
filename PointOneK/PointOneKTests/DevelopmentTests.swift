//
//  DevelopmentTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
@testable import PointOneK
import XCTest

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationsWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 25, "There should be 25 sample items.")
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "deleteAll() should leave 0 projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "deleteAll() should leave 0 items.")
    }

    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "The example project should be closed.")
    }
}
