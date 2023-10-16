//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI
import SwiftData

struct ProjectItemsSection: View {
    // Private
    @Environment(\.modelContext) private var context
    @SceneStorage("selectedItemID") private var selectedItemObjectID: String?
    @State private var sortOrder: Item.SortOrder = .score
    @Query private var items2: [Item]

    // Init
    var project: Project

    var body: some View {
        Section(header: itemSortingHeader) {
            ForEach(items) { item in
                NavigationLink(
                    tag: String(item.hashValue),
                    selection: $selectedItemObjectID) {
                        ItemDetailView(item: item)
                    } label: {
                        ItemRowView(project: project, item: item)
                    }
                    .listRowBackground(
                        BackgroundBarView(
                            value: item.scoreTotal,
                            max: project.scorePossible)
                    )
            }
            .onDelete { offsets in
                withAnimation {
                    delete(at: offsets)
                }
            }

            if project.projectItems.isEmpty {
                Text("No items in this project")
            }
            
            HStack {
                Button {
                    withAnimation {
                        addItem()
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

    var items: [Item] {
        project.projectItems(using: sortOrder)
    }

    var itemSortingHeader: some View {
        HStack {
            Text("Items by \(sortOrder == .title ? "Title, Score" : "Score, Title")")

            Spacer()

            Button {
                withAnimation {
                    toggleSortOrder()
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

    private func toggleSortOrder() {
        if sortOrder == .title {
            sortOrder = .score
        } else { // if sortOrder == .score
            sortOrder = .title
        }
    }

    private func delete(at offsets: IndexSet) {
        for offset in offsets {
            let item = items[offset]
            project.items?.removeAll { $0 == item }
            context.delete(item)
        }
        try? context.save()
    }

    private func addItem() {
        project.addItem()
    }
}

struct ProjectItemsSection_Previews: PreviewProvider {
    @Environment(\.modelContext) static var context
    static var previews: some View {
        NavigationView {
            List {
                ProjectItemsSection(project: .example)
            }
        }
    }
}
