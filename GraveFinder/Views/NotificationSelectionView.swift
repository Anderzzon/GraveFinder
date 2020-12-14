//
//  NotificationSelectionView.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-13.
//

import SwiftUI

struct NotificationSelectionView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel:NotificationSelectionViewModel
    
    init(grave:Grave){
        viewModel = NotificationSelectionViewModel(grave: grave)
    }
    
    var body: some View {
        Form{
            Section(header: Text("Notiser")) {
                if viewModel.graveHasBirthday() {
                    HStack{
                        Text("Notifiera mig på födelsdag").font(.caption)
                        Spacer()
                        Toggle(isOn: $viewModel.notifyBDay, label: {}).labelsHidden().onTapGesture {
                            viewModel.toggleNotification(grave: viewModel.grave, type: .birthday)
                        }
                    }
                }
                if viewModel.graveHasDeathday() {
                    HStack{
                        VStack{
                            Text("Notifiera mig på dödsdag").font(.caption)
                        }
                        Spacer()
                        Toggle(isOn: $viewModel.notifyDDay, label: {}).labelsHidden().onTapGesture {
                            viewModel.toggleNotification(grave: viewModel.grave, type: .deathday)
                        }
                    }
                }
                if viewModel.graveHasBurialDay(){
                    HStack{
                        Text("Notifiera mig på begravningsdag").font(.caption)
                        Spacer()
                        Toggle(isOn: $viewModel.notifyBurialDay, label: {}).labelsHidden().onTapGesture {
                            viewModel.toggleNotification(grave: viewModel.grave, type: .burialday)
                        }
                    }
                }
                if !viewModel.graveHasBirthday() && !viewModel.graveHasDeathday() && !viewModel.graveHasBurialDay() {
                    Text("Det finns inga datum registrerade datum för gravplatsen")
                }
            }
        }
    }
}

struct NotificationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSelectionView(grave: Grave())
    }
}
