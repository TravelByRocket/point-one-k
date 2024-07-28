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
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    enum Titles {
        static let newProject = "New Project"
        static let newItem = "New Item"
        static let newQuality = "New Quality"
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
        app.textFields["Project Title"].tap()
        app.typeText(" Updated")
        app.buttons["Open Projects"].tap()
        XCTAssert(app.staticTexts["New Project Updated"].exists)
    }

    func test_givenProject_whenItemAdded_thenProjectRowUpdates() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: Titles.newItem)
        app.buttons["Open Projects"].tap()
        XCTAssert(app.staticTexts["0 Qualities, 1 Items"].exists)
    }

    func test_givenProject_whenQualityAdded_thenProjectRowUpdates() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createQuality(titled: Titles.newQuality)
        app.buttons["Open Projects"].tap()
        XCTAssert(app.staticTexts["1 Qualities, 0 Items"].exists)
    }

    func test_givenProjectWithItem_whenQualityAdded_thenItemRowHasPill() {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: Titles.newItem)
        createQuality(titled: Titles.newQuality)
        XCTAssert(app.staticTexts["0n"].exists)
    }

    func test_givenTwoItems_whenScoresChange_thenItemsAreSortedByScore() throws {
        createProject(titled: Titles.newProject)
        app.buttons[Titles.newProject].tap()
        createItem(titled: "AAA")
        createItem(titled: "ZZZ")
        createQuality(titled: Titles.newQuality)
        app.buttons["ItemRow ZZZ"].tap()
        app.buttons["Level 4"].tap()
        app.buttons["Edit Project"].tap()
        let itemElements = app.staticTexts.allElementsBoundByIndex
        let zzzIndex = try XCTUnwrap(itemElements.firstIndex { $0.label == "ZZZ" })
        let aaaIndex = try XCTUnwrap(itemElements.firstIndex { $0.label == "AAA" })
        XCTAssert(zzzIndex < aaaIndex)
    }

    // Check background bar updates with score change

    // MARK: Helpers

    func createProject(titled title: String) {
        app.textFields["Enter New Project Title"].tap()
        app.typeText(title)
        app.buttons["Add Project"].tap()
    }

    func createItem(titled title: String) {
        app.textFields["Add New Item"].tap()
        app.typeText(title)
        app.buttons["Add New Item"].tap()
    }

    func createQuality(titled title: String) {
        app.textFields["Add New Quality"].tap()
        app.typeText(title)
        app.buttons["Add New Quality"].tap()
    }
}
