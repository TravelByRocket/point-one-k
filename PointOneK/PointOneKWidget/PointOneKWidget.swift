//
//  PointOneKWidget.swift
//  PointOneK
//
//  Created by Bryan Costanza on 16 Mar 2022.
//

import SwiftData
import SwiftUI
import WidgetKit

struct PointOneKWidgetEntryView: View {
    @Query private var projects: [ProjectV2]

    var entry: Provider.Entry

    var project: ProjectV2? {
        projects.first(where: { $0.widgetID == 1 })
    }

    var color: Color? {
        if let color = project?.projectColor {
            Color(color)
        } else {
            nil
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project?.projectTitle ?? "No Project")
                    .font(.title3)
                    .foregroundColor(color ?? .accentColor)

                ForEach(project?.projectItems(using: .score) ?? []) { item in
                    HStack {
                        Circle()
                            .inset(by: 10)
                            .trim(
                                from: 0.0,
                                to: trimToFor(project: project, item: item)
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
                            max: project?.scorePossible ?? 0
                        )
                        .padding(-3)
                    }
                }

                if project?.projectItems.isEmpty ?? true {
                    Text("No items…")
                }

                Spacer()
                    .layoutPriority(1)
            }

            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .stroke(lineWidth: 10)
                .foregroundColor(color ?? .accentColor)
        }
    }

    func trimToFor(project: ProjectV2?, item: ItemV2) -> CGFloat {
        if let project {
            if project.scorePossible > 0 {
                CGFloat(item.scoreTotal) / CGFloat(project.scorePossible)
            } else {
                0.0
            }
        } else {
            0.0
        }
    }
}

struct PointOneKWidget: Widget {
    let kind: String = "PointOneKWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            PointOneKWidgetEntryView(entry: entry)
                .modelContainer(.standard)
        }
        .configurationDisplayName("Project Top Items")
        .description("See the top scored items in your project.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    PointOneKWidget()
} timeline: {
    Provider.Entry(
        date: .now
    )
}
