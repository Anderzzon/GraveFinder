//
//  MapViewUI.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-25.
//

import SwiftUI
import MapKit

struct MapViewUI: UIViewRepresentable {
    @Binding var showGraveDetail: Bool
    //var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.27212, longitude: 18.10164), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var graves: [Grave]
    let mapViewType: MKMapType
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        //mapView.setRegion(region, animated: true)
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

            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(graves)
        

        if graves.count == 1 {
            mapView.showsUserLocation = true
        
            mapView.setRegion(graves[0].region!, animated: true)
            
        }
        
        print("Annotations count: \(mapView.annotations.count)")
        print("updating")
        //print("Region \(region)")
        mapView.mapType = mapViewType
    }
    
    func makeCoordinator() -> MapCoordinator {
        Coordinator(self)
    }
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewUI
        init(_ parent: MapViewUI) {
            self.parent = parent
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let graveAnnotation = annotation as? Grave else {
                return nil
            }
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Dead") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: graveAnnotation, reuseIdentifier: "Grave")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.glyphImage = UIImage(named: "gravemarker")
            annotationView.glyphTintColor = .black
            annotationView.markerTintColor = .lightGray
            annotationView.titleVisibility = .visible
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            print("Annotiations pressed")
            parent.showGraveDetail = true
            
        }
    }
    

    
    
}
