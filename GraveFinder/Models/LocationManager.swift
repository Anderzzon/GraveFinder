//
//  LocationDelegate.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import Foundation
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject {
    
    var locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var userHasRequestedDirections = false
    var startLocation: CLLocation?
    var endLocation: CLLocation?
    
    @Published var directions = [String]()
    @Published var locationString = ""
    @Published var routePolyline: MKPolyline?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            print("Location authorized")
            locationManager.startUpdatingLocation()
        } else {
            print("Location not authorized")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func requestDirections(for grave: GraveLocation) {
        //print("requesting Directions")
        endLocation = grave.location
        //print("endloaction: \(endLocation)")
        startLocationServices()
        userHasRequestedDirections = true
    }

    func fetchDirections() {
        //print("Fetching directions")
        //print("Start: \(startLocation)")
        //print("End: \(endLocation)")
        guard let startLocation = startLocation, let endLocation = endLocation else {
            print("failed to set start/stop location")
            return }
        let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startLocation.coordinate))
        let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: endLocation.coordinate))
        
        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = endMapItem
        request.requestsAlternateRoutes = false
        request.transportType = .any
        let mapDirections = MKDirections(request: request)
        mapDirections.calculate { [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let route = response?.routes.first {
                self?.routePolyline = route.polyline
                
                let formatter = MKDistanceFormatter()
                for step in route.steps {
                    let distance = formatter.string(fromDistance: step.distance)
                    if step.instructions.isEmpty { continue }
                    self?.directions.append(step.instructions + " - \(distance.description)")
                    //print(step.instructions)
                }
                
            }
        }
    }
    func clearDirections() {
        directions.removeAll()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            print("Location authorized")
            locationManager.startUpdatingLocation()

        }
    }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("location Manager")
          guard let latest = locations.first else { return }
          if userHasRequestedDirections {
            startLocation = latest
            fetchDirections()
            userHasRequestedDirections = false
            print(latest)
          }
          if previousLocation == nil {
            previousLocation = latest
          } else {
            let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
            previousLocation = latest
            locationString = "You are \(Int(distanceInMeters)) meters from your start point."
          }
          print(latest)
        }
        
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }
        switch clError {
        case CLError.denied:
            print("Location access denied")
        default:
            print("cLError")
        }
        
    }
}
