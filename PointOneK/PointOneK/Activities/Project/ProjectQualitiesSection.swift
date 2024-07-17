//
//  ProjectQualitiesSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectQualitiesSection: View {
    @ObservedObject var project: Project

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var newQualityName = ""

    var qualities: [Quality] {
        project.projectQualities.sorted(by: \Quality.qualityTitle)
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
                        quality.objectWillChange.send()
                        project.objectWillChange.send()
                        dataController.delete(quality)
                        dataController.save()
                        dataController.objectWillChange.send()
                        dataController.delete(quality)
                    }
                }

                dataController.save()
            }

            TitleAddingRow(prompt: "Add New Quality") { title in
                withAnimation {
                    project.addQuality(titled: title)
                    dataController.save()
                }
            }
        }
    }

    @ViewBuilder
    private func infoPills(character: Character, isReversed: Bool) -> some View {
        let levels = isReversed ? [4, 3, 2, 1] : [1, 2, 3, 4]

        ForEach(levels, id: \.self) { level in
            InfoPill(letter: character, level: level)
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    List {
        ProjectQualitiesSection(project: .example)
    }
}
