//
//  MapView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var locationManager = CLLocationManager()
    @StateObject var locationManagerDelegate = LocationDelegate()

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true).edgesIgnoringSafeArea(.all).onAppear {
            locationManager.delegate = locationManagerDelegate
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
