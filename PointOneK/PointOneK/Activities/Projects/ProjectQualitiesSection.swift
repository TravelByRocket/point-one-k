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
                        InfoPill(letter: quality.qualityIndicator.first ?? "?", level: 1)
                        InfoPill(letter: quality.qualityIndicator.first ?? "?", level: 2)
                        InfoPill(letter: quality.qualityIndicator.first ?? "?", level: 3)
                        InfoPill(letter: quality.qualityIndicator.first ?? "?", level: 4)
                    }
                }
            }
            .onDelete(perform: {offsets in
                for offset in offsets {
                    let quality = qualities[offset]
                    dataController.delete(quality)
                }
                dataController.save()
            })
            if qualities.isEmpty {
                Text("No qualities in this project")
            }
            Button {
                project.addQuality()
                dataController.save()
            } label: {
                Label("Add New Quality", systemImage: "plus")
                    .accessibilityLabel("Add project")
            }
        }
    }
}

struct ProjectQualitiesSection_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectQualitiesSection(project: Project.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
