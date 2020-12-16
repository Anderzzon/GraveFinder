//
//  ScrollViewModifier.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

internal extension BottomSheetView {
    func SearchGravesModifier() -> some View {
        LazyVStack(alignment: .leading, spacing: 5, content:{
            ForEach(viewModel.totalGravesList){
                grave in

                GravesView(for: grave, selectedGrave: $selectedGrave, offset: $offset, selectedGraves: $viewModel.selectedGraves)
            }
            if viewModel.totalPages > 1 && viewModel.currentPage < viewModel.totalPages {
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        viewModel.currentPage += 1
                        viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                    }, label: {
                        Text("Visa fler...")
                    }).padding(.bottom, 40)
                    Spacer()
                }
            } else {
                HStack{
                    Spacer()
                    Text("Slut på resultat...")
                        .font(.caption2)
                        .padding(.bottom, 40)
                    Spacer()
                }
            }
        })
    }
}
