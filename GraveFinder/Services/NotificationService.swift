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
    
    static func isNotificationsAuthorized(completion: @escaping (Bool)-> Void){
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                completion(false)
            } else if settings.authorizationStatus == .denied {
                completion(false)
            } else if settings.authorizationStatus == .authorized {
                if settings.badgeSetting == .disabled || settings.alertSetting == .disabled || settings.soundSetting == .disabled {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        })
    }
    
    static func requestNotificationAuthorization(for grave:Grave){
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                center.requestAuthorization(options: options) {
                    (didAllow, error) in
                    if !didAllow {
                        return
                    } else {
                        createNotification(for: grave)
                    }
                }
            } else if settings.authorizationStatus == .denied {
                //Open settings
                
                
            } else if settings.authorizationStatus == .authorized {
                if settings.badgeSetting == .disabled || settings.alertSetting == .disabled || settings.soundSetting == .disabled {
                    
                } else {
                    
                }
            }
        })
    }
    static func addNotification(for grave:Grave){
        isNotificationsAuthorized() { authorized in
            if !authorized {
                requestNotificationAuthorization(for: grave)
            } else {
                createNotification(for: grave)
            }
        }
        
        
        //Get notification authorization
        center.requestAuthorization(options: [.alert, .badge, .sound])  {
            success, error in
            if success {
                print("authorization granted")
            } else if let error = error {
                print(error)
                return
            }
        }
    }
    
    static func removeNotification(for grave:Grave){
        center.removePendingNotificationRequests(withIdentifiers: ["grave.id.\(grave.id!)"])
    }
    
    static func createNotification(for grave:Grave){
        let content = UNMutableNotificationContent()
        content.title = "GraveFinder Reminder:"
        content.subtitle = "Idag är dödsdag för \(grave.deceased ?? "en av dina favoriter.")"
        content.body = "En dag att tänka på de som gått bort för tidigt ur våra liv. Och en påminnelse att ta vara på de som finns kvar!"
        content.sound = UNNotificationSound.default
        
        let imageName = "AppIcon"
        
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        
        if let attachment = try? UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none) {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "grave.id.\(grave.id!)", content: content, trigger: trigger)
        
        center.add(request)
    }
}
