//
//  DataController.swift
//  PointOneK
//
//  Created by Bryan Costanza on 18 Sep 2021.
//

import CoreData
import CoreSpotlight
import SwiftUI
import StoreKit

/// An environment singleton responsinble for managing out Core Data stack, including handling saving, counting fetch
/// requests, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to stare all our data
    let container: NSPersistentCloudKitContainer

    let defaults: UserDefaults

    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }

    var dateAskedForReview: Date? {
        get {
            defaults.object(forKey: "dateAskedForReview") as? Date
        }
        set {
            defaults.set(newValue, forKey: "dateAskedForReview")
        }
    }

    /// Initializes a data controler, either in memory (for temporary use such as testing and previewing), or on
    /// permanent storage (for us in regular app runs).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary storage or not
    /// - Paramater defaults: The UserDefaults suite where user data should be stored
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        self.defaults = defaults

        // For testing and previewing purposes, we create a temporary, in-memory databse by writing to /dev/null/ so
        // our data is destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
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

        // PROJECTS
        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.closed = Bool.random()
            project.detail = "Nothin in particular \(Int16.random(in: 1000...9999 ) )"

            // QUALITIES
            for k in 1...5 {
                let quality = Quality(context: viewContext)
                quality.title = "Quality \(k)"
                quality.note = "Description \(Int.random(in: 1000...9999))"
                quality.project = project
            }

            // ITEMS
            for j in 1...5 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.project = project

                // QUALITIES <-> SCORES
                let qualities = project.qualities?.allObjects as? [Quality] ?? []
                for quality in qualities {
                    let score = Score(context: viewContext)
                    score.item = item
                    score.quality = quality
                    score.value = Int16.random(in: 1...4)
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

    func delete(_ object: Project) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])

        container.viewContext.delete(object)
    }

    func delete(_ object: Item) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])

        container.viewContext.delete(object)
    }

    func delete(_ object: Quality) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let types = [Project.self, Item.self, Quality.self, Score.self]

        for type in types {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = type.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? container.viewContext.execute(batchDeleteRequest)
        }
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func update(_ item: Item) {
        let itemID = item.objectID.uriRepresentation().absoluteString
        let projectID = item.project?.objectID.uriRepresentation().absoluteString

        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.itemTitle
        attributeSet.contentDescription = item.itemNote

        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemID,
            domainIdentifier: projectID,
            attributeSet: attributeSet)

        CSSearchableIndex.default().indexSearchableItems([searchableItem])

        save()
    }

    func item(with uniqueIdentifier: String) -> Item? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }

        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: id) as? Item
    }

    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }
        let hasNeverAsked = dateAskedForReview == nil
        let intervalSinceAsked = dateAskedForReview?.timeIntervalSinceNow ?? 0
        guard hasNeverAsked || intervalSinceAsked > 86_400 * 40 else { return }

        let allscenes = UIApplication.shared.connectedScenes
        let scene = allscenes.first // { $0.activationState == .foregroundActive } // works iff no filtering

        if let windowScene = scene as? UIWindowScene {
            dateAskedForReview = Date()
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
