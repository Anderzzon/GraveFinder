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
        
        var typeString:String {
            switch type {
            case .birthday:  return "birthday"
            case .deathday: return "deathday"
            case .burialday: return "burialday"
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "GraveFinder Reminder:"
        content.subtitle = "Idag är dödsdag för \(grave.deceased ?? "en av dina favoriter.")"
        content.body = "En dag att tänka på de som gått bort för tidigt ur våra liv. Och en påminnelse att ta vara på de som finns kvar!"
        content.sound = UNNotificationSound.default
       
        //TODO: Attach image to content.attachments
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "grave.\(grave.id!).\(typeString)", content: content, trigger: trigger)
        
        center.add(request)
        print("request added")
    }
    static func checkNotificationExists(for grave:Grave, withType type:NotificationType, completion: @escaping (Bool) -> Void ){
        center.getPendingNotificationRequests(){
            notifications in
            
            notifications.forEach({notification in
                                    print(notification)})
            
        }
    }
}

enum NotificationType {
    case birthday, deathday, burialday
}
