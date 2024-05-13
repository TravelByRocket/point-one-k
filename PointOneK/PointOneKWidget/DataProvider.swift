//
//  DataProvider.swift
//  PointOneK
//
//  Created by Bryan Costanza on 16 Mar 2022.
//

import WidgetKit
import SwiftData

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    @MainActor
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: .now, project: .example)
    }

    @MainActor
    func getSnapshot(
        in _: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(date: Date(), project: loadProject())
        completion(entry)
    }

    @MainActor
    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), project: loadProject())

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    @MainActor 
    func loadProject() -> Project2 {
        let dataController = DataController()
        let projects = (try? dataController.modelContainer.mainContext.fetch(FetchDescriptor<Project2>())) ?? []
        if let project = dataController.widgetProject {
            return project
        }

        // Use the first project as backup
        if let project = projects.sorted(by: \Project2.projectTitle).first {
            return project
        }

        // Use example as last resort
        return .example
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let project: Project2
}
