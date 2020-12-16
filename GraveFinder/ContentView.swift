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
    @ObservedObject var viewModel = BottomSheetViewModel()
    
    @ObservedObject var netStatus: NetStatus
    @State internal var landscape = true
    
    var body: some View {
        
        if (horizontalSizeClass == .regular && verticalSizeClass == .compact) || (horizontalSizeClass == .compact && verticalSizeClass == .compact) {

            //iPhone landscape
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top
            ), content: {
                MapView(viewModel: viewModel,isLand: $landscape )
                if netStatus.noInternet { NotificationModifier() }
                
            })
        } else {
            //Other
            GeometryReader{ geometry in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top
                ), content: {
                    
                    MapView(viewModel: viewModel, isLand: $landscape)
                    BottomSheetView(viewModel: viewModel)
                        .alert(
                            isPresented: $viewModel.alertIsPresented,
                            content: {
                                viewModel.alert ?? Alert(title: Text("Error"))
                            }
                        )
                    if netStatus.noInternet { NotificationModifier() }
                }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: BottomSheetViewModel())
    }
}
