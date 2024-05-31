//
//  BaseTestCase.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
import SwiftData

@testable import PointOneK
import SwiftData
import XCTest

class BaseTestCase {
    let dataController: DataController!
    let managedObjectContext: NSManagedObjectContext!

    let config: ModelConfiguration
    let container: ModelContainer

    @MainActor
    var context: ModelContext { container.mainContext }

    init() {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext

        config = ModelConfiguration(isStoredInMemoryOnly: true)

        container = try! ModelContainer( // swiftlint:disable:this force_try
            for: ProjectV2.self,
            configurations: config
        )
    }
}
