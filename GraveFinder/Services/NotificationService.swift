//
//  NotificationService.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-11.
//
import Foundation
import UserNotifications
import UIKit
import SwiftUI

class NotificationService {
    enum NotificationType {
        case birthday, deathday, burialday
    }
    static let center = UNUserNotificationCenter.current()
    
    static func getNotificationSettings(completion: @escaping (UNNotificationSettings)->Void){
        return center.getNotificationSettings(completionHandler: completion)
    }
    
    static func requestNotificationAuthorization(completion: @escaping (Bool, Error?)->Void){
        let options:UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options, completionHandler: completion)
    }
    
    static func removeNotification(for grave:Grave, withType type:NotificationType){
        let typeString = getTypeString(type: type)
        center.removePendingNotificationRequests(withIdentifiers: ["grave.\(grave.id!).\(typeString)"])
    }
    
    static func createNotification(for grave:Grave, with type:NotificationType){
        var switchDate:String? {
            switch type {
            case .birthday: return grave.dateOfBirth
            case .deathday: return grave.dateOfDeath
            case .burialday: return grave.dateBuried
            }
        }
        
        guard let date = switchDate else { return }
        if date.isEmpty { return }
        
        let typeString = getTypeString(type: type)
        let content = UNMutableNotificationContent()
        content.title = "GraveFinder Reminder:"
        content.subtitle = "Idag är \(typeString) för \(grave.deceased ?? "en av dina favoriter.")"
        content.sound = UNNotificationSound.default
               
        guard let month = parseDate(for: date, return: "month") else { return }
        guard let day = parseDate(for: date, return: "day") else { return }
        
        var dates = DateComponents()
        dates.hour = 9 //9.AM
        dates.month = month
        dates.day = day
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dates, repeats: true)
        let request = UNNotificationRequest(identifier: "grave.\(grave.id!).\(typeString)", content: content, trigger: trigger)
        
        center.add(request)
        print("request added")
    }
    static func parseDate(for date:String, return request:String) -> Int? {
        let units = date.split(separator: "-")
        let parsedYear = Int(units[0])
        let parsedMonth = Int(units[1])
        let parsedDay = Int(units[2])
        
        guard let day = parsedDay,
              let month = parsedMonth,
              let year = parsedYear else { return nil }
        
        switch request {
        case "day": return day
        case "month": return month
        case "year": return year
        default: return 0
        }
    }
    static func checkNotificationExists(for grave:Grave, withType type:NotificationType, completion: @escaping (Bool) -> Void ){
        center.getPendingNotificationRequests(){
            notifications in
            let typeString = getTypeString(type: type)
            completion(notifications.contains(where: {$0.identifier == "grave.\(grave.id!).\(typeString)"}))
        }
    }
    static func getTypeString(type:NotificationType)->String {
        var typeString:String {
            switch type {
            case .birthday: return "födelsesdag"
            case .deathday: return "dödsdag"
            case .burialday: return "begravningsdag"
            }
        }
        return typeString
    }
}

