//
//  Item.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import Foundation
import SwiftData

@Model public class Item2 {
    var note: String?
    var title: String?
    var project: Project?
    @Relationship(
        deleteRule: .cascade,
        inverse: \Score2.item)
    var scores: [Score2]?

    public init() { }
}
