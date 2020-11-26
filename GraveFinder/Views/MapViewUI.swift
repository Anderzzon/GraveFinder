//
//  MapViewUI.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-25.
//

import SwiftUI
import MapKit

struct MapViewUI: UIViewRepresentable {
    var graves: [GraveLocation]
    let mapViewType: MKMapType
    let region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: true)
        mapView.mapType = mapViewType
        mapView.isRotateEnabled = false
        mapView.addAnnotations(graves)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        print("Graves count: \(graves.count)")
        if graves.count != mapView.annotations.count {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(graves)
        }
        print("Annotations count: \(mapView.annotations.count)")
        print("updating")
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
