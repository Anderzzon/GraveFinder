//
//  GravesViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//
import Combine
import SwiftUI

class GravesViewModel: ObservableObject {
    
    @Published var graves:[Grave] = [] {
        didSet {
            print(graves)
        }
    }
    var task : AnyCancellable?
    
    func fetchGraves(for query:String) {
        let url = URL(string: "https://etjanst.stockholm.se/Hittagraven/ajax/search?SearchText=\(query)")
        task = URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .map { $0.graves }
            .map { $0.filter { grave in
                return self.validate(grave)
                }
            }
            .replaceError(with: [Grave]())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \GravesViewModel.graves, on: self)
    }
    func validate(_ grave:Grave) -> Bool {
        return grave.location.lat != nil && grave.location.lon != nil && grave.deceased != nil
    }
    
}

