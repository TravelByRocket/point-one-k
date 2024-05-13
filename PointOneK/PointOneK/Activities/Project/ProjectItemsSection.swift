//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectItemsSection: View {
    @StateObject var viewModel: ViewModel
    @SceneStorage("selectedItemID") var selectedItemObjectID: String?
    @Environment(\.modelContext) private var context

    var itemSortingHeader: some View {
        HStack {
            Text("Items by \(viewModel.sortOrder == .title ? "Title, Score" : "Score, Title")")
            Spacer()
            Button {
                withAnimation {
                    viewModel.toggleSortOrder()
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
            ForEach(viewModel.items) { item in
                NavigationLink(
                    tag: String(item.objectID.debugDescription),
                    selection: $selectedItemObjectID
                ) {
                    ItemDetailView(item: item)
                } label: {
                    ItemRowView(project: viewModel.project, item: item)
                }
                .listRowBackground(
                    BackgroundBarView(
                        value: item.scoreTotal,
                        max: viewModel.project.scorePossible
                    )
                )
            }
            .onDelete { offsets in
                withAnimation {
                    viewModel.delete(at: offsets, with: context)
                }
            }
            if viewModel.items.isEmpty {
                Text("No items in this project")
            }
            HStack {
                Button {
                    withAnimation {
                        viewModel.addItem()
                    }
                } label: {
                    Label("Add New Item", systemImage: "plus")
                        .accessibilityLabel("Add new item")
                }
                
                Spacer()

                BatchAddButtonView(project: viewModel.project)
            }
        }
    }

    init(project: Project2, dataController: DataController) {
        let viewModel = ViewModel(project: project, dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
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
}
