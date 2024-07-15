//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectItemsSection: View {
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    @State private var sortOrder = ItemOld.SortOrder.score
    @State private var newItemName = ""

    let project: ProjectOld

    var itemSortingHeader: some View {
        HStack {
            Text("Items by \(sortOrder == .title ? "Title, Score" : "Score, Title")")

            Spacer()

            Button {
                withAnimation {
                    if sortOrder == .title {
                        sortOrder = .score
                    } else { // if sortOrder == .score
                        sortOrder = .title
                    }
                }
            } label: {
                Label {
                    Text("Switch sort priority")
                } icon: {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .labelStyle(.iconOnly)
            }
        }
    }

    var body: some View {
        Section(header: itemSortingHeader) {
            ForEach(project.projectItems) { item in
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    ItemRowView(project: project, item: item)
                        .listRowBackground(
                            BackgroundBarView(
                                value: item.scoreTotal,
                                max: project.scorePossible
                            )
                        )
                }
            }
            .onDelete { offsets in
                withAnimation {
                    for offset in offsets {
                        let item = project.projectItems[offset]
                        item.objectWillChange.send()
                        project.objectWillChange.send()
                        dataController.delete(item)
                        dataController.save()
                        dataController.objectWillChange.send()
                    }
                }
            }

            HStack {
                TextField("New Item Name", text: $newItemName)
                    .textFieldStyle(.roundedBorder)

                Button {
                    withAnimation {
                        project.addItem(titled: newItemName)
                        project.objectWillChange.send()
                        dataController.save()
                        newItemName = ""
                    }
                } label: {
                    Label("Add New Item", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .accessibilityLabel("Add new item")
                }
                .disabled(newItemName.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            ProjectItemsSection(
                project: .example
            )
        }
    }
}
