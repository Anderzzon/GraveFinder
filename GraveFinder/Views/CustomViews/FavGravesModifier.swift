//
//  FavGravesModifier.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

internal extension BottomSheetView {
    func FavGravesModifier() -> some View {
        LazyVStack(alignment: .leading, spacing: 5, content:{
            ForEach(favorites){
                favorite in
                let grave = Grave(favorite: favorite)
                GravesView(for: grave, selectedGrave: $selectedGrave, disabledIf: false, offset: $offset, viewModel: viewModel)
            }
            
        })
    }
}
