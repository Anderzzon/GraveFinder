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
