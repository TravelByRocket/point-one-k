//
//  ProjectsViewNew.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import SwiftUI
import SwiftData

struct ProjectsListView: View {
    @Environment(\.modelContext) private var context

    @Query(
        filter: #Predicate<Project> { $0.closed == false },
        sort: \Project.title,
        order: .forward)
    private var projects: [Project]

    var projectsList: some View {
        List {
            ForEach(projects) {project in
                NavigationLink {
                    ProjectView(project: project)
                } label: {
                    ProjectRowView(project: project)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    var body: some View {
        Group {
            if projects.isEmpty {
                Text("There's nothing here right now")
            } else {
                projectsList
            }
        }
        .navigationTitle("Open Projects")
    }
}

struct ProjectsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectsListView()
        }
    }
}
