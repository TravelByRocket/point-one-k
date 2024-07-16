//
//  ItemRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct ItemRowView: View {
    let item: ItemOld

    var body: some View {
        HStack {
            Text(item.itemTitle)
                .lineLimit(1)

            Spacer()

            ForEach(item.project?.projectQualities ?? []) { quality in
                InfoPill(
                    letter: quality.qualityIndicatorCharacter,
                    level: quality.score(for: item)?.scoreValue ?? 0
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

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ItemRowView(item: ItemOld.example)
                ItemRowView(item: ItemOld.example)
                ItemRowView(item: ItemOld.example)
            }
        }
    }
}
