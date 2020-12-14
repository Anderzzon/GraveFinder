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

        if (horizontalSizeClass == .regular && verticalSizeClass == .compact) || (horizontalSizeClass == .compact && verticalSizeClass == .compact) {
            //iPhone landscape
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top
            ), content: {
                MapView(viewModel: viewModel)
                if netStatus.noInternet {
                    VStack {
                        HStack {
                            // Banner Content Here
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(Image(systemName: "exclamationmark.triangle")) Alert")
                                    .bold()
                                Text("No internet connection detected")
                                    .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    .background(
                        Capsule()
                            .fill(Color.red)
                            .frame(height: 80),
                        alignment: .leading
                    )
                    .foregroundColor(Color.white)
                    .padding(12)
                    .cornerRadius(8)
                }
            })
        } else {
            //Other

            GeometryReader{ geometry in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top
                ), content: {

                    MapView(viewModel: viewModel)
                    BottomSheet(viewModel: viewModel)
                    if netStatus.noInternet {
                        VStack {
                            HStack {
                                // Banner Content Here
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(Image(systemName: "exclamationmark.triangle")) Alert")
                                        .bold()
                                    Text("No internet connection detected")
                                        .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                                }
                                .padding()
                                Spacer()
                            }
                        }
                        .background(
                            Capsule()
                                .fill(Color.red)
                                .frame(height: 80),
                            alignment: .leading
                        )
                        .foregroundColor(Color.white)
                        .padding(12)
                        .cornerRadius(8)
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: GravesViewModel())
    }
}
