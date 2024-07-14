//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftData
import SwiftUI

struct ProjectItemsSection: View {
    // Private
    @Environment(\.modelContext) private var context
    @State private var sortOrder = ItemV2.SortOrder.score
    @Query private var itemsQuery: [ItemV2]

    // Memberwise Init
    @Bindable var project: ProjectV2

    // Workaround for conflict of delete with ForEach
    private var items: [ItemV2] {
        itemsQuery
            .filter { $0.project == project }
            .sorted(by: \ItemV2.itemTitle)
    }

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
            ForEach(items) { item in
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    ItemRowView(item: item)
                        .listRowBackground(
                            BackgroundBarView(
                                value: item.scoreTotal,
                                max: project.scorePossible
                            )
                        )
                }
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            context.delete(item)
                        }

                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }

            if project.projectItems.isEmpty {
                Text("No items in this project")
            }

            HStack {
                Button {
                    withAnimation {
                        project.addItem()
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
    NavigationStack {
        List {
            ProjectItemsSection(
                project: .example
            )
        }
    }
}
