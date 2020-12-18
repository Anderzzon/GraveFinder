//
//  SliveOverCardView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-15.
//

import SwiftUI
import UIKit

struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}

struct BottomSheetPositionModifier<Content: View> : View {
    @GestureState private var dragState = DragState.inactive
    @EnvironmentObject private var sheetPositionModel:SheetPositionViewModel

    var content: () -> Content
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        VStack{
            Group {
                Handle()
                self.content()
            }
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(15.0)
        .frame(height: UIScreen.main.bounds.height)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: sheetPositionModel.sheetPosition + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }

    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = sheetPositionModel.sheetPosition + drag.translation.height
        let positionAbove: CGFloat
        let positionBelow: CGFloat
        let closestPosition: CGFloat

        if cardTopEdgeLocation <= sheetPositionModel.middle {
            positionAbove = sheetPositionModel.top
            positionBelow = sheetPositionModel.middle
        } else {
            positionAbove = sheetPositionModel.middle
            positionBelow = sheetPositionModel.bottom
        }

        if (cardTopEdgeLocation - positionAbove) < (positionBelow - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }

        if verticalDirection > 0 {
            sheetPositionModel.sheetPosition = positionBelow
            print("positionBelow", positionBelow)
            hideKeyboard()
        } else if verticalDirection < 0 {
            sheetPositionModel.sheetPosition = positionAbove
            print("positionAbove", positionAbove)
        } else {
            sheetPositionModel.sheetPosition = closestPosition
            print("closestPosition", closestPosition)
        }
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }

    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
