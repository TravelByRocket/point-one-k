//
//  ProjectsListView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import SwiftData
import SwiftUI

struct ProjectsListView: View {
    // Private
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.modelContext) private var context

    @FetchRequest(
        entity: ProjectOld.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ProjectOld.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")
    ) var projectsOld: FetchedResults<ProjectOld>

    @Query(
        filter: #Predicate<Project2> { $0.closed == false },
        sort: \Project2.title,
        order: .forward
    )
    private var projects2: [Project2]

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

    var body: some View {
        Group {
            if projectsOld.isEmpty {
                Text("There's nothing here right now")
            } else {
                projectsList
            }
        }
        .navigationTitle("Open Projects")
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationView {
        ProjectsListView()
    }
}
