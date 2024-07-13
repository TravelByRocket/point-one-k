//
//  ModelContext+addSampleData.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/12/24.
//

import SwiftData

extension ModelContext {
    func addSampleData() throws {
        // PROJECTS
        for projectCounter in 1 ... 3 {
            let project = ProjectV2()
            project.title = "Project \(projectCounter)"
            project.items = []
            project.closed = false
            project.detail = "Nothing in particular \(Int.random(in: 1_000 ... 9_999))"

            // QUALITIES
            for qualityCounter in 1 ... 3 {
                let quality = QualityV2()
                quality.title = "Quality \(qualityCounter)"
                quality.note = "Description \(Int.random(in: 1_000 ... 9_999))"
                quality.project = project
            }

            // ITEMS
            for itemCounter in 1 ... 3 {
                let item = ItemV2()
                item.title = "Item \(itemCounter)"
                item.project = project

                // QUALITIES <-> SCORES
                for quality in project.qualities ?? [] {
                    let score = ScoreV2()
                    score.item = item
                    score.quality = quality
                    score.value = Int.random(in: 1 ... 4)
                }
            }

            insert(project)
        }
    }
}
