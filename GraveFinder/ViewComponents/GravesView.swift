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
                    let deceased = viewModel.grave.deceased ?? NSLocalizedString("unknown", comment: "Unknown")
                    let born = viewModel.grave.dateOfBirth
                    let died = viewModel.grave.dateOfDeath
                    let cemetery = viewModel.grave.cemetery ?? NSLocalizedString("unspecified", comment: "Unspecified")
                    let gravNummer = viewModel.grave.plotNumber
                    
                    Text(deceased)
                        .font(.caption).bold()
                    
                    if born != nil && !born!.isEmpty {
                        Text("\(NSLocalizedString("born", comment: "Born")): \(born!)").font(.caption2).padding(.leading, 15)
                    }
                    if died != nil && !died!.isEmpty {
                        Text("\(NSLocalizedString("died", comment: "Died")): \(died!)").font(.caption2).padding(.leading, 15)
                    }
                    if gravNummer != nil && !gravNummer!.isEmpty {
                        Text("\(NSLocalizedString("grave_nr", comment: "Grave Nr.")): \(gravNummer!)").font(.caption2).padding(.leading, 15)
                    }
                        
                    Text("\(NSLocalizedString("cemetry", comment: "Cemetry")): \(cemetery)")
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
        .background(viewModel.checkIfHighlight() ? Color.gray.opacity(0.2) : Color.white.opacity(0))
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
