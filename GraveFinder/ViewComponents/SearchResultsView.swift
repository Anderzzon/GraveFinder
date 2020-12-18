//
//  ScrollViewModifier.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

struct SearchResultsView : View {
    
    @EnvironmentObject private var viewModel:BottomSheetViewModel
    
    var body : some View {
        LazyVStack(alignment: .leading, spacing: 5, content:{
            ForEach(viewModel.totalGravesSearchResults){
                grave in

                GravesView(for: grave, selectedGrave: $viewModel.selectedGrave, sheetPos: $viewModel.sheetPosition, selectedGraves: $viewModel.gravesToDisplayOnMap)
            }
            if viewModel.totalPagesInAPIRequest > 1 && viewModel.currentPageForAPIRequest < viewModel.totalPagesInAPIRequest {
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        viewModel.currentPageForAPIRequest += 1
                        viewModel.fetchGraves()
                    }, label: {
                        Text("Show more".localized())
                    }).padding(.bottom, 40)
                    Spacer()
                }
            } else {
                HStack{
                    Spacer()
                    Text("End of results".localized())
                        .font(.caption2)
                        .padding(.bottom, 40)
                    Spacer()
                }
            }
        })
    }
}
