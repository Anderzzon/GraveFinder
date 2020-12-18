//
//  ContentView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var netStatus: NetStatus
    @ObservedObject var viewModel = BottomSheetViewModel()
    @ObservedObject var sheetPositionModel:SheetPositionViewModel
    
    init(){
        let searchBarHeight:CGFloat = 165
        let screenSize = UIScreen.main.bounds.size.height
        let screenMiddle = screenSize / 2
        let bottomPosition = screenSize - searchBarHeight
        let middlePosition = screenMiddle - (searchBarHeight / 2)
        self.sheetPositionModel = SheetPositionViewModel(middle: middlePosition, bottom: bottomPosition, initialPosition: bottomPosition)
    }

    var body: some View {
        
        if (horizontalSizeClass == .regular && verticalSizeClass == .compact) || (horizontalSizeClass == .compact && verticalSizeClass == .compact) {

            //iPhone landscape
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top
            ), content: {
                MapView(viewModel: viewModel )
                if netStatus.noInternet { ConnectionAlertView() }
                
            })
        } else {
            //Other
            GeometryReader{ geometry in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top
                ), content: {
                    
                    MapView(viewModel: viewModel)
                    BottomSheetView()
                        .environmentObject(viewModel)
                        .environmentObject(sheetPositionModel)
                        .onTapGesture {
                        hideKeyboard()
                    }.alert(
                            isPresented: $viewModel.alertIsPresented,
                            content: {
                                viewModel.alert ?? Alert(title: Text("Error"))
                            }
                        )
                    if netStatus.noInternet { ConnectionAlertView() }
                }
                ).onAppear(perform: {
//                    let screenHeight = geometry.frame(in: .global).height
//                    let middleOfScreen = screenHeight / 2
//                    sheetPosition.setBottom(to: screenHeight)
//                    sheetPosition.setMiddle(to: middleOfScreen)
                    
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: BottomSheetViewModel())
    }
}
