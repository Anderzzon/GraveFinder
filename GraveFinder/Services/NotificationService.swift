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
    static func removeNotification(for identifier:String){
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    static func createNotification(for identifier:String, at date:DateComponents, with content:UNMutableNotificationContent, at trigger:UNCalendarNotificationTrigger){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)
    }
    static func checkNotificationExists(for identifier:String, completion: @escaping (Bool) -> Void ){
        center.getPendingNotificationRequests(){
            notifications in
            completion(notifications.contains(where: {$0.identifier == identifier}))
        }
    }
    
}

