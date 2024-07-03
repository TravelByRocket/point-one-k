//
//  ItemRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var project: ProjectOld
    @ObservedObject var item: ItemOld

    var body: some View {
        HStack {
            Text(item.itemTitle)
                .lineLimit(1)
            Spacer()
            ForEach(project.projectQualities) {quality in
                InfoPill(letter: quality.qualityIndicatorCharacter, level: quality.score(for: item)?.scoreValue ?? 0)
            }
        }
        .listRowBackground(BackgroundBarView(value: item.scoreTotal, max: project.scorePossible))
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ItemRowView(project: ProjectOld.example, item: ItemOld.example)
            }
        }
    }
}
