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
        NotificationService.checkNotificationExists(for: grave, withType: .birthday){
            exists in
            DispatchQueue.main.sync {
            self.notifyBDay = exists
            }
        }
        NotificationService.checkNotificationExists(for: grave, withType: .deathday){
            exists in
            DispatchQueue.main.sync {
            self.notifyDDay = exists
            }
        }
        NotificationService.checkNotificationExists(for: grave, withType: .burialday){
            exists in
            DispatchQueue.main.sync{
            self.notifyBurialDay = exists
            }
        }
    }
    
    func toggleNotification(grave:Grave, type:NotificationService.NotificationType){
        NotificationService.checkNotificationExists(for: grave, withType: type){
                    exists in
                    if !exists {
                        NotificationService.createNotification(for: grave, with: type)
                    } else {
                        NotificationService.removeNotification(for: grave, withType: type)
                    }
        }
    }
}
