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
        SimpleEntry(date: .now)
    }

    func getSnapshot(
        in _: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(date: .now)
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date())

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}
