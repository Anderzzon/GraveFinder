//
//  GraveFinderApp.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-23.
//

import SwiftUI
import CoreData

@main
struct GraveFinderApp: App {
    
    @StateObject var netStatus = NetStatus.shared
    @StateObject var notificationDelegate = NotificationDelegate()
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(notificationDelegate)
                .environmentObject(netStatus)
                .onAppear{
                    NotificationService.setDelegate(delegate: notificationDelegate)
                }
        }
    }
}
