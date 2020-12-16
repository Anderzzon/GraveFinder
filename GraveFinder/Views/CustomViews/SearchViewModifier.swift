//
//  SearchViewModifier.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

internal extension BottomSheetView {

    func SearchViewModifier(readerHeight:CGFloat) -> some View {
        HStack(spacing: 15){
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search...", text: $query,onEditingChanged: {EditMode in

                if(!self.pulledUp){
                    sheetPos = SheetPosition.top
                    offset = (-readerHeight + searchBarHeight)
                    self.pulledUp = true
                }
                if(!EditMode){
                    self.pulledUp = false
                }
            }, onCommit: {
                viewModel.currentPage = 1
                viewModel.totalGravesList.removeAll()
                viewModel.fetchGraves(for: query, at: viewModel.currentPage)

            })
            .onChange(of: query, perform: { _ in
                self.setOptions(index: 0)
                if onlyFavorites == 1{
                    onlyFavorites = 0
                    showContent = .searchResults
                }
                viewModel.currentPage = 1
                viewModel.selectedGraves.removeAll()
                if(query.count > 0){
                    viewModel.totalGravesList.removeAll()
                    viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                    showContent = .searchResults
                } else {
                    showContent = .nothing
                }
            })
            .disableAutocorrection(true)
        }
        .padding()
        .padding(.horizontal,10)
        .background(
            Capsule().fill(Color.gray.opacity(0.2)),
            alignment: .leading
        )
    }
}

