//
//  Enums.swift
//  ShifaELock
//
//  Created by Ali Waseem on 8/29/21.
//

import UIKit


enum CredentialsInputStatus {
    case Correct
    case Incorrect
}

enum Month : String {
    case Jan = "01"
    case Feb = "02"
    case Mar = "03"
    case Apr = "04"
    case May = "05"
    case Jun = "06"
    case Jul = "07"
    case Aug = "08"
    case Sep = "09"
    case Oct = "10"
    case Nov = "11"
    case Dec = "12"
 }

enum Namaz : String {
    case fajar = "fajar"
    case fajarStart = "fajarStart"
    case sunRise = "sunRise"
    case zuhar = "zuhar"
    case zuharStart = "zuharStart"
    case asar = "asar"
    case asarStart = "asarStart"
    case maghrib = "maghrib"
    case maghribStart = "maghribStart"
    case isha = "isha"
    case ishaStart = "ishaStart"
}



enum Authorization : String {
    case username = "email_or_phone"
    case password = "password"
    case grant_type = "grant_type"
    case Authorization = "Authorization"
    case contentType = "application/x-www-form-urlencoded"
}

enum UserType: String {
    case stationUser = "station_user"
}

enum TruckLoading: String {
    case wayBill = "waybill_number"
}


enum OrderType: String {
    case Bike = "SNABB"
    case Truck = "SNABB STOR"
}
