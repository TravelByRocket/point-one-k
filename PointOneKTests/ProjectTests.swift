//
//  ProjectTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
import SwiftData
import Testing

@testable import PointOneK

@MainActor
final class ProjectTests: BaseTestCase {
    @Test func testCascadeDelete() throws {
        let project = ProjectV2()
        let item = ItemV2()
        let quality = QualityV2()
        let score = ScoreV2()

        score.item = item
        score.quality = quality
        item.project = project
        quality.project = project

        context.insert(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ScoreV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<QualityV2>())) == 1)

        context.delete(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 0)
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 0)
        #expect((try? context.fetchCount(FetchDescriptor<ScoreV2>())) == 0)
        #expect((try? context.fetchCount(FetchDescriptor<QualityV2>())) == 0)
    }

    @Test func testAddItem() {
        let project = ProjectV2()
        project.addItem(titled: "Item Title")
        context.insert(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 1)
    }

    @Test func testAddQuality() {
        let project = ProjectV2()
        project.addQuality()
        context.insert(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<QualityV2>())) == 1)
    }

    @Test func test_givenProject_whenAddItemThenQuality_thenScoreCreated() {
        let project = ProjectV2()
        project.addItem()
        project.addQuality()
        context.insert(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ScoreV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<QualityV2>())) == 1)
    }

    @Test func test_givenProject_whenAddQualityThenItem_thenScoreCreated() {
        let project = ProjectV2()
        project.addQuality()
        project.addItem()
        context.insert(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ScoreV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<QualityV2>())) == 1)
    }
}
