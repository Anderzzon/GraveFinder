//
//  SwiftUIView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

internal extension BottomSheetView {

    func ToggleViewModifier() -> some View {
        VStack{
            HStack(spacing: 10) {
                ForEach(self.graveOptions.indices, id: \.self) { index in
                    Button(action: {
                            setOptions(index: index)
                            hideKeyboard()
                    }) {
                        Text(self.graveOptions[index]).frame(width: 60, height: 10, alignment: .center)
                    }
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear { self.setFrame(index: index, frame: geo.frame(in: .global)) }
                        }
                    )
                    .foregroundColor(Color.black).font(.caption)
                }
            }
            .background(
                Capsule().fill(
                    Color.white.opacity(0.8))
                    .frame(width: self.frames[self.selectedIndex].width,
                           height: self.frames[self.selectedIndex].height, alignment: .topLeading)
                    .offset(x: self.frames[self.selectedIndex].minX - self.frames[0].minX)
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
