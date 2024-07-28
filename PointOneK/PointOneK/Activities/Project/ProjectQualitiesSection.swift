//
//  ProjectQualitiesSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectQualitiesSection: View {
    @Environment(\.modelContext) private var context

    @Bindable var project: Project

    var qualities: [Quality] {
        project.qualities?.sorted(by: \Quality.qualityTitle) ?? []
    }

    var body: some View {
        Section(header: Text("Qualities")) {
            ForEach(qualities) { quality in
                NavigationLink {
                    QualityDetailView(quality: quality)
                } label: {
                    HStack {
                        Text(quality.qualityTitle)

                        Spacer()

                        ForEach(quality.possibleScores, id: \.self) { level in
                            InfoPill(
                                letter: quality.qualityIndicatorCharacter,
                                level: level
                            )
                        }
                    }
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    withAnimation {
                        let quality = qualities[offset]
                        project.qualities?.removeAll { $0 == quality }
                        quality.project = nil

                        for score in quality.scores ?? [] {
                            score.item?.scores?.removeAll { $0 == score }
                            score.quality = nil
                            context.delete(score)
                        }
                        context.delete(quality)
                        try? context.save()
                    }
                }
            }

            TitleAddingRow(prompt: "Add New Quality") { title in
                withAnimation {
                    project.addQuality(titled: title)
                }
            }
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    List {
        ProjectQualitiesSection(project: .example)
    }
}
