//
//  Item.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/6/23.
//
//

import Foundation
import SwiftData


@Model public class Item {
    var note: String?
    var title: String?
    var project: Project?

    @Relationship(
        deleteRule: .cascade,
        inverse: \Score.item)
    var scores: [Score]?

    public init() { }
}
