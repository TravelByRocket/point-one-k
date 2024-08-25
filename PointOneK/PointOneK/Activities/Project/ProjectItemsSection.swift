//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectItemsSection: View {
    @Environment(\.modelContext) private var context
    @State private var sortOrder = Item.SortOrder.score

    @Bindable var project: Project

    var body: some View {
        Section(header: itemSortingHeader) {
            ForEach(items) { item in
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    // TODO: Fix ItemRowView #66
                    row(item: item)
                }
                .accessibilityIdentifier("ItemRow \(item.itemTitle)")
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
                        let item = items[offset]
                        project.items?.removeAll { $0 == item } // needed for view to get notified
                        context.delete(item)
                    }
                }
            }

            TitleAddingRow(prompt: "Add New Item") { title in
                withAnimation {
                    project.addItem(titled: title)
                }
            }
        }
    }

    private var items: [ItemV2] {
        project.projectItems(using: sortOrder)
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

    // TODO: Fix ItemRowView #66
    private func row(item: Item) -> some View {
        HStack {
            Text(item.itemTitle)
                .lineLimit(1)

            Spacer()

            ForEach(item.project?.projectQualities.sorted(by: \.qualityIndicatorCharacter) ?? []) { quality in
                InfoPill(
                    letter: quality.qualityIndicatorCharacter,
                    level: quality.score(for: item)?.value ?? 0
                )
            }
        }
        .listRowBackground(
            BackgroundBarView(
                value: item.scoreTotal,
                max: item.project?.scorePossible ?? 0
            )
        )
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationStack {
        List {
            ProjectItemsSection(
                project: .example
            )
        }
    }
}
