//
//  DataController.swift
//  PointOneK
//
//  Created by Bryan Costanza on 18 Sep 2021.
//

import CoreData
import SwiftUI

/// An environment singleton responsinble for managing out Core Data stack, including handling saving, counting fetch
/// requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to stare all our data
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controler, either in memory (for temporary use such as testing and previewing), or on
    /// permanent storage (for us in regular app runs).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary storage or not
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing and previewing purposes, we create a temporary, in-memory databse by writing to /dev/null/ so
        // our data is destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview data: \(error.localizedDescription)")
        }

        return dataController
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /// This creates example projects and items to make manual testing earlier
    /// - Throws: An `NSError` sent from calling `save()` on the `NSMAnagedObjectContext`.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for i in 1...5 { // make 5 projects
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            project.detail = "Nothin in particular \(Int16.random(in: 1000...9999 ) )"

            for k in 1...5 { // make for qualities
                let quality = Quality(context: viewContext)
                quality.title = "Quality \(k)"
                quality.note = "Description \(Int.random(in: 1000...9999))"
                quality.project = project
            }

            for j in 1...5 { // make 5 items
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.priority = Int16.random(in: 1...3)
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project

                let qualities = project.qualities?.allObjects as? [Quality] ?? []
                for quality in qualities { // make a score for each quality
                    let score = Score(context: viewContext)
                    score.item = item
                    score.value = Int16.random(in: 1...4)
                    score.quality = quality
                }
            }
        }
        try viewContext.save()
    }

    /// Saves our Core Data context iff there are changes. This silently ignores any errors caused by saving, but this
    /// should be fine because our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let types = [Item.self, Project.self, Quality.self, Score.self]

        for type in types {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = type.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? container.viewContext.execute(batchDeleteRequest)
        }
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if they added a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "complete":
            // returns true if they added a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
            // an unknown award criterium; this should never happen
//            fatalError("Unknown award criterion \(award.criterion)")
            return false
        }
    }
}
