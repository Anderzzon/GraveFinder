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
    func graveHasBirthday()->Bool {
        return grave.dateOfBirth != nil 
    }
    func initToggleValues(){
        print("init")
        NotificationService.checkNotificationExists(for: grave, withType: .birthday){
            exists in
            print(exists)
            self.notifyBDay = exists
        }
        NotificationService.checkNotificationExists(for: grave, withType: .deathday){
            exists in
            print(exists)
            self.notifyDDay = exists
        }
        NotificationService.checkNotificationExists(for: grave, withType: .burialday){
            exists in
            print(exists)
            self.notifyBurialDay = exists
        }
    }
    
    func toggleNotification(grave:Grave, type:NotificationService.NotificationType){
        print("toggle prior check")
        
        NotificationService.checkNotificationExists(for: grave, withType: type){
            exists in
            
            print("toggle", exists)
            
            if !exists {
                print("create")
                NotificationService.createNotification(for: grave, with: type)
            } else {
                print("remove")
                NotificationService.removeNotification(for: grave, withType: type)
            }
        }
    }
}
