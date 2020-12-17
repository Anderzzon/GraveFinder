//
//  NavigationModifier.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-17.
//

import SwiftUI

extension MapView {
    func NavigationModifier() -> some View {
        VStack {
            VStack {
                Text("\(viewModel.selectedGraves.first?.deceased ?? "No name")")
                    .bold()
                    .foregroundColor(.black)
                    .padding(2)
                Text("\(viewModel.selectedGraves.first?.dateOfBirth ?? "") - \(viewModel.selectedGraves.first?.dateOfDeath ?? "")")
                    .padding(2)
                    .font(.footnote)
                Text("Gravsatt: \(viewModel.selectedGraves.first?.dateBuried ?? "")")
                    .padding(2)
                    .font(.footnote)
                if (viewModel.selectedGraves.first?.plotNumber != nil) {
                    Group {
                        Text("\(viewModel.selectedGraves.first?.cemetery ?? "")")
                            .font(.footnote)
                        Text("plats \(viewModel.selectedGraves.first!.plotNumber!)")
                            .font(.footnote)
                    }
                }
                Print(viewModel.selectedGraves.first?.plotNumber)

                HStack {
                    // Buttons
                    Button("Avbryt") {
                        showGraveDeatil = false
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
