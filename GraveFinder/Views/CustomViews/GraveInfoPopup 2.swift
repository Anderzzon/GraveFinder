//
//  NavigationModifier.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-17.
//

import SwiftUI

struct GraveInfoPopup: View {
    @ObservedObject var viewModel: MapViewModel
    @Binding var showGraveDetail: Bool
    
    var body: some View {
        VStack {
            VStack {
                let deceased = viewModel.selectedGraves.first?.deceased ?? "Okänd"
                let born = viewModel.selectedGraves.first?.dateOfBirth
                let died = viewModel.selectedGraves.first?.dateOfDeath
                let buried = viewModel.selectedGraves.first?.dateBuried
                let cemetery = viewModel.selectedGraves.first?.cemetery ?? "Ej specificerad"
                let plotNumber = viewModel.selectedGraves.first?.plotNumber
                //let block = viewModel.selectedGraves.first?.block
                
                Text(deceased)
                    .bold()
                    .foregroundColor(.black)
                    .padding(2)
                
                if born != nil && !born!.isEmpty && died != nil && !died!.isEmpty {
                    Text("\(born!) - \(died!)")
                        .padding(2)
                        .font(.footnote)
                } else {
                    if (born != nil && !born!.isEmpty) && (died == nil) {
                        Text("Född: \(born!)")
                            .padding(2)
                            .font(.footnote)
                    }
                    if (died != nil && !died!.isEmpty) && (born == nil) {
                        Text("Dog: \(died!)")
                            .padding(2)
                            .font(.footnote)
                    }
                }
                
                if buried != nil && !buried!.isEmpty {
                    Text("Gravsatt: \(buried!)")
                        .padding(2)
                        .font(.footnote)
                }
                
                if !cemetery.isEmpty && plotNumber != nil && !plotNumber!.isEmpty {
                    Group {
                        Text("\(cemetery)")
                            .font(.footnote)
                        Text("plats \(plotNumber!)")
                            .font(.footnote)
                    }
                } else {
                    if !cemetery.isEmpty {
                        Text("\(cemetery)")
                            .font(.footnote)
                    }
                    
                    if plotNumber != nil && !plotNumber!.isEmpty {
                        Text("plats \(plotNumber!)")
                            .font(.footnote)
                    }
                }

                HStack {
                    // Buttons
                    Button("Stäng") {
                        showGraveDetail = false
                        print("Avbryt")
                    }
                    .frame(minWidth: 100)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.gray)
                    .cornerRadius(12)

                    
                    Button("Navigera till") {
                        viewModel.navigate()
                        print("Gå till")
                    }
                    .frame(minWidth: 100, minHeight: 20)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.gray)
                    .cornerRadius(12)

                }.padding(.top, 10)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}
