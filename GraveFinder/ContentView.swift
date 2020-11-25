//
//  ContentView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = GravesViewModel()

    var body: some View {
        VStack {
            MapView(viewModel: viewModel)
            GravesView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: GravesViewModel())
    }
}
