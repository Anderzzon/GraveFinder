//
//  GravesView.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import SwiftUI

struct GravesView: View {
    
    @State var viewModel = GravesViewModel()
    //@Binding var searchTxt:String
    
    var body: some View {
        NavigationView {
            List(viewModel.graves, id: \.self) { grave in
                GraveView(grave: grave)
            }
            .navigationBarTitle("Graves")

        }
    }
}
