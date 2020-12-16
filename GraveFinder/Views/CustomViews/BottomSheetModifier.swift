//
//  SliveOverCardView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-15.
//

import SwiftUI

struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}

struct BottomSheetModifier<Content: View> : View {
    @GestureState private var dragState = DragState.inactive
    @Binding var sheetPos: SheetPosition
    @State var isEditing:Bool = false


    var content: (Binding<SheetPosition>) -> Content
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        VStack{
            Group {
                Handle()
                self.content($sheetPos)
            }
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(15.0)
        .frame(height: UIScreen.main.bounds.height)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: self.sheetPos.rawValue + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }

    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.sheetPos.rawValue + drag.translation.height
        let positionAbove: SheetPosition
        let positionBelow: SheetPosition
        let closestPosition: SheetPosition

        if cardTopEdgeLocation <= SheetPosition.middle.rawValue {
            positionAbove = .top
            positionBelow = .middle
        } else {
            positionAbove = .middle
            positionBelow = .bottom
        }

        if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }

        if verticalDirection > 0 {
            self.sheetPos = positionBelow
        } else if verticalDirection < 0 {
            self.sheetPos = positionAbove
        } else {
            self.sheetPos = closestPosition
        }
    }
}

enum SheetPosition: CGFloat {
    case top = 10
    case middle = 400
    case bottom = 700
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
