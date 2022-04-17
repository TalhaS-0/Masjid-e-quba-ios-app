//
//  CalendarModel.swift
//  Masjid-e-Quba
//
//  Created by Ali Waseem on 1/25/22.
//

import Foundation

// MARK: - Calender
struct CalenderModel: Codable {
    var asar, asarStart, fajar, fajarStart: String?
    var isha, ishaStart, maghrib, maghribStart: String?
    var sunRise: String?
    var zuhar, zuharStart: String?
}

//MARK: - News Feed data
struct NewsFeed:Codable {
    var id: Int?
    var title: Title?
    var excerpt: Content?
    var link: String?
    var date: String?
}

struct Title: Codable {
    var rendered: String?
}

struct Content: Codable {
    var rendered: String?
}
