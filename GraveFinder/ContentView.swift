//
//  ContentView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = GravesViewModel()
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                MapView(viewModel: viewModel)
                BottomSheet(viewModel: viewModel)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: GravesViewModel())
    }
}
