//
//  ProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftData
import SwiftUI

struct ProjectView: View {
    @Environment(\.modelContext) private var context
    let project: ProjectV2

    var body: some View {
        Form {
            ProjectTitleEditView(project: project)
            Section(header: Text("Description")) {
                ProjectDetailEditView(project: project)
            }
            ProjectItemsSection(project: project)
            ProjectQualitiesSection(project: project)
            ProjectColorSelectionSection(project: project)
            ProjectArchiveDeleteSection(project: project)
        }
        .navigationTitle("Edit Project")
        .overlay(alignment: .top) {
            VStack {
                Text("Projects \(String(describing: try? context.fetchCount(FetchDescriptor<ProjectV2>())))")
                Text("Items \(String(describing: try? context.fetchCount(FetchDescriptor<ItemV2>())))")
                Text("Qualities \(String(describing: try? context.fetchCount(FetchDescriptor<QualityV2>())))")
                Text("Score \(String(describing: try? context.fetchCount(FetchDescriptor<ScoreV2>())))")
            }
            .font(.caption)
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationStack {
        ProjectView(project: .example)
    }
}
