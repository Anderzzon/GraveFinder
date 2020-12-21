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
    private let compliance = ComplianceViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(notificationDelegate)
                .environmentObject(netStatus)
                .onAppear{
                    NotificationService.setDelegate(delegate: notificationDelegate)
                    
                    let encrypted = compliance.encrypt(string: "Super duper secret message about top secret secret stuff!!")
                    print("encrypted: ", encrypted! as Data)
                    let decrypted = compliance.decrypt(data: encrypted!)
                    print("decrypted: ", decrypted!)
                }
        }
    }
}
