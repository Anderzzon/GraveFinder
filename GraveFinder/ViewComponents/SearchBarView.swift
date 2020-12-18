//
//  SearchViewModifier.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

struct SearchBarView:View {
    @EnvironmentObject private var viewModel:BottomSheetViewModel
    
    @State var readerHeight:CGFloat
    
    var body : some View {
        HStack(spacing: 15){
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search".localized(), text: $viewModel.query, onEditingChanged: {EditMode in

                if(!viewModel.sheetIsAtTop){
                    viewModel.sheetPosition = SheetPosition.top
                    viewModel.sheetIsAtTop = true
                }
                if(!EditMode){
                    viewModel.sheetIsAtTop = false
                }
            }, onCommit: {
                viewModel.currentPageForAPIRequest = 1
                viewModel.totalGravesSearchResults.removeAll()
                viewModel.fetchGraves()

            })
            .onChange(of: viewModel.query, perform: { _ in
                viewModel.contentToShow(set: .searchResults)
                viewModel.currentPageForAPIRequest = 1
                viewModel.gravesToDisplayOnMap.removeAll()
                if(viewModel.query.count > 0){
                    viewModel.totalGravesSearchResults.removeAll()
                    viewModel.fetchGraves()
                    viewModel.contentToDisplayInBottomSheet = .searchResults
                } else {
                    viewModel.contentToDisplayInBottomSheet = .nothing
                }
            })
            .disableAutocorrection(true)
            if !viewModel.query.isEmpty {
                Button(action: {viewModel.query = ""}, label: {Image(systemName: "multiply.circle").foregroundColor(.gray)})
            }
        }
        .padding()
        .padding(.horizontal,10)
        .background(
            Capsule().fill(Color.gray.opacity(0.2)),
            alignment: .leading
        )
    }
}

