//
//  Grave.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
struct Grave:Codable, Hashable {
    let deceased:String?
    let dateBuried:String?
    let dateOfBirth:String?
    let dateOfDeath:String?
    let cemetery:String?
    let location:Location
    
    enum CodingKeys: String, CodingKey {
        case deceased = "label"
        case dateBuried = "buriedDate"
        case dateOfBirth = "birthDate"
        case dateOfDeath = "deathDate"
        case location = "coordinates"
        case cemetery
    }
}
