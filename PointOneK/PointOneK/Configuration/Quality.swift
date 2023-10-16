//
//  Quality.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/6/23.
//
//

import Foundation
import SwiftData


@Model public class Quality {
    var indicator: String?
    var note: String?
    var title: String?
    var project: Project?
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \Score.quality) 
    var scores: [Score]?

    public init() { }
}
