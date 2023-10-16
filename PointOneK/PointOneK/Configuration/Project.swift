//
//  Project.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import Foundation
import SwiftData

@Model public class Project2 {
    var closed: Bool?
    var color: String?
    var detail: String?
    var title: String?

    @Relationship(
        deleteRule: .cascade,
        inverse: \Item2.project)
    var items: [Item2]?
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \Quality2.project)
    var qualities: [Quality2]?

    public init() { }
}
