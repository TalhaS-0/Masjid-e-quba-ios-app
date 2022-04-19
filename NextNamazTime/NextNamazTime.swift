//
//  NextNamazTime.swift
//  NextNamazTime
//
//  Created by Muhammad Shahrukh on 19/04/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), namazName: "", startTime: "", jamatTime: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), namazName: "", startTime: "", jamatTime: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let userDefaults = UserDefaults(suiteName: "group.com.ATSO.Masjid-e-Quba")
        let namazName = userDefaults?.value(forKey: "NamazName") as? String ?? ""
        let startTime = userDefaults?.value(forKey: "StartTime") as? String ?? "No Time"
        let jamatTime = userDefaults?.value(forKey: "JamatTime") as? String ?? "No Time"
        print("startTime", startTime)
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, namazName: namazName, startTime: startTime, jamatTime: jamatTime, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let namazName: String
    let startTime: String
    let jamatTime: String
    let configuration: ConfigurationIntent
}

struct NextNamazTimeEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack{
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack{
                Text(entry.namazName)
                    .foregroundColor(Color.white)
                    .font(.system(size: 24))
                Text("B: " + entry.startTime)
                    .foregroundColor(Color.white)
                    .font(.system(size: 22))
                Text("J: " + entry.jamatTime)
                    .foregroundColor(Color.white)
                    .font(.system(size: 22))
            }
        }
    }
}

@main
struct NextNamazTime: Widget {
    let kind: String = "NextNamazTime"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextNamazTimeEntryView(entry: entry)
        }
        .configurationDisplayName("Namaz Widget")
        .description("This is an namaz time widget.")
    }
}

struct NextNamazTime_Previews: PreviewProvider {
    static var previews: some View {
        NextNamazTimeEntryView(entry: SimpleEntry(date: Date(), namazName: "", startTime: "", jamatTime: "", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
