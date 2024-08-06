//
//  ItemDetailView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct ItemDetailView: View {
    @State private var title: String
    @State private var note: String

    @Bindable var item: Item

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _note = State(wrappedValue: item.itemNote)
    }

    var body: some View {
        Form {
            Section {
                TextField(
                    "Title",
                    text: $title.onChange(update)
                )
                .font(.title)
            }

            ForEach(item.projectQualities.sorted(by: \Quality.qualityTitle)) { quality in
                ScoringRowDisclosing(
                    label: quality.qualityTitle,
                    score: quality.score(for: item) ?? .example
                )
            }

            if item.projectQualities.isEmpty {
                Text("No project qualities exist")
            }

            HStack {
                Text("Score: \(item.scoreTotal) of \(item.project?.scorePossible ?? 0)")
                Spacer()
            }
            .listRowBackground(
                BackgroundBarView(value: item.scoreTotal, max: item.project?.scorePossible ?? 0)
            )

            Section(header: Text("Item Note")) {
                TextEditor(text: $note.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
    }

    func update() {
        item.title = title
        item.note = note
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationStack {
        ItemDetailView(item: .example)
    }
}
