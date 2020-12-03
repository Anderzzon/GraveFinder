//
//  ContentView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = GravesViewModel()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
           
            MapView(viewModel: viewModel, locationManager: locationManager)
                BottomSheet(viewModel: viewModel)
            
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: GravesViewModel(), locationManager: LocationManager())
    }
}
