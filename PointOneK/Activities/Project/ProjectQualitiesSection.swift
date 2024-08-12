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
                .accessibilityIdentifier("QualityRow \(quality.qualityTitle)")
            }
            .onDelete { offsets in
                for offset in offsets {
                    withAnimation {
                        let quality = qualities[offset]
                        project.qualities?.removeAll { $0 == quality } // needed for view to get notified
                        context.delete(quality)
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
