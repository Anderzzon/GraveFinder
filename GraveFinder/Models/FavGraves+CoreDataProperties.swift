//
//  FavGraves+CoreDataProperties.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-04.
//
//

import Foundation
import CoreData


extension FavGraves {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavGraves> {
        return NSFetchRequest<FavGraves>(entityName: "FavGraves")
    }

    @NSManaged public var deceased: String?
    @NSManaged public var dateOfDeath: String?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var dateBuried: String?
    @NSManaged public var cemetery: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var graveType: String?

}

extension FavGraves : Identifiable {

}
