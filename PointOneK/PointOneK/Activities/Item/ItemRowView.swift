//
//  ItemRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftData
import SwiftUI

struct ItemRowView: View {
    @Bindable var item: ItemV2

    // Workaround for conflict of delete with ForEach
    @Query private var scoresQuery: [ScoreV2]
    private var qualities: [QualityV2] {
        scoresQuery
            .filter { $0.item == item }
            .compactMap(\.quality)
            .sorted(by: \QualityV2.qualityTitle)
    }

    var body: some View {
        HStack {
            Text(item.itemTitle)
                .lineLimit(1)

            Spacer()

            ForEach(qualities) { quality in
                InfoPill(
                    letter: quality.qualityIndicatorCharacter,
                    level: quality.score(for: item)?.value ?? 0
                )
            }
        }
        .listRowBackground(
            BackgroundBarView(
                value: item.scoreTotal,
                max: item.project?.scorePossible ?? 0
            )
        )
    }
}

#Preview {
    NavigationStack {
        List {
            ItemRowView(item: .example)
        }
    }
}
