//
//  FavGraves+Extensions.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-09.
//

import Foundation
import CoreData
import UIKit

extension FavGraves {
    
    static func addGrave(grave:Grave) {
        
        let context = PersistenceController.shared.context
        
        let newFav = FavGraves(context: context)
        newFav.id = grave.id ?? ""
        newFav.deceased = grave.deceased ?? "Ej namngiven"
        newFav.cemetery = grave.cemetery ?? "Ej specificerad"
        newFav.dateBuried = grave.dateBuried ?? "Ej specificerad"
        newFav.dateOfBirth = grave.dateOfBirth ?? "Ej specificerad"
        newFav.dateOfDeath = grave.dateOfDeath ?? "Ej specificerad"
        newFav.graveType = grave.graveType ?? "Ej specificerad"
        newFav.latitude = grave.latitude!
        newFav.longitude = grave.longitude!
//        do {
//            try moc.save()
//        } catch {
//           //TODO: Handle Error
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
        //return newFav
        PersistenceController.shared.saveContext()
    }
//    static func saveChanges() {
//        PersistenceController.shared.saveContext()
//    }
    
}
