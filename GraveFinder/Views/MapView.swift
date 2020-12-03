//
//  MapView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: GravesViewModel
    @ObservedObject var locationManager: LocationManager
    @State private var region: MKCoordinateRegion?
    @State private var mapType: MKMapType = .standard
    
    @State private var annotations = [GraveLocation]()
    @State private var showDirections = false
    @State private var showingDirections = false
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    init(viewModel: GravesViewModel, locationManager: LocationManager) {
        self.viewModel = viewModel
        self.locationManager = locationManager
    }
    
    var body: some View {
        ZStack {
            MapViewUI(graves: viewModel.selectedGraves, mapViewType: mapType, route: nil, showDirections: $showDirections, locationManager: locationManager, centerCoordinate: $centerCoordinate).edgesIgnoringSafeArea(.all)
            VStack {
                Picker("", selection: $mapType) {
                    Text("Standard").tag(MKMapType.standard).padding()
                    Text("Hybrid").tag(MKMapType.hybrid).padding()
                    Text("Satellite").tag(MKMapType.satellite).padding()
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color.gray.opacity(0.7))
                .offset(y: 18)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // click for navigation
                        }) {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
