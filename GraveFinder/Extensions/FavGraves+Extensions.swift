//
//  FavGraves+Extensions.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-09.
//

import Foundation
import CoreData
import UIKit

extension FavGraves {
    func removeFromCoreData() {
        let context = PersistenceController.shared.context
        context.delete(self)
        PersistenceController.shared.saveContext()
    }
}
