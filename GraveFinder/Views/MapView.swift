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
    @State private var region: MKCoordinateRegion?
    @State private var mapType: MKMapType = .standard
    
    @State private var annotations = [Grave]()
    @State private var showGraveDeatil = false
    
    init(viewModel: GravesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            MapViewUI(showGraveDetail: $showGraveDeatil, graves: viewModel.selectedGraves, mapViewType: mapType).edgesIgnoringSafeArea(.all)
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
            }
        }.alert(isPresented: $showGraveDeatil, content: {
            let name = viewModel.selectedGraves[0].title ?? "Grave"
            return Alert(title: Text(name), message: Text("Vill du öppna Maps och navigera till \(name)?"), primaryButton: .default(Text("OK")) {
                navigate()
            }, secondaryButton: .cancel())
        })
    }
    func navigate() {
        
        let graveAnnotation = viewModel.selectedGraves[0] 
        let placemark = MKPlacemark(coordinate: graveAnnotation.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
            mapItem.name = placemark.title
            mapItem.openInMaps(launchOptions: launchOptions)
    }
}


//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
