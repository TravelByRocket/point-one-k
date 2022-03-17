//
//  DataProvider.swift
//  PointOneK
//
//  Created by Bryan Costanza on 16 Mar 2022.
//

import WidgetKit

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), project: Project.example)
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void) {
            let entry = SimpleEntry(date: Date(), project: loadProject())
            completion(entry)
        }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), project: loadProject())

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadProject() -> Project {
        let dataController = DataController()
        let projects = (try? dataController.container.viewContext.fetch(Project.fetchRequest())) ?? []
        if let project = dataController.widgetProject {
            return project
        }

        // Use the first project as backup
        if let project = projects.sorted(by: \Project.projectTitle).first {
            return project
        }

        // Use example as last resort
        return Project.example
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let project: Project
}
