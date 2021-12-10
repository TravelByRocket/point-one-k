//
//  EditProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 42))
    ]

    var qualities: [Quality] {
        project.projectQualities.sorted(by: \Quality.qualityTitle)
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
            Section(header: Text("Descrption")) {
                TextField("Description of this project", text: $detail.onChange(update))
                    .font(.caption)
            }
            Section(header: Text("Qualities")) {
                ForEach(qualities) {quality in
                    NavigationLink {
                        EditQualityView(quality: quality)
                    } label: {
                        HStack {
                            Text(quality.qualityTitle)
                            Spacer()
                            InfoPill(letter: quality.qualityIndicator.first!, level: 0)
                            InfoPill(letter: quality.qualityIndicator.first!, level: 1)
                            InfoPill(letter: quality.qualityIndicator.first!, level: 2)
                            InfoPill(letter: quality.qualityIndicator.first!, level: 3)
                            InfoPill(letter: quality.qualityIndicator.first!, level: 4)
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
                Button {
                    withAnimation {
                        let quality = Quality(context: managedObjectContext)
                        quality.project = project
                        for item in project.projectItems {
                            let score = Score(context: managedObjectContext)
                            score.item = item
                            score.quality = quality
                        }
                        dataController.save()
                    }
                } label: {
                    Label("Add New Quality", systemImage: "plus")
                        .accessibilityLabel("Add project")
                }
            }
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
            }
                .padding(.vertical)
            Section(
                // swiftlint:disable:next line_length
                footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }

                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
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

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
            .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
            ? [.isButton, .isSelected]
            : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        EditProjectView(project: Project.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}


//            Button {
//                for item in project.projectItems {
//                    for quality in qualities {
//                        if !item.hasScore(for: quality) {
//                            let score = Score(context: managedObjectContext)
//                            score.item = item
//                            score.quality = quality
//                        }
//                    }
//                }
//                dataController.save()
//            } label: {
//                Text("Add missing scores")
//            }
