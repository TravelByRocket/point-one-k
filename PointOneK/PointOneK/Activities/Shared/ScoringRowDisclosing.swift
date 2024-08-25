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
            Text(score.quality?.qualityNote ?? "Quality not found")
                .italic()
                .font(.footnote)
                .foregroundColor(.secondary)
        } label: {
            ScoringRow(label: label, score: score)
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    List {
        ScoringRowDisclosing(label: "Quality", score: .example)
    }
}
