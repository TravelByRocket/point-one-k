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
    @State var overrideIndicator: Bool

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var hasUniqueIndicator: Bool {
        return !quality.otherProjectIndicators.contains(indicator)
    }

    init(quality: Quality) {
        self.quality = quality

        _title = State(wrappedValue: quality.qualityTitle)
        _note = State(wrappedValue: quality.qualityNote)
        _indicator = State(wrappedValue: quality.qualityIndicator)
        _overrideIndicator = State(
            wrappedValue: quality.indicator != nil
            && quality.indicator != quality.defaultQualityIndicator)
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
                    .frame(minHeight: 150)
            }
            Section(header: Text("Pill Symbol Character")) {
                VStack {
                    Text("Default symbol is: \(quality.defaultQualityIndicator)")
                    Text(hasUniqueIndicator ? "Symbol is unique" : "Symbol already used")
                        .foregroundColor(hasUniqueIndicator ? .green : .orange)
                        .font(.footnote)
                        .italic()
                }
                Toggle("Override Default Symbol", isOn: $overrideIndicator)
                    .onChange(of: overrideIndicator) { nowOverride in
                        if !nowOverride {
                            indicator = quality.defaultQualityIndicator
                            update()
                        }
                    }
                HStack {
                    TextField("Indicator",
                              text: $indicator.onChange(update),
                              prompt: Text("Character to use as indicator"))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .font(.title)
                        .aspectRatio(1.4, contentMode: .fit)
                        .monospacedDigit()
                        .disabled(!overrideIndicator)
                        .onChange(of: $indicator.wrappedValue) { newValue in
                            indicator = String(newValue.prefix(1))
                        }
                    Spacer()
                    VStack {
                        Text("Pill Previews")
                            .font(.footnote)
                        HStack {
                            InfoPill(letter: indicator.first ?? "?", level: 1)
                            InfoPill(letter: indicator.first ?? "?", level: 2)
                            InfoPill(letter: indicator.first ?? "?", level: 3)
                            InfoPill(letter: indicator.first ?? "?", level: 4)
                        }
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                    )
                }
            }
            Section(header: Text("Scores")) {
                ForEach(quality.qualityScores.sorted(by: \Score.scoreItem.itemTitle)) {score in
                    RowInlineScoringView(score: score)
                }
                if quality.qualityScores.isEmpty {
                    Text("Project items will show up here")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
        }
    }

    func update() {
        quality.title = title
        quality.note = note
        quality.indicator = indicator
//        dataController.save()
    }
}

struct EditQualityView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        EditQualityView(quality: Quality.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

private struct RowInlineScoringView: View {
    @State var value: Int
    private let score: Score

    init(score: Score) {
        self.score = score
        _value = State(initialValue: score.scoreValue)
    }

    var body: some View {
        HStack {
            Text(score.scoreItem.itemTitle)
            Spacer()
            LevelSelector(value: $value)
                .onChange(of: value) { newValue in
                    score.value = Int16(newValue)
                }
        }
    }
}
