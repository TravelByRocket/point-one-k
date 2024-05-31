//
//  ProjectQualitiesSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftData
import SwiftUI

struct ProjectQualitiesSection: View {
    @Bindable var project: Project

    @Environment(\.modelContext) private var context

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
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 1)
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 2)
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 3)
                        InfoPill(letter: quality.qualityIndicatorCharacter, level: 4)
                    }
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    withAnimation {
                        let quality = qualities[offset]
                        context.delete(quality)
                    }
                }
            }

            if qualities.isEmpty {
                Text("No qualities in this project")
            }

            Button {
                withAnimation {
                    project.addQuality(in: context)
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
