//
//  Location.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
import MapKit

struct Location : Codable, Hashable {
    let latitude:Double?
    let longitude:Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
