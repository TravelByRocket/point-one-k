//
//  ItemDetailView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI
import SwiftData

struct ItemDetailView: View {
    var item: Item

    @Environment(\.modelContext) private var context

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
        .onDisappear(perform: save)
    }

    func update() {
        item.title = title
        item.note = note
    }

    func save() {
        // might not be needed
    }
}
#Preview {
    // swiftlint:disable:next force_try
    let container = try! ModelContainer(for: Project.self)
    let project = Project.example

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationView {
        ItemDetailView(item: .example)
    }
    .modelContainer(container)
}
