//
//  GraveView.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import SwiftUI
struct GraveView: View {
    private let grave:Grave
    
    init(grave: Grave) {
        self.grave = grave
    }
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "grave")!)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 15) {
                Text(grave.deceased ?? "Ej namngiven")
                    .font(.system(size: 18))
                    .foregroundColor(Color.blue)
                Text("Begravdes: \(grave.dateBuried ?? "Okänd")")
                    .font(.system(size: 14))
            }
        }
    }
}
