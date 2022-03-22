//
//  EditQualityView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 28 Nov 2021.
//

import SwiftUI

struct QualityDetailView: View {
    @ObservedObject var quality: Quality

    @State var title: String
    @State var note: String

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    init(quality: Quality) {
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
                        .sorted(by: \Score.item!.itemTitle)
                ) { score in
                    ScoringRow(
                        label: score.item!.itemTitle,
                        score: score)
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

struct QualityDetailView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        QualityDetailView(quality: Quality.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
