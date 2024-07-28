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

    func test_GivenNoProject_WhenProjectAdded_ThenOneProjectShows() {
        createNewProject(titled: "New Project")
        let projectCount = app.collectionViews.cells.count
        XCTAssert(projectCount == 1)
    }

    func test_givenNoItem_whenItemAdded_thenOneItemShows() {
        createNewProject(titled: "New Project")
        app.buttons["New Project"].tap()
        createNewItem(titled: "New Item")
        XCTAssert(app.staticTexts["New Item"].exists)
    }

    func test_givenNoQuality_whenQualityAdded_thenOneQualityShows() {
        createNewProject(titled: "New Project")
        app.buttons["New Project"].tap()
        createNewQuality(titled: "New Quality")
        XCTAssert(app.staticTexts["New Quality"].exists)
    }

    func test_givenProject_whenProjectTitleChanged_thenProjectRowUpdates() {
        let projectTitle = "New Project"
        createNewProject(titled: projectTitle)
        app.buttons["New Project"].tap()
        app.textFields["Project Title"].tap()
        app.typeText(" Updated")
        app.buttons["Open Projects"].tap()
        XCTAssert(app.staticTexts["New Project Updated"].exists)
    }

    func test_givenProject_whenItemAdded_thenProjectRowUpdates() {
        createNewProject(titled: "New Project")
        app.buttons["New Project"].tap()
        createNewItem(titled: "New Item")
        app.buttons["Open Projects"].tap()
        XCTAssert(app.staticTexts["0 Qualities, 1 Items"].exists)
    }

    func test_givenProject_whenQualityAdded_thenProjectRowUpdates() {
        createNewProject(titled: "New Project")
        app.buttons["New Project"].tap()
        createNewQuality(titled: "New Quality")
        app.buttons["Open Projects"].tap()
        XCTAssert(app.staticTexts["1 Qualities, 0 Items"].exists)
    }

    func test_givenProjectWithItem_whenQualityAdded_thenItemRowHasPill() {
        createNewProject(titled: "New Project")
        app.buttons["New Project"].tap()
        createNewItem(titled: "New Item")
        createNewQuality(titled: "New Quality")
        XCTAssert(app.staticTexts["0n"].exists)
    }

    func test_givenTwoItems_whenScoresChange_thenItemsAreSortedByScore() throws {
        createNewProject(titled: "New Project")
        app.buttons["New Project"].tap()
        createNewItem(titled: "AAA")
        createNewItem(titled: "ZZZ")
        createNewQuality(titled: "New Quality")
        app.buttons["ItemRow ZZZ"].tap()
        app.buttons["Level 4"].tap()
        app.buttons["Edit Project"].tap()
        let itemElements = app.staticTexts.allElementsBoundByIndex
        let zzzIndex = try XCTUnwrap(itemElements.firstIndex { $0.label == "ItemRow ZZZ" })
        let aaaIndex = try XCTUnwrap(itemElements.firstIndex { $0.label == "ItemRow AAA" })
        XCTAssert(zzzIndex < aaaIndex)
    }

    // Check Sort by Name Updates with New Item
    // Check Sort by Score Updates with Changes Scores
    // Check background bar updates with score change

    // MARK: Helpers

    func createNewProject(titled title: String) {
        app.textFields["Enter New Project Title"].tap()
        app.typeText(title)
        app.buttons["Add Project"].tap()
    }

    func createNewItem(titled title: String) {
        app.textFields["Add New Item"].tap()
        app.typeText(title)
        app.buttons["Add New Item"].tap()
    }

    func createNewQuality(titled title: String) {
        app.textFields["Add New Quality"].tap()
        app.typeText(title)
        app.buttons["Add New Quality"].tap()
    }
}
