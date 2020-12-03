//
//  Grave.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
import MapKit

struct Grave:Decodable, Hashable, Identifiable {
    let deceased:String?
    let dateBuried:String?
    let dateOfBirth:String?
    let dateOfDeath:String?
    let cemetery:String?
    let graveType:String?
    let latitude:Double?
    let longitude:Double?
    let id:String?
    
    enum CodingKeys: String, CodingKey {
        case deceased = "label"
        case dateBuried = "buriedDate"
        case dateOfBirth = "birthDate"
        case dateOfDeath = "deathDate"
        case cemetery
        case graveType = "blockType"
        case location = "coordinates"
        case id
        
        enum LocationKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
        }
    }
    
    init(from decoder:Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        id = try? container.decode(String.self, forKey: .id)
        deceased = try? container.decode(String.self, forKey: .deceased)
        dateBuried = try? container.decode(String.self, forKey: .dateBuried)
        dateOfBirth = try? container.decode(String.self, forKey: .dateOfBirth)
        dateOfDeath = try? container.decode(String.self, forKey: .dateOfDeath)
        cemetery = try? container.decode(String.self, forKey: .cemetery)
        graveType = try? container.decode(String.self, forKey: .graveType)
        
        let locationContainer = try container.nestedContainer(keyedBy: CodingKeys.LocationKeys.self, forKey: .location)
        
        latitude = try? locationContainer.decode(Double.self, forKey: .latitude)
        longitude = try? locationContainer.decode(Double.self, forKey: .longitude)
        
        }
    func isLocatable() -> Bool {
        let firstCheck = self.latitude != nil && self.longitude != nil
        let secondCheck = self.cemetery != nil && self.graveType == "memorial"
        let thirdCheck = self.cemetery != nil
        
        return firstCheck || secondCheck || thirdCheck
    }
}
