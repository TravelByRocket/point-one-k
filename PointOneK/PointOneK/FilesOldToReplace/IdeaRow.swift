//
//  IdeaRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI

struct IdeaRow: View {
    @ObservedObject var idea: Idea

    var body: some View {
        HStack {
            Text(idea.name)
                .lineLimit(1)
            Spacer()
            Group {
                InfoPill(letter: "i", level: $idea.impact)
                InfoPill(letter: "e", level: $idea.effort)
                InfoPill(letter: "v", level: $idea.vision)
                InfoPill(letter: "p", level: $idea.profitability)
            }
        }
        .background(BackgroundBar(value: idea.totalScore, max: 16))
    }
}

struct IdeaRow_Previews: PreviewProvider {
    static var previews: some View {
        List(0 ..< 5) { _ in
            IdeaRow(idea: Idea(
                name: "Any Idea",
                impact: 1,
                effort: 2,
                vision: 3,
                profitability: 4,
                notes: "some notes"))
        }
    }
}
