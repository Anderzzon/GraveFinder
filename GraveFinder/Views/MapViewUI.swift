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
    @State var route: MKPolyline?
    
    @Binding var showDirections:Bool
    @ObservedObject var locationManager: LocationManager
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
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
        print("Updating")
        //print("Graves count: \(graves.count)")
        if graves.count != mapView.annotations.count {

            print("Graves count != annotation count")
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(graves)
            
        }
        if graves.count == 1 {
            mapView.setRegion(graves[0].region!, animated: true)
            locationManager.requestDirections(for: graves[0])
            if showDirections {
                //locationManager.clearDirections()
                if let route = route {
                    
                    DispatchQueue.main.async {
                        mapView.removeOverlay(route)
                        print("Removing route layer")
                    }
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.route = locationManager.routePolyline
                    print("Show directions")
                    
                    if let route = route {
                        print("adding overlay")
                        mapView.addOverlay(route)
                    }
                    showDirections = false
                }
            }
        }

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
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
            print(parent.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            if overlay is MKPolyline {
                let polyline = MKPolylineRenderer(overlay: overlay)
                polyline.strokeColor = UIColor.blue
                polyline.lineWidth = 3.0
                return polyline
            }
            return MKOverlayRenderer(overlay: overlay)
            
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let graveAnnotation = annotation as? GraveLocation else {
                return nil
            }
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Dead") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: graveAnnotation, reuseIdentifier: "Dead")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.glyphText = "⚰️"
            annotationView.markerTintColor = .lightGray
            annotationView.titleVisibility = .visible
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            //guard let placemark = view.annotation as? MKAnnotation else { return }
            print("Annotaion pressed")
            parent.showDirections = true
            
        }
    }
    
    
}
