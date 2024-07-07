//
//  BaseTestCase.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
@testable import PointOneK

struct BaseTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    init() {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
