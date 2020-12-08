//
//  GraveLocation.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-25.
//

import Foundation
import MapKit

final class GraveLocation: NSObject, Identifiable {
    private let name: String
    private let life: String
    private let latitude: Double
    private let longitude: Double
    private let location: CLLocation
    private let regionRadius: CLLocationDistance = 1000
    let region: MKCoordinateRegion?
    let id = UUID()
    
    init(name: String, latitude: Double, longitude: Double, birth: String, death: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        
        life = birth + " - " + death
        
        location = CLLocation(latitude: latitude, longitude: longitude)
        region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        super.init()
    }
    
    init(grave:Grave) {
        self.name = grave.deceased ?? "Okänd"
        
        let birthday = grave.dateOfBirth ?? ""
        let deathday = grave.dateOfDeath ?? ""
        
        self.life = birthday + " - " + deathday
        
        let latlng = GraveLocation.getLocation(for: grave)
        
        self.latitude = latlng.latitude
        self.longitude = latlng.longitude
        
        self.location = CLLocation(latitude: latlng.latitude, longitude: latlng.longitude)
        self.region = MKCoordinateRegion(center: self.location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        super.init()
    }
    static func getLocation(for grave:Grave)->(latitude:Double, longitude:Double){
        if grave.latitude != nil && grave.longitude != nil {
            return (latitude:grave.latitude!, longitude:grave.longitude!)
        } else if grave.cemetery != nil && grave.graveType == "memorial" {
            return GravesViewModel.getMemorialLocation(for: grave.cemetery!)
        } else {
            return GravesViewModel.getCemeteryLocation(for: grave.cemetery!)
        }
    }
}
extension GraveLocation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D { location.coordinate }
    var title: String? { name }
    var subtitle: String? { life }
}
