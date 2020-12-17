//
//  NotificationSelectionView.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-13.
//

import SwiftUI

struct NotificationSelectionView: View {
    @ObservedObject private var viewModel:NotificationSelectionViewModel
    
    init(grave:Grave){
        viewModel = NotificationSelectionViewModel(grave: grave)
    }
    
    var body: some View {
        Form{
            Section(header: Text(NSLocalizedString("notices", comment: "Notices"))) {
                if viewModel.graveHasBirthday() {
                    HStack{
                        Text("Notifiera mig på födelsdag").font(.caption)
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
                        Text(NSLocalizedString("notify_deathday", comment: "Deathday notification")).font(.caption)
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
                    Text(NSLocalizedString("notify_funeralday", comment: "Funeral day notification")).font(.caption)
                    Spacer()
                    Toggle(isOn: $viewModel.notifyBurialDay, label: {})
                        .labelsHidden()
                        .onChange(of: viewModel.notifyBurialDay){ value in
                        viewModel.toggleNotification(isOn: value, grave: viewModel.grave, type: .burialday)
                    }
                }
            }
        }
        }.alert(isPresented: $viewModel.alertIsPresented,
                content: {viewModel.alert ?? Alert(title: Text("Error"))})
    }
}

struct NotificationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSelectionView(grave: Grave())
    }
}
