//
//  ProjectQualitiesSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectQualitiesSection: View {
    @ObservedObject var project: ProjectOld

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    var qualities: [QualityOld] {
        project.projectQualities.sorted(by: \QualityOld.qualityTitle)
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

                        infoPills(
                            character: quality.qualityIndicatorCharacter,
                            isReversed: quality.isReversed
                        )
                    }
                }
            }
            .onDelete(perform: { offsets in
                for offset in offsets {
                    withAnimation {
                        let quality = qualities[offset]
                        dataController.delete(quality)
                    }
                }
                dataController.save()
            })
            if qualities.isEmpty {
                Text("No qualities in this project")
            }
            Button {
                withAnimation {
                    project.addQuality()
                    dataController.save()
                }
            } label: {
                Label("Add New Quality", systemImage: "plus")
                    .accessibilityLabel("Add project")
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
