//
//  GraveLocation.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-25.
//

import Foundation
import MapKit

final class GraveLocation: NSObject, Identifiable {
    let name: String
    let latitude: Double
    let longitude: Double
    let location: CLLocation
    private let regionRadius: CLLocationDistance = 1000
    let region: MKCoordinateRegion?
    let id = UUID()
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        
        location = CLLocation(latitude: latitude, longitude: longitude)
        region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        super.init()
        
    }
}
extension GraveLocation: MKAnnotation {
  var coordinate: CLLocationCoordinate2D { location.coordinate }
  var title: String? { name }
}
