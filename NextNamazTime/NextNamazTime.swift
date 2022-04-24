//
//  NextNamazTime.swift
//  NextNamazTime
//
//  Created by Muhammad Shahrukh on 19/04/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct NamazTimeline: TimelineProvider {
    
    func placeholder(in context: Context) -> NamazEntry {
        NamazEntry(date: Date(), namazName: "Fajar", startTime: "04:00", jamatTime: "04:30")
    }

    func getSnapshot(in context: Context, completion: @escaping (NamazEntry) -> Void) {
        let entry = NamazEntry(date: Date(), namazName: "Fajar", startTime: "04:00", jamatTime: "04:30")

        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NamazEntry>) -> Void){
        var entries: [NamazEntry] = []
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        var namazName = ""
        var startTime = ""
        var jamatTime = ""

        //get current month
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM"
        let currMonth = formatter.string(from: currentDate)
        
        //get currnet day
        formatter.dateFormat = "dd"
        let currDate = formatter.string(from: currentDate)
        
        let userDefaults = UserDefaults(suiteName: "group.com.ATSO.Masjid-e-Quba.Widget")

        if let CalendarDict = userDefaults?.value(forKey: "CalendarDict") as? NSDictionary{
            print("CalendarDict", CalendarDict as Any)
            let monthTimings = CalendarDict[currMonth] as? NSDictionary
            let todayTimings = monthTimings?[currDate] as? NSDictionary
            
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentMinutes = Calendar.current.component(.minute, from: Date())

            print("currentHour", currentHour)
            let fajarStart = (todayTimings?[Namaz.fajarStart.rawValue] as! String)
            let fajarJamat = (todayTimings?[Namaz.fajar.rawValue] as! String)
            let zhrStart = (todayTimings?[Namaz.zuharStart.rawValue] as! String)
            let zhrJamat = (todayTimings?[Namaz.zuhar.rawValue] as! String)
            
            let asrStart = (todayTimings?[Namaz.asarStart.rawValue] as! String)
            let asarJamat = (todayTimings?[Namaz.asar.rawValue] as! String)
            
            let magribStart = (todayTimings?[Namaz.maghribStart.rawValue] as! String)
            let magribJamat = (todayTimings?[Namaz.maghrib.rawValue] as! String)
            
            let ishaStart = (todayTimings?[Namaz.ishaStart.rawValue] as! String)
            let ishaJamat = (todayTimings?[Namaz.isha.rawValue] as! String)
            
            let fajarHour = Int(String(fajarJamat.prefix(2))) ?? 0
            let fajarMinutes = Int(String(fajarJamat.suffix(2))) ?? 0
            
            let zuharHour = Int(String(zhrJamat.prefix(2))) ?? 0
            let zuharMinutes = Int(String(zhrJamat.suffix(2))) ?? 0
            
            let asarHour = Int(String(asarJamat.prefix(2))) ?? 0
            let asarMinutes = Int(String(asarJamat.suffix(2))) ?? 0
            
            let magribHour = Int(String(magribJamat.prefix(2))) ?? 0
            let magribMinutes = Int(String(magribJamat.suffix(2))) ?? 0

            let ishaHour = Int(String(ishaJamat.prefix(2))) ?? 0
            let ishaMinutes = Int(String(ishaJamat.suffix(2))) ?? 0

            
            
            if fajarHour > currentHour{
                //Only show this namaz until jamat time
                if fajarMinutes > currentMinutes{
                    namazName = "Fajar"
                    startTime = fajarStart
                    jamatTime = fajarJamat
                }else{
                    namazName = "Zuhar"
                    startTime = zhrStart
                    jamatTime = zhrJamat
                }
            }else if zuharHour > currentHour{
                //Only show this namaz until jamat time
                if zuharMinutes > currentMinutes{
                    namazName = "Zuhar"
                    startTime = zhrStart
                    jamatTime = zhrJamat
                }else{
                    namazName = "Asar"
                    startTime = asrStart
                    jamatTime = asarJamat
                }
            }else if asarHour > currentHour{
                //Only show this namaz until jamat time
                if asarMinutes > currentMinutes{
                    namazName = "Asar"
                    startTime = asrStart
                    jamatTime = asarJamat
                }else{
                    namazName = "Magrib"
                    startTime = magribStart
                    jamatTime = magribJamat
                }
            }else if magribHour > currentHour{
                //Only show this namaz until jamat time
                if magribMinutes > currentMinutes{
                    namazName = "Magrib"
                    startTime = magribStart
                    jamatTime = magribJamat
                }else{
                    namazName = "Isha"
                    startTime = ishaStart
                    jamatTime = ishaJamat
                }
                
            }else if ishaHour > currentHour{
                //Only show this namaz until jamat time
                if ishaMinutes > currentMinutes{
                    namazName = "Isha"
                    startTime = ishaStart
                    jamatTime = ishaJamat
                }else{
                    let nextDate = "\(Int(currDate)! + 1)"
                    if let nextDay = monthTimings?[nextDate] as? NSDictionary{
                        let fajarStart = (nextDay[Namaz.fajarStart.rawValue] as! String)
                        let fajarJamat = (nextDay[Namaz.fajar.rawValue] as! String)
                        namazName = "Fajar"
                        startTime = fajarStart
                        jamatTime = fajarJamat
                    }else{
                        namazName = "Isha"
                        startTime = ishaStart
                        jamatTime = ishaJamat
                    }
                }
                
            }else{
                let nextDate = "\(Int(currDate)! + 1)"
                if let nextDay = monthTimings?[nextDate] as? NSDictionary{
                    let fajarStart = (nextDay[Namaz.fajarStart.rawValue] as! String)
                    let fajarJamat = (nextDay[Namaz.fajar.rawValue] as! String)
                    namazName = "Fajar"
                    startTime = fajarStart
                    jamatTime = fajarJamat
                }else{
                    namazName = "Isha"
                    startTime = ishaStart
                    jamatTime = ishaJamat
                    print("next day fajar time error")
                }
                
            }
        }else{
            namazName = "Loading..."
        }
        
        
        let entry = NamazEntry(date: currentDate, namazName: namazName, startTime: startTime, jamatTime: jamatTime)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
    
}

struct NamazEntry: TimelineEntry {
    let date: Date
    let namazName: String
    let startTime: String
    let jamatTime: String
}

struct NextNamazTimeEntryView : View {
    var entry: NamazTimeline.Entry

    var body: some View {
        ZStack{
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack{
                Text(entry.namazName)
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue-Medium", size: 22))
                Spacer()
                    .frame(height: 8)
                Text("B: " + entry.startTime)
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue-Medium", size: 20))
                Text("J: " + entry.jamatTime)
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue-Medium", size: 20))

            }
        }
    }
}

@main
struct NextNamazTime: Widget {
    let kind: String = "NextNamazTime"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: NamazTimeline()){ entry in
            NextNamazTimeEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Namaz Widget")
        .description("This is a namaz time widget.")
    }
}

struct NextNamazTime_Previews: PreviewProvider {
    static var previews: some View {
        NextNamazTimeEntryView(entry: NamazEntry(date: Date(), namazName: "", startTime: "", jamatTime: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
