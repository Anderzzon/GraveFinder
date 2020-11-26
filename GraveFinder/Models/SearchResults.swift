//
//  Results.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
struct SearchResults : Codable, Hashable {
    var graves:[Grave]
    var pages:Int
    
    enum CodingKeys: String, CodingKey {
        case graves = "items"
        case pages
    }
}
