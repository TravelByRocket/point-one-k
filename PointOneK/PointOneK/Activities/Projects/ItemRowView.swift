//
//  ItemRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var item: Item

    var icon: some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }

    var label: Text {
        if item.completed {
            return Text("\(item.itemTitle), completed.")
        } else if item.priority == 3 {
            return Text("\(item.itemTitle), high priority.")
        } else {
            return Text(item.itemTitle)
        }
    }

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            HStack {
                Text(item.itemTitle)
                    .lineLimit(1)
                Spacer()
                ForEach(item.project?.qualities?.allObjects as? [Quality] ?? []) {quality in
                    InfoPill(letter: quality.qualityIndicator.first!, level: quality.score(for: item)?.scoreValue ?? 0)
                }
            }
            .background(BackgroundBarView(value: item.scoreTotal, max: project.scorePossible))
        }
        .accessibilityLabel(label)
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ItemRowView(project: Project.example, item: Item.example)
            }
        }
    }
}
