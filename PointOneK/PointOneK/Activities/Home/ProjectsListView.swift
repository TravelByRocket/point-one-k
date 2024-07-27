//
//  ProjectsListView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import SwiftData
import SwiftUI

struct ProjectsListView: View {
    @Query(
        filter: #Predicate<ProjectV2> { $0.closed == false },
        sort: \ProjectV2.title,
        order: .forward
    )
    private var projects: [ProjectV2]

    var body: some View {
        Group {
            if projects.isEmpty {
                contentUnavailableView
            } else {
                projectsList
            }
        }
        .navigationTitle("Open Projects")
    }

    var projectsList: some View {
        List {
            ForEach(projects) { project in
                NavigationLink {
                    ProjectView(project: project)
                } label: {
                    ProjectRowView(project: project)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    var contentUnavailableView: some View {
        ContentUnavailableView(
            "No Projects Found",
            systemImage: "exclamationmark.magnifyingglass"
        )
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationStack {
        ProjectsListView()
    }
}
