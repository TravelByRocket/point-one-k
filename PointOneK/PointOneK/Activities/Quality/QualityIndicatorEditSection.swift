//
//  QualityIndicatorEditSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 13 Mar 2022.
//

import SwiftUI

struct QualityIndicatorEditSection: View {
    @ObservedObject var quality: Quality
    @State private var indicatorFieldString: String

    @State var overrideIndicator: Bool

    init(quality: Quality) {
        self.quality = quality
        _indicatorFieldString = State(
            initialValue: quality.indicatorCharacter?.asString ?? quality.defaultQualityIndicator.asString)
        _overrideIndicator = State(wrappedValue: quality.indicator != nil)
    }

    var body: some View {
        Section(header: Text("Pill Symbol Character")) {
            HStack {
                VStack {
                    Text("Pill Previews")
                        .font(.footnote)

                    HStack {
                        ForEach(quality.possibleScores, id: \.self) { level in
                            InfoPill(
                                letter: quality.qualityIndicatorCharacter,
                                level: level
                            )
                        }
                    }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.secondary)
                        .opacity(0.5)
                }

                Spacer()

                VStack {
                    Text("Default symbol is: \(quality.defaultQualityIndicator.asString)")
                    Text("Symbol '\(quality.qualityIndicatorCharacter.asString)' is \(quality.hasUniqueIdentifier ? "unique" : "already used")") // swiftlint:disable:this line_length
                        .foregroundColor(quality.hasUniqueIdentifier ? .green : .orange)
                        .font(.footnote)
                        .italic()
                }
            }

            Toggle("Reverse Score", isOn: $quality.isReversed.animation())

            Toggle("Override Default Symbol", isOn: $overrideIndicator.animation())
                .onChange(of: overrideIndicator) {
                    quality.project?.objectWillChange.send()
                    if overrideIndicator, let char = indicatorFieldString.first {
                        quality.indicator = String(char)
                    } else {
                        quality.indicator = nil
                    }
                }

            if overrideIndicator {
                HStack {
                    Text("Replace with character")
                        .fixedSize()

                    TextField("Indicator", text: $indicatorFieldString.onChange(update))
                        .accessibilityLabel("Character to use as indicator")
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .font(.body.monospaced())
                        .monospacedDigit()
                        .disabled(!overrideIndicator)
                }
            }
        }
    }

    func update() {
        let indicatorCharacter = indicatorFieldString.first
        quality.project?.objectWillChange.send()
        quality.indicator = indicatorCharacter?.asString
    }
}

#Preview {
    List {
        QualityIndicatorEditSection(quality: .example)
    }
}
