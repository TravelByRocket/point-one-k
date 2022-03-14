//
//  ScoringRowDisclosing.swift
//  PointOneK
//
//  Created by Bryan Costanza on 13 Mar 2022.
//

import SwiftUI

struct ScoringRowDisclosing: View {
    let label: String
    let score: Score

    var body: some View {
        DisclosureGroup {
            Text(score.scoreQuality.qualityNote)
                .italic()
                .font(.footnote)
                .foregroundColor(.secondary)
        } label: {
            ScoringRow(label: label, score: score)
        }
    }
}

struct ScoringRowDisclosing_Previews: PreviewProvider {
    static var previews: some View {
        ScoringRowDisclosing(label: "Quality", score: Score.example)
    }
}
