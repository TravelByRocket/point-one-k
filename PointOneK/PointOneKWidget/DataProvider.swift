//
//  DataProvider.swift
//  PointOneK
//
//  Created by Bryan Costanza on 16 Mar 2022.
//

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

    func loadProject() -> ProjectOld {
        let dataController = DataController()
        let projects = (try? dataController.container.viewContext.fetch(ProjectOld.fetchRequest())) ?? []
        if let project = dataController.widgetProject {
            return project
        }

        // Use the first project as backup
        if let project = projects.sorted(by: \ProjectOld.projectTitle).first {
            return project
        }

        // Use example as last resort
        return ProjectOld.example
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let project: ProjectOld
}
