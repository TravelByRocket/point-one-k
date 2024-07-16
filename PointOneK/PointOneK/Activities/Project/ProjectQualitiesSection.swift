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
                        dataController.delete(quality)
                    }
                }

                dataController.save()
            }

            TitleAddingButton(prompt: "Add New Quality") { _ in
                withAnimation {
                    #warning("add with quality title when merged")
                    project.addQuality()
                    dataController.save()
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
