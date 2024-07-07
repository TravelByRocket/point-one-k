//
//  DevelopmentTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
@testable import PointOneK
import Testing

struct DevelopmentTests {
    @MainActor @Test func testSampleDataCreationsWorks() throws {
        let btc = BaseTestCase()
        try btc.dataController.createSampleData()

        #expect(btc.dataController.count(for: ProjectOld.fetchRequest()) == 5, "There should be 5 sample projects.")
        #expect(btc.dataController.count(for: ItemOld.fetchRequest()) == 25, "There should be 25 sample items.")
    }

    @MainActor @Test func testDeleteAllClearsEverything() throws {
        let btc = BaseTestCase()
        try btc.dataController.createSampleData()
        btc.dataController.deleteAll()

        #expect(btc.dataController.count(for: ProjectOld.fetchRequest()) == 0, "deleteAll() should leave 0 projects.")
        #expect(btc.dataController.count(for: ItemOld.fetchRequest()) == 0, "deleteAll() should leave 0 items.")
    }

    @Test func testExampleProjectIsClosed() {
        let project = ProjectOld.example
        #expect(project.closed, "The example project should be closed.")
    }
}
