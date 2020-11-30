//
//  MapViewUI.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-25.
//

import SwiftUI
import MapKit

struct MapViewUI: UIViewRepresentable {
    var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.27212, longitude: 18.10164), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var graves: [GraveLocation]
    let mapViewType: MKMapType
    //@ObservedObject var viewModel: GravesViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: true)
        mapView.mapType = mapViewType
        mapView.isRotateEnabled = false
        mapView.addAnnotations(graves)
        mapView.delegate = context.coordinator
        let poiCategories: [MKPointOfInterestCategory] = [.evCharger, .gasStation, .nationalPark, .park, .parking, .publicTransport, .restroom, .store]
        let poiFilter = MKPointOfInterestFilter(including: poiCategories)
        mapView.pointOfInterestFilter = poiFilter
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        print("Graves count: \(graves.count)")
        if graves.count != mapView.annotations.count {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(graves)
            
        }
        if graves.count == 1 {
            mapView.setRegion(graves[0].region!, animated: true)
        }
        print("Annotations count: \(mapView.annotations.count)")
        print("updating")
        print("Region \(region)")
        mapView.mapType = mapViewType
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init()
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let graveAnnotation = annotation as? GraveLocation else {
                return nil
            }
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Dead") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: graveAnnotation, reuseIdentifier: "Grave")
            annotationView.canShowCallout = true
            annotationView.glyphText = "⚰️"
            annotationView.markerTintColor = .lightGray
            annotationView.titleVisibility = .visible
            return annotationView
        }
    }
    
    
}