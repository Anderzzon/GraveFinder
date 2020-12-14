//
//  AutoCompleteText.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-27.
//

import SwiftUI
import CoreData

struct GravesView: View {
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var viewModel : GravesViewModel
    @Binding private var selectedGrave:Grave?
    @Binding private var offset:CGFloat
    @State private var isPresented = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favorites: FetchedResults<FavGraves>
    
    private var grave:Grave
    private var isDisabled:Bool
    
    init(for grave:Grave, selectedGrave:Binding<Grave?>, disabledIf disabled:Bool, offset:Binding<CGFloat>, viewModel:GravesViewModel){
        self.grave = grave
        self._selectedGrave = selectedGrave
        self.isDisabled = disabled
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
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }.onTapGesture {
                hideKeyboard()
                //Grave info card tap to show on map
                if !isDisabled {
                    viewModel.selectedGraves.removeAll()
                    self.selectedGrave = grave
                    withAnimation {
                        self.offset = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewModel.selectedGraves.append(grave)
                    }
                }
            }
            // Disable favorite button if grave not locatable
            if !isDisabled {
                VStack{
                    //Add option for notifications only if favorite
                    if checkIfFavorite() {
                        Button(action: {
                            self.isPresented = true
                        }, label: {
                            Image(systemName: "bell")
                        })
                        .padding()
                        .sheet(isPresented: $isPresented, content: {NotificationSelectionView(grave: grave)})
                    }
                    Button(action: {
                        self.toggleFavorite(for: grave)
                    } , label: {
                        Image(systemName: checkIfFavorite() ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }).padding()
                }
            }
        }
        .padding([.top,.bottom])
        .background(checkIfHighlight() ? Color.gray.opacity(0.4) : Color.white.opacity(0))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    func toggleFavorite(for grave:Grave){
        if favorites.firstIndex(where: {$0.id == grave.id}) != nil{
            viewModel.deleteFromCoreData(grave: grave)
        } else {
            viewModel.saveToCoreData(grave: grave)
        }
    }
    func checkIfFavorite()->Bool{
        return favorites.contains(where: {$0.id == grave.id})
    }
    func checkIfHighlight()->Bool{
        return selectedGrave?.id == grave.id
    }
}
