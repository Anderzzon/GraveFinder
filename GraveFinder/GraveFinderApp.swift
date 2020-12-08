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
    let viewContext:NSManagedObjectContext

    init(){
        self.viewContext = PersistenceController.shared.container.viewContext
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, viewContext)
        }
    }
}
