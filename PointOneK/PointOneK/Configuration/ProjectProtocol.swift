//
//  ProjectProtocol.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/23/24.
//

import Foundation
import SwiftUICore

protocol ProjectProtocol {
    associatedtype ItemType
    associatedtype QualityType
    associatedtype ItemSequence: Sequence<ItemType>
    associatedtype QualitySequence: Sequence<QualityType>

    var closed: Bool { get }
    var color: String? { get }
    var detail: String? { get }
    var title: String? { get }
    var items: ItemSequence? { get }
    var qualities: QualitySequence? { get }
}

extension ProjectProtocol {
    static var colors: [String] {
        [
            "Pink", "Purple", "Red", "Orange", "Gold",
            "Green", "Teal", "Light Blue", "Dark Blue",
            "Midnight", "Dark Gray", "Gray",
        ]
    }

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectItems: [ItemType] {
        items?.map { $0 } ?? []
    }

    var projectQualities: [QualityType] {
        qualities?.map { $0 } ?? []
    }

    var scorePossible: Int {
        projectQualities.count * 4
    }

//    func addItem(titled title: String? = nil)
//    func addQuality(titled title: String? = nil) {

    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items."
        )
    }

//    func projectItems(using sortOrder: ItemV2.SortOrder) -> [ItemV2] {
//        switch sortOrder {
//            case .title:
//                projectItems.sorted(by: \ItemV2.scoreTotal).reversed()
//                    .sorted(by: \ItemV2.itemTitle.localizedLowercase)
//            case .score:
//                projectItems.sorted { first, second in
//                    if first.scoreTotal != second.scoreTotal {
//                        first.scoreTotal > second.scoreTotal // larger first
//                    } else {
//                        first.itemTitle.localizedLowercase < second.itemTitle.localizedLowercase // 'a' first
//                    }
//                }
//        }
//    }
}
