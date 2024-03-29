//
//  TopProjectItemsWidget.swift
//  PointOneK
//
//  Created by Bryan Costanza on 16 Mar 2022.
//

import SwiftUI
import WidgetKit

struct PointOneKWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .stroke(lineWidth: 10)
                .foregroundColor(Color(entry.project.projectColor))
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.project.projectTitle)
                        .font(.title3)
                        .foregroundColor(Color(entry.project.projectColor))
                    ForEach(entry.project.projectItems(using: .score)) { item in
                        HStack {
                            Circle()
                                .inset(by: 10)
                                .trim(
                                    from: 0.0,
                                    to: trimToFor(project: entry.project, item: item)
                                )
                                .stroke(lineWidth: 3)
                                .rotationEffect(.degrees(180))
                                .frame(width: 30)
                                .padding(-8)
                            Text(item.itemTitle)
                                .font(.caption)
                            Spacer()
                        }
                        .background {
                            BackgroundBarView(
                                value: item.scoreTotal,
                                max: entry.project.scorePossible)
                            .padding(-3)
                        }
                    }
                    if entry.project.projectItems.isEmpty {
                        Text("No items…")
                    }
                    Spacer()
                        .layoutPriority(1)
                }
                Spacer()
            }
            .padding()
        }
    }

    func trimToFor(project: Project, item: Item) -> CGFloat {
        if project.scorePossible > 0 {
            return CGFloat(item.scoreTotal) / CGFloat(entry.project.scorePossible)
        } else {
            return 0.0
        }
    }
}

struct PointOneKWidget: Widget {
    let kind: String = "PointOneKWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()) { entry in
                PointOneKWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PointOneKWidget_Previews: PreviewProvider {
    static var previews: some View {
        PointOneKWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                project: Project.example
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
