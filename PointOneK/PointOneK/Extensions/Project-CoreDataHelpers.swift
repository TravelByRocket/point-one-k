//
//  Project-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import SwiftUI
import CloudKit

extension Project {
    static let colors = [
        "Pink", "Purple", "Red", "Orange", "Gold",
        "Green", "Teal", "Light Blue", "Dark Blue",
        "Midnight", "Dark Gray", "Gray"]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    var projectQualities: [Quality] {
        qualities?.allObjects as? [Quality] ?? []
    }

    var scorePossible: Int {
        projectQualities.count * 4
    }

    func addItem(titled title: String? = nil) {
        guard let moc = managedObjectContext else { return }

        let item = Item(context: moc)
        item.project = self

        if let title = title {
            item.title = title
        }

        for quality in projectQualities {
            let score = Score(context: moc)
            score.item = item
            score.quality = quality
        }
    }

    func addQuality() {
        guard let moc = managedObjectContext else { return }

        let quality = Quality(context: moc)
        quality.project = self
        for item in projectItems {
            let score = Score(context: moc)
            score.item = item
            score.quality = quality
        }
    }

    static var example: Project {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true

        let quality = Quality(context: viewContext)
        quality.title = "Fancy title"
        quality.note = "notes"
        quality.indicator = "a"
        quality.project = project

        let score = Score(context: viewContext)
        score.value = 3
        score.quality = quality

        let item = Item(context: viewContext)
        item.project = project
        item.note = "item note"
        item.title = "Sweet Item"

        score.item = item

        return project
    }

    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items."
        )
    }

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return projectItems.sorted(by: \Item.scoreTotal).reversed()
                .sorted(by: \Item.itemTitle.localizedLowercase)
        case .score:
            return projectItems.sorted { first, second in
                if first.scoreTotal != second.scoreTotal {
                    return first.scoreTotal > second.scoreTotal // larger first
                } else {
                    return first.itemTitle.localizedLowercase < second.itemTitle.localizedLowercase // 'a' first
                }
            }
        }
    }

    func prepareCloudRecords() -> [CKRecord] {
        let parentName = objectID.uriRepresentation().absoluteString
        let parentID = CKRecord.ID(recordName: parentName)
        let parent = CKRecord(recordType: "Project", recordID: parentID)
        parent["title"] = projectTitle
        parent["detail"] = projectDetail
        parent["owner"] = "Synodic" // will change later
        parent["closed"] = closed

        var records: [CKRecord] = []

        records.append(parent)
        records.append(contentsOf: prepareItemCloudRecords())
        records.append(contentsOf: prepareQualityCloudRecords())
        records.append(contentsOf: prepareScoreCloudRecords())

        return records
    }

    private func prepareItemCloudRecords() -> [CKRecord] {
        projectItems.map { item -> CKRecord in
            let itemChildName = item.objectID.uriRepresentation().absoluteString
            let itemChildID = CKRecord.ID(recordName: itemChildName)
            let itemChild = CKRecord(recordType: "Item", recordID: itemChildID)
            itemChild["title"] = item.itemTitle
            itemChild["note"] = item.itemNote

            if let projectID = item.project?.objectID.uriRepresentation().absoluteString {
                let projectRecordID = CKRecord.ID(recordName: projectID)
                itemChild["project"] = CKRecord.Reference(recordID: projectRecordID, action: .deleteSelf)
            }

            return itemChild
        }
    }

    private func prepareQualityCloudRecords() -> [CKRecord] {
        projectQualities.map { quality -> CKRecord in
            let qualityChildName = quality.objectID.uriRepresentation().absoluteString
            let qualityChildID = CKRecord.ID(recordName: qualityChildName)
            let qualityChild = CKRecord(recordType: "Quality", recordID: qualityChildID)
            qualityChild["title"] = quality.qualityTitle
            qualityChild["note"] = quality.qualityNote
            qualityChild["indicatorCharacter"] = quality.indicator

            if let projectID = quality.project?.objectID.uriRepresentation().absoluteString {
                let projectRecordID = CKRecord.ID(recordName: projectID)
                qualityChild["project"] = CKRecord.Reference(recordID: projectRecordID, action: .deleteSelf)
            }

            return qualityChild
        }
    }

    private func prepareScoreCloudRecords() -> [CKRecord] {
        projectItems.flatMap { $0.itemScores }.map { score -> CKRecord in
            let scoreChildName = score.objectID.uriRepresentation().absoluteString
            let scoreChildID = CKRecord.ID(recordName: scoreChildName)
            let scoreChild = CKRecord(recordType: "Score", recordID: scoreChildID)
            scoreChild["value"] = score.scoreValue

            let itemID = score.scoreItem.objectID.uriRepresentation().absoluteString
            let itemRecordID = CKRecord.ID(recordName: itemID)

            let qualityID = score.scoreQuality.objectID.uriRepresentation().absoluteString
            let qualityRecordID = CKRecord.ID(recordName: qualityID)

            scoreChild["item"] = CKRecord.Reference(recordID: itemRecordID, action: .deleteSelf)
            scoreChild["quality"] = CKRecord.Reference(recordID: qualityRecordID, action: .deleteSelf)

            return scoreChild
        }
    }
}
