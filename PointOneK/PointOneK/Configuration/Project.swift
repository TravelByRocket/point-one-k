//
//  Project.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/6/23.
//
//

import Foundation
import SwiftData

@Model public class Project {
    var closed: Bool?
    var color: String?
    var detail: String?
    var title: String?

    @Relationship(
        deleteRule: .cascade,
        inverse: \Item.project)
    var items: [Item]?
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \Quality.project)
    var qualities: [Quality]?

    public init(
        closed: Bool = false,
        color: String? = nil,
        detail: String? = nil,
        title: String? = nil,
        items: [Item] = [],
        qualities: [Quality] = []
    ) {
        self.closed = closed
        self.color = color
        self.detail = detail
        self.title = title
        self.items = items
        self.qualities = qualities
    }

}
