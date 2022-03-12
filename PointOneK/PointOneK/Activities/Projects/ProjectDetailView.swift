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
    @State private var sortOrder = Item.SortOrder.score

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) private var presentationMode

    let colorColumns = [
        GridItem(.adaptive(minimum: 42))
    ]

    var items: [Item] {
        project.projectItems(using: sortOrder)
    }

    var qualities: [Quality] {
        project.projectQualities.sorted(by: \Quality.qualityTitle)
    }

    var itemSortingHeader: some View {
        HStack {
            Text("Items by \(sortOrder == .title ? "Title" : "Score")")
            Spacer()
            Button {
                if sortOrder == .title {
                    sortOrder = .score
                } else { // if sortOrder == .score
                    sortOrder = .title
                }
            } label: {
                Label {
                    Text(sortOrder == .score ? "Title" : "Score")
                } icon: {
                    Image(systemName: "arrow.up.arrow.down")
                }

            }
        }
    }

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
            Section(header: itemSortingHeader) {
                ForEach(items) { item in
                    ItemRowView(project: project, item: item)
                }
                .onDelete(perform: {offsets in
                    for offset in offsets {
                        let item = items[offset]
                        dataController.delete(item)
                    }
                    project.objectWillChange.send()
                    dataController.save()
                })
                if items.isEmpty {
                    Text("No items in this project")
                }
                HStack {
                    Button {
                        project.addItem()
                        dataController.save()
                    } label: {
                        Label("Add New Item", systemImage: "plus")
                            .accessibilityLabel("Add new item")
                    }
                    Spacer()
                    BatchAddButtonView(project: project)
                }
            }
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

        dataController.save()
    }

    func delete() {
        dataController.delete(project)
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
