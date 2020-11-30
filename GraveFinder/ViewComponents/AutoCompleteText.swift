//
//  AutoCompleteText.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-27.
//

import SwiftUI

struct AutoCompleteText: View {
    private var grave:Grave
    private var highlight:Bool
    
    init(for grave:Grave, andHighLightIf highlight:Bool){
        self.grave = grave
        self.highlight = highlight
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10, content: {
                
                let dateBuried = grave.dateBuried ?? "Okänd"
                let cemetery = grave.cemetery ?? "Ej specificierad"
                
                Text(grave.deceased!)
                    .font(.caption).bold()
                Text("Begravd: \(dateBuried)")
                        .font(.caption2)
                Text("Kyrkogård: \(cemetery)")
                        .font(.caption2)
            })
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
            
            
        }.padding().background(highlight ? Color.blue.opacity(0.4) : Color.white.opacity(0))
    }
}

struct AutoCompleteText_Previews: PreviewProvider {
    static var previews: some View {
        let grave = Grave(deceased: "Anonymous Svensson", dateBuried: "2020-10-12", dateOfBirth: "2020-20-20", dateOfDeath: "2020-20-20", cemetery: "Skogskyrkogården", location: Location(latitude: nil, longitude: nil))
        
        AutoCompleteText(for: grave, andHighLightIf: false)
    }
}
