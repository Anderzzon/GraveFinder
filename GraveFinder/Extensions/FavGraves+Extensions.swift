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

        PersistenceController.shared.saveContext()
    }
    
    func removeFromCoreData() {
        let context = PersistenceController.shared.context
        context.delete(self)
        PersistenceController.shared.saveContext()
    }
    
}
