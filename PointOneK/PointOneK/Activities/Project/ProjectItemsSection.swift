//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI
import SwiftData

struct ProjectItemsSection: View {
    @Environment(\.modelContext) private var context

    @State private var sortOrder = Item.SortOrder.score

    @Bindable var project: Project

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
            ForEach(project.items ?? []) { item in
                NavigationLink(
                    tag: String(item.objectID.debugDescription),
                    selection: $selectedItemObjectID
                ) {
                    ItemDetailView(item: item)
                } label: {
                    ItemRowView(project: project, item: item)
                }
                .listRowBackground(
                    BackgroundBarView(
                        value: item.scoreTotal,
                        max: project.scorePossible
                    )
                )
            }
            .onDelete { offsets in
                withAnimation {
                    for offset in offsets {
                        guard let item = project.items?[offset] else { continue }
                        context.delete(item)
                    }
                }
            }
            if project.items?.isEmpty ?? true {
                Text("No items in this project")
            }
            HStack {
                Button {
                    withAnimation {
                        project.addItem(titled: "New Item", in: context)
                    }
                } label: {
                    Label("Add New Item", systemImage: "plus")
                        .accessibilityLabel("Add new item")
                }

                Spacer()

                BatchAddButtonView(project: project)
            }
        }
    }
}

#Preview {
    NavigationView {
        List {
            ProjectItemsSection(
                project: .example,
                dataController: DataController.preview
            )
        }
    }
    .modelContainer(container)
}
