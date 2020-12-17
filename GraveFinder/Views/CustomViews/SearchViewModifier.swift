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
            TextField("Search...", text: $viewModel.query, onEditingChanged: {EditMode in

                if(!viewModel.pulledUp){
                    viewModel.sheetPos = SheetPosition.top
                    viewModel.pulledUp = true
                }
                if(!EditMode){
                    viewModel.pulledUp = false
                }
            }, onCommit: {
                viewModel.currentPage = 1
                viewModel.totalGravesList.removeAll()
                viewModel.fetchGraves()

            })
            .onChange(of: viewModel.query, perform: { _ in
                self.setOptions(index: 0)
                if viewModel.onlyFavorites == 1{
                    viewModel.onlyFavorites = 0
                    viewModel.showContent = .searchResults
                }
                viewModel.currentPage = 1
                viewModel.selectedGraves.removeAll()
                if(viewModel.query.count > 0){
                    viewModel.totalGravesList.removeAll()
                    viewModel.fetchGraves()
                    viewModel.showContent = .searchResults
                } else {
                    viewModel.showContent = .nothing
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

