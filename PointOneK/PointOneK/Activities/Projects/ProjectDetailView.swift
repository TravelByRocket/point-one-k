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
    @State private var holdCompletionPct: CGFloat = 0.0
    @State private var showBatchEntry = false

    private let batchHoldTimerLength = 1.5

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    let colorColumns = [
        GridItem(.adaptive(minimum: 42))
    ]

    var items: [Item] {
        project.projectItems(using: sortOrder)
    }

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
                TextEditor(text: $detail.onChange(update))
                    .font(.caption)
            }
            Section(
                header:
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
            ) {
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
                Button {
                    addItem(to: project)
                } label: {
                    HStack {
                        Label("Add New Item", systemImage: "plus")
                            .accessibilityLabel("Add new item")
                        Spacer()
                        Text("Hold to\nBatch Add")
                            .padding(5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5.0)
                                    .trim(from: 0.0, to: holdCompletionPct)
                                    .stroke()
                            }
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .tint(.secondary)
                    }
                }
                .onLongPressGesture(minimumDuration: batchHoldTimerLength, maximumDistance: 50) {
                    holdCompletionPct = 0.0
                    showBatchEntry.toggle()
                } onPressingChanged: { isNowPressing in
                    if isNowPressing {
                        withAnimation(.linear(duration: batchHoldTimerLength)) {
                            holdCompletionPct = 1.0
                        }
                    } else {
                        holdCompletionPct = 0.0
                    }
                }
                .sheet(isPresented: $showBatchEntry) {
                    BatchAddItemsView(project: project)
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
                    addQuality(to: project)
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

    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            for quality in project.projectQualities {
                let score = Score(context: managedObjectContext)
                score.item = item
                score.quality = quality
            }
            dataController.save()
        }
    }

    func addQuality(to project: Project) {
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
