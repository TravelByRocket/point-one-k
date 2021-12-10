//
//  EditQualityView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 28 Nov 2021.
//

import SwiftUI

struct EditQualityView: View {
    let quality: Quality

    @State var title: String
    @State var note: String
    @State var indicator: String
    @State var editIndicator = false

    init(quality: Quality) {
        self.quality = quality

        _title = State(wrappedValue: quality.qualityTitle)
        _note = State(wrappedValue: quality.qualityNote)
        _indicator = State(wrappedValue: quality.qualityIndicator)
    }

    var body: some View {
        Form {
            TextField("Title", text: $title.onChange(update), prompt: Text("Title here"))
                .font(.title)
            TextEditor(text: $note.onChange(update))
            HStack {
                TextField("Indicator", text: $indicator.onChange(update), prompt: Text("Character to use as indicator"))
                    .textFieldStyle(.roundedBorder)
                    .font(.title)
                    .aspectRatio(1.4, contentMode: .fit)
                    .monospacedDigit()
                    .onChange(of: $indicator.wrappedValue) { newValue in
                        indicator = String(newValue.prefix(1))
                    }
                Spacer()
                Text("Preview: ")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .italic()
                Spacer()
                VStack {
                    VStack {
                        HStack {
                            InfoPill(letter: indicator.first ?? "?", level: 1)
                            InfoPill(letter: indicator.first ?? "?", level: 2)
                        }
                        HStack {
                            InfoPill(letter: indicator.first ?? "?", level: 3)
                            InfoPill(letter: indicator.first ?? "?", level: 4)
                        }
                    }
                }
            }
            Section(header: Text("Scores")) {
                ForEach(quality.qualityScores.sorted(by: \Score.scoreItemTitle)) {score in
                    RowInlineScoringView(score: score)
                }
            }
        }
    }

    func update() {
        quality.title = title
        quality.note = note
        quality.indicator = indicator
    }
}

struct EditQualityView_Previews: PreviewProvider {
    static var previews: some View {
        EditQualityView(quality: Quality.example)
    }
}

fileprivate struct RowInlineScoringView: View {
    @State var value: Int
    private let score: Score

    init(score: Score) {
        self.score = score
        _value = State(initialValue: score.scoreValue)
    }

    var body: some View {
        HStack {
            Text(score.scoreItemTitle)
            Spacer()
            LevelSelector(value: $value)
                .onChange(of: value) { newValue in
                    score.value = Int16(newValue)
                }
        }
    }
}
