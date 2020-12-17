//
//  SwiftUIView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

struct ToggleView:View {

    @EnvironmentObject private var viewModel:BottomSheetViewModel
    
    var body : some View {
        VStack{
            HStack(spacing: 10) {
                ForEach(viewModel.bottomSheetDisplayOptions, id: \.self) { option in
                    Button(action: {
                            viewModel.contentToShow(set: option)
                            hideKeyboard()
                    }) {
                        Text(option.rawValue).frame(width: 60, height: 10, alignment: .center)
                    }
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear { viewModel.setFrame(index: viewModel.bottomSheetDisplayOptions.firstIndex(of: option)!, frame: geo.frame(in: .global))}
                        }
                    )
                    .foregroundColor(Color.black).font(.caption)
                }
            }
            .background(
                Capsule().fill(
                    Color.white.opacity(0.8))
                    .frame(width: viewModel.frames[viewModel.bottomSheetDisplayOptions.firstIndex(of: viewModel.selectedDisplayOption)!].width,
                           height: viewModel.frames[viewModel.bottomSheetDisplayOptions.firstIndex(of: viewModel.selectedDisplayOption)!].height, alignment: .topLeading)
                    .offset(x: viewModel.frames[viewModel.bottomSheetDisplayOptions.firstIndex(of: viewModel.selectedDisplayOption)!].minX - viewModel.frames[0].minX)
                , alignment: .leading
            )
            .background(Capsule().stroke(Color.gray, lineWidth: 0.2))
        }
        .background(
            Capsule().fill(
                Color.white.opacity(0.4))
            , alignment: .leading
        )
    }
}
