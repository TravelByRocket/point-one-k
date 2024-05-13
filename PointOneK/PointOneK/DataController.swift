//
//  DataController.swift
//  PointOneK
//
//  Created by Bryan Costanza on 18 Sep 2021.
//

import CoreData
import CoreSpotlight
import SwiftUI
import WidgetKit
import SwiftData

/// An environment singleton responsible for managing out Core Data stack, including handling saving, counting fetch
/// requests, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to stare all our data
    let container: NSPersistentCloudKitContainer

    let defaults: UserDefaults

    var dateAskedForReview: Date? {
        get {
            defaults.object(forKey: "dateAskedForReview") as? Date
        }
        set {
            defaults.set(newValue, forKey: "dateAskedForReview")
        }
    }

    var widgetProject: ProjectOld? {
        let projectURL = UserDefaults(suiteName: "group.co.synodic.PointOneK")?.url(forKey: "widgetProject")
        let projects = (try? container.viewContext.fetch(ProjectOld.fetchRequest())) ?? []
        return projects.first { projectURL == $0.objectID.uriRepresentation() }
    }

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing), or on
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
        } else {
            let groupID = "group.co.synodic.PointOneK"

            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
            }
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            self.container.viewContext.automaticallyMergesChangesFromParent = true

            #if DEBUG
                if CommandLine.arguments.contains("enable-testing") {
                    self.deleteAll()
                    UIView.setAnimationsEnabled(false)
                }
            #endif
        }
    }

    @MainActor
    static let preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview data: \(error.localizedDescription)")
        }

        return dataController
    }()

    @MainActor static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /// This creates example projects and items to make manual testing earlier
    /// - Throws: An `NSError` sent from calling `save()` on the `NSManagedObjectContext`.
    @MainActor
    func createSampleData() throws {
        let viewContext = container.viewContext

        // PROJECTS
        for projectCounter in 1 ... 5 {
            let project = ProjectOld(context: viewContext)
            project.title = "Project \(projectCounter)"
            project.items = []
            project.closed = Bool.random()
            project.detail = "Nothin in particular \(Int16.random(in: 1_000 ... 9_999))"

            // QUALITIES
            for qualityCounter in 1 ... 5 {
                let quality = QualityOld(context: viewContext)
                quality.title = "Quality \(qualityCounter)"
                quality.note = "Description \(Int.random(in: 1_000 ... 9_999))"
                quality.project = project
            }

            // ITEMS
            for itemCounter in 1 ... 5 {
                let item = ItemOld(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.project = project

                // QUALITIES <-> SCORES
                let qualities = project.qualities?.allObjects as? [QualityOld] ?? []
                for quality in qualities {
                    let score = ScoreOld(context: viewContext)
                    score.item = item
                    score.quality = quality
                    score.value = Int16.random(in: 1 ... 4)
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
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    func delete(_ object: ProjectOld) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])

        container.viewContext.delete(object)
    }

    func delete(_ object: ItemOld) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])

        container.viewContext.delete(object)
    }

    func delete(_ object: QualityOld) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let types = [ProjectOld.self, ItemOld.self, QualityOld.self, ScoreOld.self]

        for type in types {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = type.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? container.viewContext.execute(batchDeleteRequest)
        }
    }

    func count(for fetchRequest: NSFetchRequest<some Any>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func update(_ item: ItemOld) {
        let itemID = item.objectID.uriRepresentation().absoluteString
        let projectID = item.project?.objectID.uriRepresentation().absoluteString

        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.itemTitle
        attributeSet.contentDescription = item.itemNote

        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemID,
            domainIdentifier: projectID,
            attributeSet: attributeSet
        )

        CSSearchableIndex.default().indexSearchableItems([searchableItem])

        save()
    }

    func item(with uniqueIdentifier: String) -> ItemOld? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }

        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: id) as? ItemOld
    }

    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: Project2.self, Item2.self, Quality2.self, Score2.self,
                configurations: config
            )

//            for i in 1...9 {
//                let user = User(name: "Example User \(i)")
//                container.mainContext.insert(user)
//            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
