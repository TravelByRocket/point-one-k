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
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 1)
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 2)
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 3)
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 4)
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
}

#Preview(traits: .modifier(.persistenceLayer)) {
    List {
        ProjectQualitiesSection(project: .example)
    }
}
