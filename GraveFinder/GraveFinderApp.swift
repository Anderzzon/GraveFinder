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
                    
                    DispatchQueue.global(qos: .utility).async {
                        let secretMessage = "Super duper secret message about top secret secret stuff!"
                        let password = "SuperDuperTopSecretPassword"
                        
                        guard let encrypted = compliance.encrypt(string: secretMessage, password: password) else { return }
                        guard let decrypted = compliance.decrypt(data: encrypted, password: password) else { return }
                        
                        DispatchQueue.main.async {
                            print("Decrypted Secret Message: ", decrypted)
                        }
                    }
                    
                }
        }
    }
}
