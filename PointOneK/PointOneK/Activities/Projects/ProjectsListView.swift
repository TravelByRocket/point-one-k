//
//  ProjectsViewNew.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import SwiftUI

struct ProjectsListView: View {
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    @Binding var sortOrder: Item.SortOrder

    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")
    ) var projects: FetchedResults<Project>

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
        .listStyle(InsetGroupedListStyle())
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
    static var dataController = DataController.preview
    @State static var sortOrder: Item.SortOrder = .score

    static var previews: some View {
        NavigationView {
            ProjectsListView(sortOrder: $sortOrder)
                .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}
