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
        newFav.deceased = grave.deceased ?? NSLocalizedString("unnamed", comment: "Unnamed")
        newFav.cemetery = grave.cemetery ??  NSLocalizedString("unspecified", comment: "Unspecified")
        newFav.dateBuried = grave.dateBuried ??  NSLocalizedString("unspecified", comment: "Unspecified")
        newFav.dateOfBirth = grave.dateOfBirth ??  NSLocalizedString("unspecified", comment: "Unspecified")
        newFav.dateOfDeath = grave.dateOfDeath ??  NSLocalizedString("unspecified", comment: "Unspecified")
        newFav.graveType = grave.graveType ??  NSLocalizedString("unspecified", comment: "Unspecified")
        newFav.latitude = grave.latitude!
        newFav.longitude = grave.longitude!
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
