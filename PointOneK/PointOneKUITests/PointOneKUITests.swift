//
//  PointOneKUITests.swift
//  PointOneKUITests
//
//  Created by Bryan Costanza on 6 Mar 2022.
//

import XCTest

@MainActor
final class PointOneKUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchEnvironment["DISABLE_ANIMATIONS"] = "true"
        app.launch()
    }

    enum Titles {
        static let newProject = "New Project"
        static let newItem = "New Item"
        static let newQuality = "New Quality"
    }

    enum Buttons {
        static let addProject = "Add Project"
        static let addNewItem = "Add New Item"
        static let addNewQuality = "Add New Quality"
        static let delete = "Delete"
        static let level4 = "Level 4"

        static func itemRow(itemTitle: String) -> String { "ItemRow \(itemTitle)" }
        static func qualityRow(qualityTitle: String) -> String { "QualityRow \(qualityTitle)" }
    }

    enum Navigation {
        static let openProjects = "Open Projects"
        static let editProject = "Edit Project"
    }

    enum TextFields {
        static let enterNewProjectTitle = "Enter New Project Title"
        static let projectTitle = "Project Title"
        static let addNewItem = "Add New Item"
        static let addNewQuality = "Add New Quality"
    }

    enum Labels {
        static let oneItemNoQualities = "0 Qualities, 1 Items"
        static let oneQualityNoItems = "1 Qualities, 0 Items"
        static let itemPillIndicator = "0n"
    }

    func test_GivenNoProject_WhenProjectAdded_ThenOneProjectShows() {
        createProject(titled: Titles.newProject)
        let projectCount = app.collectionViews.cells.count
        XCTAssert(projectCount == 1)
    }

    func test_givenNoItem_whenItemAdded_thenOneItemShows() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: Titles.newItem)
        XCTAssert(app.staticTexts[Titles.newItem].exists)
    }

    func test_givenNoQuality_whenQualityAdded_thenOneQualityShows() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createQuality(titled: Titles.newQuality)
        XCTAssert(app.staticTexts[Titles.newQuality].exists)
    }

    func test_givenProject_whenProjectTitleChanged_thenProjectRowUpdates() {
        let projectTitle = Titles.newProject
        createProject(titled: projectTitle)
        app.buttons[Titles.newProject].tap()
        app.textFields[TextFields.projectTitle].tap()
        let suffix = " Updated"
        app.typeText(suffix)
        app.buttons[Navigation.openProjects].tap()
        XCTAssert(app.staticTexts[Titles.newProject + suffix].exists)
    }

    func test_givenProject_whenItemAdded_thenProjectRowUpdates() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: Titles.newItem)
        app.buttons[Navigation.openProjects].tap()
        XCTAssert(app.staticTexts[Labels.oneItemNoQualities].exists)
    }

    func test_givenProject_whenQualityAdded_thenProjectRowUpdates() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createQuality(titled: Titles.newQuality)
        app.buttons[Navigation.openProjects].tap()
        XCTAssert(app.staticTexts[Labels.oneQualityNoItems].exists)
    }

    func test_givenProjectWithItem_whenQualityAdded_thenItemRowHasPill() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: Titles.newItem)
        createQuality(titled: Titles.newQuality)
        XCTAssert(app.staticTexts[Labels.itemPillIndicator].exists)
    }

    func test_givenTwoItems_whenScoresChange_thenItemsAreSortedByScore() throws {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        let itemTitleA = "AAA"
        let itemTitleZ = "ZZZ"
        createItem(titled: itemTitleA)
        createItem(titled: itemTitleZ)
        createQuality(titled: Titles.newQuality)
        app.buttons[Buttons.itemRow(itemTitle: itemTitleZ)].tap()
        app.buttons[Buttons.level4].tap()
        app.buttons[Navigation.editProject].tap()
        let itemElements = app.staticTexts.allElementsBoundByIndex
        let zzzIndex = try XCTUnwrap(itemElements.firstIndex { $0.label == itemTitleZ })
        let aaaIndex = try XCTUnwrap(itemElements.firstIndex { $0.label == itemTitleA })
        XCTAssert(zzzIndex < aaaIndex)
    }

    func test_givenOneItemAndOneQuality_whenItemDeletedAndCreated_thenOneItemRow() {
        // Delete followed by add to also ensure original item doesn't reappear due to view or persistence issue
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: Titles.newItem)
        createQuality(titled: Titles.newQuality)
        app.buttons[Buttons.itemRow(itemTitle: Titles.newItem)].swipeLeft()
        app.buttons[Buttons.delete].tap()
        createItem(titled: Titles.newItem + "2")
        let itemElements = app.staticTexts.allElementsBoundByIndex
        let itemRowCount = itemElements.filter { $0.label.contains(Titles.newItem) }.count
        XCTAssert(itemRowCount == 1)
    }

    func test_givenOneItemAndOneQuality_whenQualityDeletedAndCreated_thenOneQualityRow() {
        // Delete followed by add to also ensure original item doesn't reappear due to view or persistence issue
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: Titles.newItem)
        createQuality(titled: Titles.newQuality)
        app.buttons[Buttons.qualityRow(qualityTitle: Titles.newQuality)].swipeLeft()
        app.buttons[Buttons.delete].tap()
        createQuality(titled: Titles.newQuality + "2")
        let qualityElements = app.staticTexts.allElementsBoundByIndex
        let qualityRowCount = qualityElements.filter { $0.label.contains(Titles.newQuality) }.count
        XCTAssert(qualityRowCount == 1)
    }

    // Check background bar updates with score change

    // MARK: Helpers

    func createProject(titled title: String) {
        app.textFields[TextFields.enterNewProjectTitle].tap()
        app.typeText(title)
        app.buttons[Buttons.addProject].tap()
    }

    func createItem(titled title: String) {
        app.textFields[TextFields.addNewItem].tap()
        app.typeText(title)
        app.buttons[Buttons.addNewItem].tap()
    }

    func createQuality(titled title: String) {
        app.textFields[TextFields.addNewQuality].tap()
        app.typeText(title)
        app.buttons[Buttons.addNewQuality].tap()
    }
}
