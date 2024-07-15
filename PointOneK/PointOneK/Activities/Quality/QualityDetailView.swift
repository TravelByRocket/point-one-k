//
//  QualityDetailView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 28 Nov 2021.
//

import SwiftUI

struct QualityDetailView: View {
    @ObservedObject var quality: QualityOld

    @State var title: String
    @State var note: String

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    init(quality: QualityOld) {
        self.quality = quality

        _title = State(wrappedValue: quality.qualityTitle)
        _note = State(wrappedValue: quality.qualityNote)
    }

    var scoringFooter: some View {
        // swiftlint:disable:next line_length
        Text("Optional. Describe what each score level indicates for later reference to make sure items are scored consistently.")
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title.onChange(update), prompt: Text("Title here"))
                    .font(.title)
            }
            Section(header: Text("Scoring Notes"), footer: scoringFooter) {
                TextEditor(text: $note.onChange(update))
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
            QualityIndicatorEditSection(quality: quality)
            Section(header: Text("Scores")) {
                ForEach(
                    quality.qualityScores
                        .filter { $0.item != nil }
                        .sorted(by: \ScoreOld.item!.itemTitle)
                ) { score in
                    ScoringRow(
                        label: score.item!.itemTitle,
                        score: score
                    )
                }
                if quality.qualityScores.isEmpty {
                    Text("Project items will show up here")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
        }
        .onDisappear(perform: dataController.save)
    }

    func update() {
        quality.project?.objectWillChange.send()
        quality.title = title
        quality.note = note
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    QualityDetailView(quality: .example)
}
