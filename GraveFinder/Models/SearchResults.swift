//
//  Results.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//

import Foundation
struct SearchResults: Decodable, Hashable {
    var graves:[Grave]
    var pages:Int

    enum CodingKeys: String, CodingKey {
        case graves = "items"
        case pages
    }
    
    init(graves:[Grave], pages:Int){
        self.graves = graves
        self.pages = pages
    }
    
    init(from decoder:Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        pages = try container.decode(Int.self, forKey: .pages)
        graves = try container.decode([Grave].self, forKey: .graves)
    }
}
