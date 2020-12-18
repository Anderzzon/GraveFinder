//
//  NotificationSelectionView.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-13.
//

import SwiftUI

struct NotificationSelectionView: View {
    @ObservedObject private var viewModel:NotificationSelectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(grave:Grave){
        viewModel = NotificationSelectionViewModel(grave: grave)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form{
                    Section(header: Text("Notices")) {
                        if viewModel.graveHasBirthday() {
                            HStack{
                                Text("\("Notify Birthday".localized())  (\(viewModel.grave.dateOfBirth!))").font(.caption)
                                Spacer()
                                Toggle(isOn: $viewModel.notifyBDay, label: {})
                                    .labelsHidden()
                                    .onChange(of: viewModel.notifyBDay) { value in
                                        viewModel.toggleNotification(isOn: value, grave: viewModel.grave, type: .birthday)
                                    }
                            }
                        }
                        if viewModel.graveHasDeathday() {
                            HStack{
                                VStack{
                                    Text("\("Notify deathday".localized())  (\(viewModel.grave.dateOfDeath!))").font(.caption)
                                }
                                Spacer()
                                Toggle(isOn: $viewModel.notifyDDay, label: {})
                                    .labelsHidden()
                                    .onChange(of: viewModel.notifyDDay){ value in
                                        viewModel.toggleNotification(isOn: value, grave: viewModel.grave, type: .deathday)
                                    }
                            }
                        }
                        if viewModel.graveHasBurialDay(){
                            HStack{
                                Text("\("Notify funeral day".localized())  (\(viewModel.grave.dateBuried!))").font(.caption)
                                Spacer()
                                Toggle(isOn: $viewModel.notifyBurialDay, label: {})
                                    .labelsHidden()
                                    .onChange(of: viewModel.notifyBurialDay){ value in
                                        viewModel.toggleNotification(isOn: value, grave: viewModel.grave, type: .burialday)
                                    }
                            }
                        }
                    }
                    .navigationBarTitle("\(self.viewModel.grave.deceased ?? "")")
                    .navigationBarItems(trailing: Button("Close".localized()) {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.inline/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .accentColor( .black)
        .alert(isPresented: $viewModel.alertIsPresented,
               content: {viewModel.alert ?? Alert(title: Text("Error"))})
    }
}

struct NotificationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSelectionView(grave: Grave())
    }
}
