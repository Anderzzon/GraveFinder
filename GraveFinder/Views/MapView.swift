//
//  MapView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.27212, longitude: 18.10164), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var mapType: MKMapType = .standard
    
    var graves: [GraveLocation] = []
    @State private var annotations = [GraveLocation]()
    
    init() {
        let grave = GraveLocation(name: "Hans", latitude: 59.27212, longitude: 18.10164)
        graves.append(grave)
        self.annotations = graves
    }
    
    var body: some View {
        
        ZStack {
            MapViewUI(graves: annotations, mapViewType: mapType, region: region).edgesIgnoringSafeArea(.all)
            VStack {
                Picker("", selection: $mapType) {
                    Text("Standard").tag(MKMapType.standard).padding()
                    Text("Hybrid").tag(MKMapType.hybrid).padding()
                    Text("Satellite").tag(MKMapType.satellite).padding()
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color.gray.opacity(0.7))
                .offset(y: 18)
                Spacer()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            annotations.removeAll()
                            let grave = GraveLocation(name: UUID().uuidString, latitude: 59.27212, longitude: 18.10164)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                annotations.append(grave)
                            }
                            
                            print("Annotations count: \(annotations.count)")
                            
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
                }
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
