//
//  FavGravesModifier.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

struct FavoritesResultsView:View {
    @EnvironmentObject private var viewModel:BottomSheetViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favorites: FetchedResults<FavGraves>
    
    var body : some View {
        LazyVStack(alignment: .leading, spacing: 5, content:{
            ForEach(favorites){
                favorite in
                let grave = Grave(favorite: favorite)
                GravesView(for: grave, selectedGrave: $viewModel.selectedGrave, sheetPos: $viewModel.sheetPosition, selectedGraves: $viewModel.gravesToDisplayOnMap)
            }
        })
    }
}
