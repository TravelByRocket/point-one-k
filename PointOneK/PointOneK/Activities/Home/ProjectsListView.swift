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
        filter: #Predicate<Project> { $0.closed == false },
        sort: \Project.title,
        order: .forward
    )
    private var projects: [Project]

    var body: some View {
        Group {
            if projects.isEmpty {
                contentUnavailable
            } else {
                projectsList
            }
        }
        .navigationTitle("Open Projects")
    }

    private var projectsList: some View {
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

    private var contentUnavailable: some View {
        ContentUnavailableView(
            "No Projects Found",
            systemImage: "exclamationmark.magnifyingglass"
        )
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationView {
        ProjectsListView()
    }
}
