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
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelagate
    
    let viewContext = PersistenceController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, viewContext)
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate  {
//    private let netStatus = NetStatus.shared
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any ]? = nil ) -> Bool {
//        netStatus.startMonitoring()
//
//        return true
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        netStatus.stopMonitoring()
//    }
//}
