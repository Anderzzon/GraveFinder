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
        center.removePendingNotificationRequests(withIdentifiers: ["grave.\(grave.id!).\(type)"])
    }
    
    static func createNotification(for grave:Grave, with type:NotificationType){
        
        let typeString = getTypeString(type: type)
        
        let content = UNMutableNotificationContent()
        content.title = "GraveFinder Reminder:"
        content.subtitle = "Idag är \(typeString) för \(grave.deceased ?? "en av dina favoriter.")"
        content.sound = UNNotificationSound.default
               
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "grave.\(grave.id!).\(typeString)", content: content, trigger: trigger)
        
        center.add(request)
        print("request added")
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

