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
    @ObservedObject var viewModel = GravesViewModel()
    
    @ObservedObject var netStatus: NetStatus
    
    var body: some View {
        
        Group {
            
            if netStatus.noInternet {
                NotificationModifier()
            }
            
            if (horizontalSizeClass == .regular && verticalSizeClass == .compact) || (horizontalSizeClass == .compact && verticalSizeClass == .compact) {
                //iPhone landscape
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top
                ), content: {
                    MapView(viewModel: viewModel)
                })
            } else {
                //Other
                
                GeometryReader{ geometry in
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top
                    ), content: {
                        
                        MapView(viewModel: viewModel)
                        BottomSheetView(viewModel: viewModel)
                            .alert(
                                isPresented: $viewModel.alertIsPresented,
                                content: {
                                    viewModel.alert ?? Alert(title: Text("Error"))
                                }
                            )
                    }
                    )
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: GravesViewModel())
    }
}
