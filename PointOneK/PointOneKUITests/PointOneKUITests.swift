//
//  PointOneKUITests.swift
//  PointOneKUITests
//
//  Created by Bryan Costanza on 6 Mar 2022.
//

import XCTest

class PointOneKUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas4Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }

    func testOpenTabAddsItems() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...5 {
            app.buttons["Add Project"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) list row(s) initially")
        }
    }

    func testAddingItemInsertsRow() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an item")
    }

    func testEditingProjectUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project")

        app.buttons["Compose"].tap()

        app.textFields["Project name"].tap()
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.staticTexts["New Project 2"].exists, "Modified project name should be visible in list")
    }

    func testEditingItemUpdatesCorrectly() {
        // Go to Open projects and add one project and one item before the test.
        testAddingItemInsertsRow()

        app.buttons["New Item"].tap()
        app.textFields["New Item"].tap()
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.staticTexts["New Item 2"].exists, "Modified item name should be visible in list")
    }
}
