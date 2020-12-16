//
//  GraveViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-16.
//

import Foundation
import Combine
import SwiftUI

class GravesViewModel:ObservableObject {
    
    @State var showNotificationAlert = false
    
    @Published var notificationOptionsPresenting:Bool = false
    @Published var alert:Alert? = nil
    @Published var alertIsPresented:Bool = false
    @Published var locationMissing:Bool
    
    @Binding var selectedGraves:[Grave] //Array to support posibility of multiple graves on map later
    @Binding var selectedGrave:Grave?
    @Binding var sheetPos:SheetPosition
    
    private var coreDataHelper = CoreDataHelper()
    var grave:Grave
    
    init(grave:Grave, selectedGraves:Binding<[Grave]>, sheetPos:Binding<SheetPosition>, selectedGrave:Binding<Grave?>, locationMissing:Bool){
        self.grave = grave
        self._selectedGraves = selectedGraves
        self._sheetPos = sheetPos
        self._selectedGrave = selectedGrave
        self.locationMissing = locationMissing
    }
    
    func showNotificationOptions(){
        NotificationService.getSettings(){ settings in
            switch settings.authorizationStatus {
            case .authorized, .ephemeral:
                DispatchQueue.main.async {
                    self.notificationOptionsPresenting = true
                }
            case .denied:
                DispatchQueue.main.async{
                    self.setAlert(alert: Alert(
                                        title: Text("Notification Service").font(.system(.title)),
                                        message: Text("Notifikationer måste aktiveras i inställningarna"),
                                        primaryButton: .default( Text("Inställningar"),
                                                                 action: {
                                                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                                                 }),
                                        secondaryButton: .cancel()))
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    NotificationService.requestNotificationAuthorization(){
                        didAllow, error in
                        if !didAllow {
                            return
                        } else {
                            self.notificationOptionsPresenting = true
                        }
                    }
                }
            default: break
            }
        }
    }
    //Used for adding grave to array to show it on map
    func selectGrave() {
        selectedGraves.removeAll()
        selectedGraves.append(self.grave)
    }
    func saveToCoreData() {
        coreDataHelper.addToCoreData(grave: grave)
    }
    func deleteFromCoreData() {
        coreDataHelper.removeFromCoreData(grave: grave)
    }
    func checkIsNotifiable()->Bool {
        let firstCheck = grave.dateOfBirth != nil && !grave.dateOfBirth!.isEmpty
        let secondCheck = grave.dateOfDeath != nil && !grave.dateOfDeath!.isEmpty
        let thirdCheck = grave.dateBuried != nil && !grave.dateBuried!.isEmpty
        return firstCheck || secondCheck || thirdCheck
    }
    func setAlert(alert:Alert){
        self.alert = alert
        self.alertIsPresented = true
    }
    func removeAlert(){
        self.alertIsPresented = false
        self.alert = nil
    }
    func setSheetPos(to pos:SheetPosition){
        self.sheetPos = pos
    }
    func setSelectedGrave(){
        self.selectedGrave = self.grave
    }
    func checkIfHighlight()->Bool{
        return self.selectedGrave?.id == self.grave.id
    }
    func removeAllPendingNotifications(){
        NotificationService.removeNotification(for: "grave.\(grave.id!).födelsesdag")
        NotificationService.removeNotification(for: "grave.\(grave.id!).dödsdag")
        NotificationService.removeNotification(for: "grave.\(grave.id!).begravningsdag")
    }
}
