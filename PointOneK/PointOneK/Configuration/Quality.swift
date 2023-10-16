//
//  Quality.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import Foundation
import SwiftData

@Model public class Quality2 {
    var indicator: String?
    var note: String?
    var title: String?
    var project: Project2?

    @Relationship(
        deleteRule: .cascade,
        inverse: \Score2.quality)
    var scores: [Score2]?

    public init() { }
}
