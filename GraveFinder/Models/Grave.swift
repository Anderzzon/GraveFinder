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
        
        let tempLat = try? locationContainer.decode(Double.self, forKey: .latitude)
        let tempLong = try? locationContainer.decode(Double.self, forKey: .longitude)
        
        let latlng = Grave.getLatLng(tempLat: tempLat, tempLong: tempLong, cemetery: cemetery, graveType: graveType)
        
        self.latitude = latlng.latitude
        self.longitude = latlng.longitude
        
        }
    func isLocatable() -> Bool {
        let firstCheck = self.latitude != nil && self.longitude != nil
        let secondCheck = self.cemetery != nil && self.graveType == "memorial"
        let thirdCheck = self.cemetery != nil
        
        return firstCheck || secondCheck || thirdCheck
    }
    static func getLatLng(tempLat:Double?, tempLong:Double?, cemetery:String?, graveType:String?)->(latitude:Double?, longitude:Double?){
        if tempLat == nil && tempLong == nil && cemetery == nil {
            return (latitude:nil, longitude:nil)
        } else if tempLat != nil && tempLong != nil {
            return (latitude:tempLat, longitude:tempLong)
        } else if cemetery != nil && graveType == "memorial" {
            return GravesViewModel.getMemorialLocation(for: cemetery!)
        } else {
            return GravesViewModel.getCemeteryLocation(for: cemetery!)
        }
    }
}
