//
//  EditProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftUI

struct ProjectView: View {
    let project: Project

    @State private var color: String

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    let colorColumns = [
        GridItem(.adaptive(minimum: 42))
    ]

    init(project: Project) {
        self.project = project

        _color = State(wrappedValue: project.projectColor)
    }

    var body: some View {
        Form {
            ProjectTitleEditView(project: project)
            Section(header: Text("Description")) {
                ProjectDetailEditView(project: project)
            }
            ProjectItemsSection(project: project)
            ProjectQualitiesSection(project: project)
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { color in
                        ProjectColorButtonView(item: color, color: $color.onChange(update))
                    }
                }
            }
            .padding(.vertical)
            ProjectArchiveDeleteSection(project: project)
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
    }

    func update() {
        project.objectWillChange.send()
        project.color = color
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            ProjectView(project: Project.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
