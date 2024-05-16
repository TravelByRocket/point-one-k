//
//  ScoringRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 13 Mar 2022.
//

import SwiftUI

struct ScoringRow: View {
    let label: String
    private let score: Score
    @State private var value: Int

    init(label: String, score: Score) {
        self.label = label
        self.score = score
        _value = State(initialValue: score.scoreValue)
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            LevelSelector(value: $value)
                .onChange(of: value) {
                    score.item?.objectWillChange.send()
                    score.objectWillChange.send()
                    score.value = Int16(value)
                }
        }
    }
}

#Preview {
    List {
        ScoringRow(label: "Item/Quality", score: .example)
    }
}
