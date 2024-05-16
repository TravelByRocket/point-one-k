//
//  ItemRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct ItemRowView: View {
    var project: Project
    var item: Item

    var body: some View {
        HStack {
            Text(item.itemTitle)
                .lineLimit(1)
            Spacer()
            ForEach(project.projectQualities) { quality in
                InfoPill(letter: quality.qualityIndicatorCharacter, level: quality.score(for: item)?.scoreValue ?? 0)
            }
        }
        .listRowBackground(BackgroundBarView(value: item.scoreTotal, max: project.scorePossible))
    }
}

#Preview {
    NavigationView {
        List {
            ItemRowView(project: .example, item: .example)
        }
    }
}
