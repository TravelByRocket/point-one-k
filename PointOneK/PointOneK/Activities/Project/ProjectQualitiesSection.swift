//
//  ProjectQualitiesSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectQualitiesSection: View {
    @Environment(\.modelContext) private var context

    let project: Project

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
            .onDelete {offsets in
                for offset in offsets {
                    withAnimation {
                        let quality = qualities[offset]
                        project.qualities?.removeAll { $0 == quality }
                        context.delete(quality)
                    }
                }
                try? context.save()
            }

            if qualities.isEmpty {
                Text("No qualities in this project")
            }

            Button {
                withAnimation {
                    project.addQuality()
                }
            } label: {
                Label("Add New Quality", systemImage: "plus")
                    .accessibilityLabel("Add quality")
            }
        }
    }

    private var qualities: [Quality] {
        project.projectQualities.sorted(by: \Quality.qualityTitle)
    }
}

struct ProjectQualitiesSection_Previews: PreviewProvider {
    static var previews: some View {
        ProjectQualitiesSection(project: Project.example)
    }
}
