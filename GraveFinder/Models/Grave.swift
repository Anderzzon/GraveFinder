//
//  Grave.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
import MapKit

class Grave:NSObject, Decodable, Identifiable {
    let deceased:String?
    let dateBuried:String?
    let dateOfBirth:String?
    let dateOfDeath:String?
    let cemetery:String?
    let graveType:String?
    let latitude:Double?
    let longitude:Double?
    private let life:String?
    private let location: CLLocation
    private let regionRadius: CLLocationDistance = 1000
    let region: MKCoordinateRegion?
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
    override init(){
        self.region = nil
        self.life = "None"
        self.deceased = "John Doe"
        self.dateBuried = "YYYY-MM-DD"
        self.dateOfBirth = "YYYY-MM-DD"
        self.dateOfDeath = "YYYY-MM-DD"
        self.cemetery = "Unknown"
        self.graveType = "Unknown"
        self.location = CLLocation()
        self.latitude = nil
        self.longitude = nil
        self.id = "123"
    }
    init(favorite:FavGraves){
        deceased = favorite.deceased
        dateBuried = favorite.dateBuried
        dateOfBirth = favorite.dateOfBirth
        dateOfDeath = favorite.dateOfDeath
        cemetery = favorite.cemetery
        graveType = favorite.graveType
        latitude = favorite.latitude
        longitude = favorite.longitude
        let birthday = dateOfBirth ?? ""
        let deathday = dateOfDeath ?? ""
        life = birthday + " - " + deathday
        
        // init map annotation values
        location = CLLocation(latitude: latitude!, longitude: longitude!)
        region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        id = favorite.id
    }
    required init(from decoder:Decoder) throws {
        
        //Parsing JSON with decoder
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
        
        // If lat/lng is nil try to fetch locatin from static alternatives
        let latlng = Grave.getLatLng(tempLat: tempLat, tempLong: tempLong, cemetery: cemetery, graveType: graveType)
        self.latitude = latlng.latitude
        self.longitude = latlng.longitude
        
        // init map annotation values
        self.location = CLLocation(latitude: latlng.latitude ?? 0, longitude: latlng.longitude ?? 0)
        self.region = MKCoordinateRegion(center: self.location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //init annotation marker values
        let birthday = dateOfBirth ?? ""
        let deathday = dateOfDeath ?? ""
        self.life = birthday + " - " + deathday
        
        super.init()
        
    }
    func isLocatable() -> Bool {
        let firstCheck = self.latitude != nil && self.longitude != nil
        let secondCheck = self.cemetery != nil && self.graveType == "memorial"
        let thirdCheck = self.cemetery != nil
        
        return firstCheck || secondCheck || thirdCheck
    }
    func addToCoreData(){
            
        let context = PersistenceController.shared.context
            
            let newFav = FavGraves(context: context)
            newFav.id = self.id ?? ""
            newFav.deceased = self.deceased ?? "Ej namngiven"
            newFav.cemetery = self.cemetery ?? "Ej specificerad"
            newFav.dateBuried = self.dateBuried ?? "Ej specificerad"
            newFav.dateOfBirth = self.dateOfBirth ?? "Ej specificerad"
            newFav.dateOfDeath = self.dateOfDeath ?? "Ej specificerad"
            newFav.graveType = self.graveType ?? "Ej specificerad"
            newFav.latitude = self.latitude!
            newFav.longitude = self.longitude!

            PersistenceController.shared.saveContext()
        
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

extension Grave:MKAnnotation {
    var coordinate: CLLocationCoordinate2D { location.coordinate }
    var title:String? { deceased }
    var subtitle:String? { life }
    
}
