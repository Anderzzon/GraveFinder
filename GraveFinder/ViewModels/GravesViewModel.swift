//
//  GravesViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//
import Combine
import SwiftUI

class GravesViewModel: ObservableObject {
    
    @Published var totalList = [Grave]()
    
    var searchResults = SearchResults(graves: [Grave](), pages: 0) {
        didSet {
            totalList.append(contentsOf: searchResults.graves)
        }
    }
    @Published var selectedGraves = [GraveLocation]() //Array to support posibility of multiple graves on map later
    var task : AnyCancellable?
    
    func fetchGraves(for query:String, atPage page: Int) {
        guard page > 0 else { return }
        let parsedQuery = query.replacingOccurrences(of: " ", with: "+")
        let endpoint = "https://etjanst.stockholm.se/Hittagraven/ajax/search?SearchText=" + parsedQuery + "&page=" + "\(page)"
        guard let url = URL(string: endpoint) else { return }
        
        task = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .map { searchResults in
                var filteredGraves = searchResults.graves.filter{ grave in
                    return self.validate(grave)
                    }
                let pages = searchResults.pages
                if filteredGraves.count < 1 {
                    filteredGraves = [Grave]()
                }
                return SearchResults(graves: filteredGraves, pages: pages)
            }
            .replaceError(with: SearchResults(graves: [Grave](), pages: 0))
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \GravesViewModel.searchResults, on: self)
            
    }
    func validate(_ grave:Grave) -> Bool {
        return grave.location.latitude != nil && grave.location.longitude != nil && grave.deceased != nil
    }
    
}

