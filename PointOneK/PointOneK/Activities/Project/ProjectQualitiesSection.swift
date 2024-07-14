//
//  ProjectQualitiesSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftData
import SwiftUI

struct ProjectQualitiesSection: View {
    // Private
    @Environment(\.modelContext) private var context
    @State private var sortOrder = ItemV2.SortOrder.score

    // Memberwise Init
    @Bindable var project: ProjectV2

    // Workaround for conflict of delete with ForEach
    @Query private var qualitiesQuery: [QualityV2]
    private var qualities: [QualityV2] {
        qualitiesQuery
            .filter { $0.project == project }
            .sorted(by: \QualityV2.qualityTitle)
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
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            context.delete(quality)
                        }

                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
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
