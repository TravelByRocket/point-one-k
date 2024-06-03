//
//  ItemDetailView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftData
import SwiftUI

struct ItemDetailView: View {
    @Environment(\.modelContext) private var context

    @Bindable var item: Item

    @State var title: String
    @State var note: String

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _note = State(wrappedValue: item.itemNote)
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title.onChange(update))
                    .font(.title)
            }
            ForEach(item.projectQualities.sorted(by: \QualityOld.qualityTitle)) { quality in
                ScoringRowDisclosing(
                    label: quality.qualityTitle,
                    score: quality.score(for: item) ?? .example
                )
            }

            if item.projectQualities.isEmpty {
                Text("No project qualities exist")
            }

            Text("Score: \(item.scoreTotal) of \(item.project?.scorePossible ?? 0)")

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
    NavigationView {
        ItemDetailView(item: .example)
    }
}
