//
//  AutoCompleteText.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-27.
//

import SwiftUI

struct GravesView: View {
    @ObservedObject var viewModel : GravesViewModel
    @Binding private var selectedGrave:Grave?
    @Binding private var offset:CGFloat
    private var grave:Grave
    private var isDisabled:Bool
    private var isFavorite:Bool
    
    
    init(for grave:Grave, selectedGrave:Binding<Grave?>, disabledIf disabled:Bool, favorite:Bool, offset:Binding<CGFloat>, viewModel:GravesViewModel){
        
        self.grave = grave
        self._selectedGrave = selectedGrave
        self.isDisabled = disabled
        self.isFavorite = favorite
        self._offset = offset
        self.viewModel = viewModel
    }
    
    var body: some View {
        // Left icon Map pin / "Cannot" sign
        HStack {
            HStack{
                self.isDisabled ? Image(systemName: "nosign")
                    .foregroundColor(.gray)
                    .padding(.all, 10)
                    :
                    Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(Color.gray)
                    .padding(.all, 10)
                
                // Grave information
                VStack(alignment: .leading, spacing: 10){
                    let deceased = grave.deceased ?? "Okänd"
                    let dateBuried = grave.dateBuried ?? "Ej specificerad"
                    let cemetery = grave.cemetery ?? "Ej specificerad"
                    
                    Text(deceased)
                        .font(.caption).bold()
                    Text("Begravd: \(dateBuried)")
                        .font(.caption2)
                    Text("Kyrkogård: \(cemetery)")
                        .font(.caption2)
                }
                Spacer()
            }.onTapGesture {
                //Grave info card tap to show on map
                if !isDisabled {
                    viewModel.selectedGraves.removeAll()
                    self.selectedGrave = grave
                    self.offset = 0
                    let graveLocation = GraveLocation(grave: grave)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewModel.selectedGraves.append(graveLocation)
                    }
                }
            }
            // Grave is favorite toggle
            if !isDisabled {
                Button(action: {
                    viewModel.toggleToFavorites(grave: grave)
                } , label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }).padding()
            }
        }.padding()
        .background(selectedGrave == grave ? Color.blue.opacity(0.4) : Color.white.opacity(0))
    }
}
