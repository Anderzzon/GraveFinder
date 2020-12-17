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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favorites: FetchedResults<FavGraves>
        
    init(for grave:Grave, selectedGrave:Binding<Grave?>, sheetPos:Binding<SheetPosition>, selectedGraves:Binding<[Grave]>){
        self.viewModel = GravesViewModel(grave: grave, selectedGraves: selectedGraves, sheetPos: sheetPos, selectedGrave: selectedGrave, locationMissing: !grave.isLocatable())
    }
    
    var body: some View {
        // Left icon Map pin / "Cannot" sign
        HStack {
            HStack{
                viewModel.locationMissing ? Image(systemName: "nosign")
                    .foregroundColor(.gray)
                    .padding(.all, 10)
                    :
                    Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(Color.gray)
                    .padding(.all, 10)
                
                // Grave information
                VStack(alignment: .leading, spacing: 10){
                    let deceased = viewModel.grave.deceased ?? "Okänd"
                    let dateBuried = viewModel.grave.dateBuried ?? "Ej specificerad"
                    let cemetery = viewModel.grave.cemetery ?? "Ej specificerad"
                    
                    Text(deceased)
                        .font(.caption).bold()
                    Text("\(NSLocalizedString("buried", comment: "Date of burial")): \(dateBuried)")
                        .font(.caption2)
                    Text("\(NSLocalizedString("cemetry", comment: "Name of cemetry")): \(cemetery)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }
            .background(Color.white.opacity(0.01))
            .onTapGesture {
                hideKeyboard()
                //Grave info card tap to show on map
                if !viewModel.locationMissing {
                    viewModel.setSelectedGrave()
                    withAnimation {
                        viewModel.setSheetPos(to: SheetPosition.bottom)

                    }
                    viewModel.selectGrave()
                }
            }
            // Disable favorite button if grave not locatable
            if !viewModel.locationMissing {
                VStack{
                    //Add option for notifications only if favorite
                    if checkIsFavorite() && viewModel.checkIsNotifiable() {
                        Button(action: {
                            viewModel.showNotificationOptions()
                        }, label: {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.black)
                        })
                        .padding()
                        .sheet(isPresented: $viewModel.notificationOptionsPresenting, content: { NotificationSelectionView(grave: viewModel.grave) })
                    }
                    Button(action: {
                        self.toggleFavorite()
                    } , label: {
                        Image(systemName: checkIsFavorite() ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }).padding()
                }
            }
        }
        .padding([.top,.bottom])
        .background(viewModel.checkIfHighlight() ? Color.gray.opacity(0.4) : Color.white.opacity(0))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    func toggleFavorite(){
        if favorites.firstIndex(where: {$0.id == viewModel.grave.id}) != nil {
            viewModel.deleteFromCoreData()
            viewModel.removeAllPendingNotifications()
        } else {
            viewModel.saveToCoreData()
        }
    }
    func checkIsFavorite()->Bool{
        return favorites.contains(where: {$0.id == viewModel.grave.id})
    }
    
}
