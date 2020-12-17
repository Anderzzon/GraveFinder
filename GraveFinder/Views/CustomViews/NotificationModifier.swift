//
//  NotificaitonModifier.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-14.
//

import SwiftUI

extension ContentView {
    func NotificationModifier() -> some View {
        VStack {
            HStack {
                // Banner Content Here
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(Image(systemName: "exclamationmark.triangle")) Alert")
                        .bold()
                    Text("No internet")
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
}
