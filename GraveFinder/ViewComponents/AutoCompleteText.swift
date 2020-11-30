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
    private var isDisabled:Bool
    
    init(for grave:Grave, andHighLightIf highlight:Bool, isDisabled disabled:Bool){
        self.grave = grave
        self.highlight = highlight
        self.isDisabled = disabled
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10, content: {
                let deceased = grave.deceased ?? "Ej specificierad"
                let dateBuried = grave.dateBuried ?? "Ej specificierad"
                let cemetery = grave.cemetery ?? "Ej specificierad"
                
                Text(deceased)
                    .font(.caption).bold()
                Text("Begravd: \(dateBuried)")
                        .font(.caption2)
                Text("Kyrkogård: \(cemetery)")
                        .font(.caption2)
            })
            Spacer()
            self.isDisabled ? Image(systemName: "nosign")
                .foregroundColor(.gray)
                .padding(.trailing, 10)
                :
                Image(systemName: "mappin.and.ellipse")
                .foregroundColor(Color.gray)
                .padding(.trailing, 10)
            
            
        }.padding()
        
        .background(highlight ? Color.blue.opacity(0.4) : Color.white.opacity(0))
    }
}

struct AutoCompleteText_Previews: PreviewProvider {
    static var previews: some View {
        let grave = Grave(deceased: "Anonymous Svensson", dateBuried: "2020-10-12", dateOfBirth: "2020-20-20", dateOfDeath: "2020-20-20", cemetery: "Skogskyrkogården", graveType: "memorial", location: Location(latitude: nil, longitude: nil))
        
        AutoCompleteText(for: grave, andHighLightIf: false, isDisabled: false)
    }
}
