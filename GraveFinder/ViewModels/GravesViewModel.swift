//
//  GravesViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//
import Combine
import SwiftUI

class GravesViewModel: ObservableObject {
    private let url = URL(string: "https://etjanst.stockholm.se/Hittagraven/ajax/search?SearchText=13888")
    
    @Published var graves:[Grave] = [] {
        didSet {
            print(graves)
        }
    }
    var task : AnyCancellable?
    
    func fetchGraves() {
        task = URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .map { $0.graves }
            .replaceError(with: [Grave]())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \GravesViewModel.graves, on: self)
        
    }
    
}

