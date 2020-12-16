//
//  MapViewModel.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-16.
//

import Foundation
import Combine
import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    
    @Published var mapOptions = ["Standard","Satelite","Hybrid"]
    @Published var selectedGraves: [Grave]
    @Published var region: MKCoordinateRegion?
    @Published var mapType: MKMapType = .standard
    @Published var selectedIndex = 0
    @Published var showGraveDeatil = false
    
    init(selectedGraves: [Grave] ) {
        print("MapViewModel init")
        self.selectedGraves = selectedGraves
    }
    
    func setMapType(index: Int){

        self.selectedIndex = index
        switch index {
        case 0:
            mapType = .standard
        case 1:
            mapType = .satellite
        case 2:
            mapType = .hybrid
        default:
            mapType = .standard
        }
    }
    
}
