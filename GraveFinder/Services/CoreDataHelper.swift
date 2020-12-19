//
//  CoreDataHelper.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-10.
//

import Foundation
import CoreData

struct CoreDataHelper {
    
    func addToCoreData(grave:Grave){
        let context = PersistenceController.shared.context
        let newFav = FavGraves(context: context)
        newFav.id = grave.id ?? ""
        newFav.deceased = grave.deceased ?? "Unnamed".localized()
        newFav.cemetery = grave.cemetery ??  "Unspecified".localized()
        newFav.dateBuried = grave.dateBuried ??  "Unspecified".localized()
        newFav.dateOfBirth = grave.dateOfBirth ??  "Unspecified".localized()
        newFav.dateOfDeath = grave.dateOfDeath ??  "Unspecified".localized()
        newFav.graveType = grave.graveType ??  "Unspecified".localized()
        newFav.latitude = grave.latitude!
        newFav.longitude = grave.longitude!
        newFav.block = grave.block ?? "Unspecified".localized()
        PersistenceController.shared.saveContext()
        
    }
    
    func removeFromCoreData(grave:Grave) {
        let context = PersistenceController.shared.context
        do {
            let request:NSFetchRequest<FavGraves> = FavGraves.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", grave.id!)
            request.predicate = predicate
            let results = try context.fetch(request)
            
            if let index = results.firstIndex(where: {$0.id == grave.id}){
                context.delete(results[index])
            }
            
            PersistenceController.shared.saveContext()
            
        } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.saveContext()
    }
    
}
