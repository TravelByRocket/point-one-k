//
//  ScoringRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 13 Mar 2022.
//

import SwiftUI

struct ScoringRow: View {
    let label: String
    private let score: ScoreV2
    @State private var value: Int

    init(label: String, score: ScoreV2) {
        self.label = label
        self.score = score
        _value = State(initialValue: score.value ?? 0)
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            LevelSelector(value: $value)
                .onChange(of: value) {
                    score.value = value
                }
        }
    }
}

#Preview {
    List {
        ScoringRow(label: "Item/Quality", score: .example)
    }
}
