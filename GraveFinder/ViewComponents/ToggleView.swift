//
//  SwiftUIView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

struct ToggleView<Content:View>:View {

    @EnvironmentObject private var viewModel:BottomSheetViewModel
    @State var frames = Array<CGRect>(repeating: .zero, count: 2)
    var content : () -> Content
    var body : some View {
        VStack{
            self.content()
            HStack(spacing: 10) {
                ForEach(viewModel.bottomSheetDisplayOptions.indices, id: \.self) { index in
                    Button(action: {
                        viewModel.contentToShow(set: viewModel.bottomSheetDisplayOptions[index])
                        hideKeyboard()
                    }) {
                        Text(viewModel.bottomSheetDisplayOptions[index].rawValue.localized()).frame(width: 60, height: 10, alignment: .center)
                    }
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                self.setFrame(
                                    index: index,
                                    frame: geo.frame(in: .global))}
                        }
                    )
                    .foregroundColor(Color.black).font(.caption)
                }
            }
            .background(
                Capsule().fill(
                    Color.white.opacity(0.8))
                    .frame(width: self.frames[viewModel.selectedDisplayOptionIndex].width,
                           height: self.frames[viewModel.selectedDisplayOptionIndex].height, alignment: .topLeading)
                    .offset(x: self.frames[viewModel.selectedDisplayOptionIndex].minX - self.frames[0].minX)
                , alignment: .leading)
            .background(Capsule().stroke(Color.gray, lineWidth: 0.2))
        }
        .background(
            Capsule().fill(
                Color.gray.opacity(0.1))
            , alignment: .leading
        )
    }
    func setFrame(index: Int, frame: CGRect) {
        frames[index] = frame
    }
}
