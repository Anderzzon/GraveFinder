//
//  LocationDelegate.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import Foundation
import MapKit

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            print("Location authorized")
            manager.startUpdatingLocation()
        } else {
            print("Location not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated!")
    }
}
