//
//  EditProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftUI

struct ProjectDetailView: View {
    @ObservedObject var project: Project

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) private var presentationMode

    let colorColumns = [
        GridItem(.adaptive(minimum: 42))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }

    var body: some View {
        Form {
            TextField("Project name", text: $title.onChange(update))
                .font(.title)
            Section(header: Text("Description")) {
                TextEditor(text: $detail.onChange(update))
                    .font(.caption)
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
            Section(
                // swiftlint:disable:next line_length
                footer: Text("Closing a project hides a project until it is restored from Settings; deleting it removes the project entirely and permanently.")) {

                    Button(project.closed ? "Reopen this project" : "Close this project") {
                        project.closed.toggle()
                        update()
                    }
                    .tint(.primary)

                    Button("Delete this project") {
                        showingDeleteConfirm.toggle()
                    }
                    .tint(.red)
                }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) { getDeleteAlert() }
    }

    func getDeleteAlert() -> Alert {
        Alert(title: Text("Delete project?"),
              message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), // swiftlint:disable:this line_length
              primaryButton: .default(Text("Delete"), action: delete),
              secondaryButton: .cancel())
    }

    func update() {
        project.objectWillChange.send()
        project.title = title
        project.detail = detail
        project.color = color
    }

    func delete() {
        dataController.delete(project)
        dataController.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            ProjectDetailView(project: Project.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
