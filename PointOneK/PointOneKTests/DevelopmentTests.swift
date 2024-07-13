//
//  DevelopmentTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
import SwiftData
import Testing

@testable import PointOneK

final class DevelopmentTests: BaseTestCase {
    @MainActor @Test func testSampleDataCreationsWorks() throws {
        try context.addSampleData()

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 3, "There should be 5 sample projects.")
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 9, "There should be 5 sample projects.")
    }

    @Test func testExampleProjectIsClosed() {
        let project = ProjectV2.example
        #expect(project.closed == true, "The example project should be closed.")
    }
}
