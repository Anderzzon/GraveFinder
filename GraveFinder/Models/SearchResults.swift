//
//  Results.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
struct SearchResults : Codable, Hashable {
    var graves:[Grave]
    
    enum CodingKeys: String, CodingKey {
        case graves = "items"
    }
}
