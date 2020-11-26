//
//  GravesView.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import SwiftUI

struct GravesView: View {
    @ObservedObject var viewModel:GravesViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.searchResults.graves, id: \.self) { grave in
                GraveView(grave: grave)
            }.navigationBarTitle("Graves")

        }
    }
}
