//
//  DataController.swift
//  PointOneK
//
//  Created by Bryan Costanza on 18 Sep 2021.
//

import CoreSpotlight
import SwiftData
import SwiftUI
import WidgetKit

/// An environment singleton responsible for managing out Core Data stack, including handling saving, counting fetch
/// requests, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to stare all our data
    let modelContainer: ModelContainer
    let modelContext: ModelContext

    let defaults: UserDefaults

    var dateAskedForReview: Date? {
        get {
            defaults.object(forKey: "dateAskedForReview") as? Date
        }
        set {
            defaults.set(newValue, forKey: "dateAskedForReview")
        }
    }

    @MainActor
    var widgetProject: Project? {
        let projectURL = UserDefaults(suiteName: "group.co.synodic.PointOneK")?.url(forKey: "widgetProject")
        let projects = (try? container.viewContext.fetch(ProjectOld.fetchRequest())) ?? []
        return projects.first { projectURL == $0.objectID.uriRepresentation() }
    }

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing), or on
    /// permanent storage (for us in regular app runs).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary storage or not
    /// - Parameter defaults: The UserDefaults suite where user data should be stored
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        let modelConfig = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        // swiftlint:disable:next force_try
        modelContainer = try! ModelContainer(for: Project.self, Item.self, Score.self, Quality.self, configurations: modelConfig)
        modelContext = ModelContext(modelContainer)

        self.defaults = defaults
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
                modelContainer.mainContext.insert(quality)
            }

            // ITEMS
            for itemCounter in 1 ... 5 {
                let item = ItemOld(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.project = project

                // QUALITIES <-> SCORES
                if let qualities = project.qualities {
                    for quality in qualities {
                        let score = Score()
                        score.item = item
                        score.quality = quality
                        score.value = Int16.random(in: 1 ... 4)
                    }
                }
                modelContainer.mainContext.insert(item)
            }
        }

        try modelContainer.mainContext.save()
    }

    /// Saves our Core Data context iff there are changes. This silently ignores any errors caused by saving, but this
    /// should be fine because our attributes are optional.
    @MainActor
    func save() {
        #warning("save might be redundant")
        if modelContainer.mainContext.hasChanges {
            try? modelContainer.mainContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    @MainActor
    func delete(_ object: Project) {
//        let id = object.objectID.uriRepresentation().absoluteString
//        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        #warning("spotlight not being used")
        modelContainer.mainContext.delete(object)
    }

    @MainActor
    func delete(_ object: Item) {
//        let id = object.objectID.uriRepresentation().absoluteString
//        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        #warning("spotlight not being used")
        modelContainer.mainContext.delete(object)
    }

    @MainActor
    func delete(_ object: Quality) {
        modelContainer.mainContext.delete(object)
    }

    func deleteAll() {
        let types: [any PersistentModel.Type] = [Project.self, Item.self, Quality.self, Score.self]

        for type in types {
            try? modelContext.delete(model: type)
        }
    }

    func count(for fetchDescriptor: FetchDescriptor<some Any>) -> Int {
        (try? modelContext.fetchCount(fetchDescriptor)) ?? 0
    }

    func item(with _: String) -> Item? {
        #warning("unable to get item by ID")
        return nil
//        guard let url = URL(string: uniqueIdentifier) else {
//            return nil
//        }
//
//        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
//            return nil
//        }
//
//        return try? container.viewContext.existingObject(with: id) as? Item
    }

    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: Project.self, Item.self, Quality.self, Score.self,
                configurations: config
            )

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
