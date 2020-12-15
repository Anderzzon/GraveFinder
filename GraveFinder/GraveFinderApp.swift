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
    
    @StateObject var netStatus = NetStatus()
    let viewContext = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            ContentView( netStatus: netStatus).environment(\.managedObjectContext, viewContext).environmentObject(netStatus)
        }
    }
}
