//
//  Grave.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
import MapKit

struct Grave:Codable, Hashable, Identifiable {
    let deceased:String?
    let dateBuried:String?
    let dateOfBirth:String?
    let dateOfDeath:String?
    let cemetery:String?
    let graveType:String?
    let location:Location
    let id:String
    
    enum CodingKeys: String, CodingKey {
        case deceased = "label"
        case dateBuried = "buriedDate"
        case dateOfBirth = "birthDate"
        case dateOfDeath = "deathDate"
        case cemetery
        case graveType = "blockType"
        case location = "coordinates"
        case id
    }
}
