//
//  DataProvider.swift
//  PointOneK
//
//  Created by Bryan Costanza on 16 Mar 2022.
//

import SwiftData
import WidgetKit

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: .now, project: .example)
    }

    func getSnapshot(
        in _: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(date: Date(), project: loadProject())
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), project: loadProject())

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadProject() -> Project {
//        let projects = (try? context.fetch(FetchDescriptor<Project>())) ?? []
//        if let project = dataController.widgetProject {
//            return project
//        }

        // Use the first project as backup
//        if let project = projects.sorted(by: \Project.projectTitle).first {
//            return project
//        }

        // Use example as last resort
        .example
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let project: Project
}
