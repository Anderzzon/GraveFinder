//
//  NotificationSelectionViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-14.
//

import Foundation
import Combine
import SwiftUI

class NotificationSelectionViewModel:ObservableObject {
    
    @Published var notifyBDay = false
    @Published var notifyDDay = false
    @Published var notifyBurialDay = false
    @Published var alertIsPresented:Bool = false
    @Published private(set) var alert:Alert? = nil
    
    enum NotificationDate {
        case birthday, deathday, burialday
    }
    
    var grave:Grave
    
    init(grave:Grave){
        self.grave = grave
        initToggleValues()
    }
    func graveHasBirthday() -> Bool {
        guard let birthday = grave.dateOfBirth else { return false }
        return isDateParsable(date: birthday)
    }
    func graveHasDeathday() -> Bool {
        guard let deathday = grave.dateOfDeath else { return false }
        return isDateParsable(date: deathday)
    }
    func graveHasBurialDay() -> Bool {
        guard let burialday = grave.dateBuried else { return false }
        return isDateParsable(date: burialday)
    }
    func isDateParsable(date:String) -> Bool {
        let units = date.split(separator: "-")
        guard let _ = Int(units[0]) else { return false }
        guard let _ = Int(units[1]) else { return false }
        guard let _ = Int(units[2]) else { return false }
        return true
    }
    func initToggleValues(){
        NotificationService.checkNotificationExists(for: getID(for: self.grave, with: .birthday)){
            exists in
            DispatchQueue.main.sync {
                self.notifyBDay = exists
            }
        }
        NotificationService.checkNotificationExists(for: getID(for: self.grave, with: .deathday)){
            exists in
            DispatchQueue.main.sync {
                self.notifyDDay = exists
            }
        }
        NotificationService.checkNotificationExists(for: getID(for: self.grave, with: .burialday)){
            exists in
            DispatchQueue.main.sync{
                self.notifyBurialDay = exists
            }
        }
    }
    func getDayTypeForNotification(type:NotificationDate)->String {
        var typeString:String {
            switch type {
            case .birthday: return "födelsesdag"
            case .deathday: return "dödsdag"
            case .burialday: return "begravningsdag"
            }
        }
        return typeString
    }
    func getID(for grave:Grave, with type:NotificationDate)->String{
        return "grave.\(grave.id!).\(getDayTypeForNotification(type: type))"
    }
    func toggleNotification(isOn:Bool, grave:Grave, type:NotificationDate){
        NotificationService.getSettings(){ settings in
            switch settings.authorizationStatus {
            case .authorized, .ephemeral:
                if isOn {
                    self.createNotification(for: grave, with: type)
                } else {
                    self.removeNotification(for: grave, with: type)
                }
                
            case .denied:
                DispatchQueue.main.async {
                    self.setAlert(alert: Alert(
                                title: Text("Notification Service").font(.system(.title)),
                                message:Text("Notifikationer måste aktiveras i inställningar."),
                                primaryButton: .default(
                                    Text("Inställningar"), action: {
                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                        self.removeAlert()
                                }),
                                secondaryButton: .cancel()))
                    
                }
            case .notDetermined:
                NotificationService.requestNotificationAuthorization(){
                    didAllow, error in
                    if !didAllow {
                        return
                    } else {
                        self.createNotification(for: grave, with: type)
                    }
                }
            default: break
            }
        }
    }
    func createNotification(for grave:Grave, with type:NotificationDate){
        guard let dates = getDateComponents(for: grave, with: type) else { return }
        let identifier = getID(for: grave, with: type)
        let content = getContent(for: grave, with: type)
        let trigger = getNotificationTrigger(for: dates)
        NotificationService.createNotification(for: identifier, at: dates, with: content, at: trigger)
    }
    func removeNotification(for grave:Grave, with type:NotificationDate){
        let identifier = getID(for: grave, with: type)
        NotificationService.removeNotification(for: identifier)
    }
    func getDateComponents(for grave:Grave, with type:NotificationDate) -> DateComponents? {
        guard let requestedDate = getDateForNotificationType(for: type) else { return nil}
        if requestedDate.isEmpty { return nil}
        
        guard let month = parseDate(for: requestedDate, return: "month") else { return nil}
        guard let day = parseDate(for: requestedDate, return: "day") else { return nil}
        
        var dates = DateComponents()
        dates.hour = 9 //9.AM
        dates.month = month
        dates.day = day
        
        return dates
    }
    func getNotificationTrigger(for dates:DateComponents)->UNCalendarNotificationTrigger {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dates, repeats: true)
        return trigger
    }
    func getContent(for grave:Grave, with type:NotificationDate) -> UNMutableNotificationContent {
        let notificationDay = getDayTypeForNotification(type: type)
        let content = UNMutableNotificationContent()
        content.title = "GraveFinder Reminder:"
        content.subtitle = "Idag är \(notificationDay) för \(grave.deceased ?? "en av dina favoriter.")"
        content.sound = UNNotificationSound.default
        return content
    }
    func parseDate(for date:String, return request:String) -> Int? {
        let units = date.split(separator: "-")
        guard let year = Int(units[0]) else { return nil }
        guard let month = Int(units[1]) else { return nil }
        guard let day = Int(units[2]) else { return nil }
        
        switch request {
        case "day": return day
        case "month": return month
        case "year": return year
        default: return nil
        }
    }
    func getDateForNotificationType(for type: NotificationDate) -> String? {
        var switchOnDate:String? {
            switch type {
            case .birthday: return grave.dateOfBirth
            case .deathday: return grave.dateOfDeath
            case .burialday: return grave.dateBuried
            }
        }
        return switchOnDate
    }
    func setAlert(alert:Alert){
        self.alert = alert
        self.alertIsPresented = true
    }
    func removeAlert(){
        self.alertIsPresented = false
        self.alert = nil
    }
}

