//
//  GoldCalculator.swift
//  GoldCalculator
//
//  Created by 강래민 on 2021/02/09.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct GoldCalculatorEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("괴산기 바로가기 !")
    }
}

@main
struct GoldCalculator: Widget {
    let kind: String = "GoldCalculator"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GoldCalculatorEntryView(entry: entry)
        }
        .configurationDisplayName("괴산기 열기")
        .description("눈에 띄는 괴산기 위젯")
    }
}

struct GoldCalculator_Previews: PreviewProvider {
    static var previews: some View {
        GoldCalculatorEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
