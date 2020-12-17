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
                Text("\(viewModel.selectedGraves[0].deceased ?? "No name")")
                    .bold()
                    .foregroundColor(.black)
                    .padding(2)
                Text("\(viewModel.selectedGraves[0].dateOfBirth ?? "") - \(viewModel.selectedGraves[0].dateOfDeath ?? "")")
                    .padding(2)
                    .font(.footnote)
                Text("Gravsatt: \(viewModel.selectedGraves.first?.dateBuried ?? "")")
                    .padding(2)
                    .font(.footnote)
                Text("Plot number")
                    .padding(2)
                    .font(.footnote)
                
                
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
