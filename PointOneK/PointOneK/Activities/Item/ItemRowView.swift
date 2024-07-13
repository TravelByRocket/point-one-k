//
//  ItemRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct ItemRowView: View {
    @Bindable var project: ProjectV2
    @Bindable var item: ItemV2

    var body: some View {
        HStack {
            Text(item.itemTitle)
                .lineLimit(1)

            Spacer()

            ForEach(project.projectQualities) { quality in
                InfoPill(
                    letter: quality.qualityIndicatorCharacter,
                    level: Int(quality.score(for: item)?.value ?? 0)
                )
            }
        }
        .listRowBackground(
            BackgroundBarView(
                value: item.scoreTotal,
                max: project.scorePossible
            )
        )
    }
}

#Preview {
    NavigationStack {
        List {
            ItemRowView(project: .example, item: .example)
        }
    }
}
