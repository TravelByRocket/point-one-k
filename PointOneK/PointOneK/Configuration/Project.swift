//
//  Project.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import SwiftData

@Model public class ProjectV2 {
    var closed: Bool?
    var color: String?
    var detail: String?
    var title: String?

    @Relationship(deleteRule: .cascade)
    var items: [ItemV2]?

    @Relationship(deleteRule: .cascade)
    var qualities: [QualityV2]?

    public init() {}
}
