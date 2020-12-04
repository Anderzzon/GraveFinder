//
//  GravesViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//
import Combine
import SwiftUI
import CoreData


class GravesViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Published var totalGravesList = [Grave]()
    @Published var selectedGraves = [GraveLocation]() //Array to support posibility of multiple graves on map later
    @Published var favoriteGraves = [Grave]()
    @Published var currentPage = 1
    @Published var totalPages = 0
    @State var latestQuery = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<FavGraves> {
        didSet {
            print(favorites)
        }
    }
    
    var searchResults = SearchResults(graves: [Grave](), pages: 0) {
        didSet {
            totalGravesList.append(contentsOf: searchResults.graves)
            totalPages = searchResults.pages
        }
    }
    
    static private let staticMemorials:[String:(latitude:Double,longitude:Double)] = [
        "skogskyrkogården":(latitude: 59.2782585, longitude: 18.0961542),
        "brännkyrka kyrkogård":(latitude: 59.2826874, longitude: 18.0219386),
        "spånga kyrkogård":(latitude: 59.3924017, longitude: 17.9134938),
        "bromma kyrkogård":(latitude: 59.3551232, longitude: 17.9198294),
        "hässelby begravningsplats":(latitude: 59.3646032, longitude: 17.8252801),
        "strandkyrkogården":(latitude: 59.234783, longitude: 18.1831843),
        "råcksta begravningsplats":(latitude: 59.354962, longitude: 17.8671203),
        "norra begravningsplatsen":(latitude: 59.356501, longitude: 18.0182928),
        "galärvarvskyrkogården":(latitude: 59.32787, longitude: 18.0942288)
    ]
    static private let staticCemeteries:[String:(latitude:Double,longitude:Double)] = [
        "skogskyrkogården":(latitude: 59.271181, longitude: 18.102697),
        "brännkyrka kyrkogård":(latitude: 59.282616, longitude: 18.024034),
        "spånga kyrkogård":(latitude: 59.391942, longitude: 17.911400),
        "bromma kyrkogård":(latitude: 59.355133, longitude: 17.920238),
        "hässelby begravningsplats":(latitude: 59.362864, longitude: 17.827611),
        "strandkyrkogården":(latitude: 59.237168, longitude: 18.186855),
        "råcksta begravningsplats":(latitude: 59.355020, longitude: 17.869861),
        "norra begravningsplatsen":(latitude: 59.355668, longitude: 18.023853),
        "galärvarvskyrkogården":(latitude: 59.328077, longitude: 18.093972)
    ]
    
    
    var task : AnyCancellable?
    
    func fetchGraves(for query:String, at page: Int) {
        latestQuery = query
        guard page > 0 else { return }
        
        let searchQuery = query.lowercased()
            .replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "+")
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "etjanst.stockholm.se"
        components.path = "/Hittagraven/ajax/search"
        components.queryItems = [
            URLQueryItem(name: "searchtext", value: searchQuery),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = components.url else {return}
        
        task = URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .replaceError(with: SearchResults(graves: [Grave](), pages: 0))
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \GravesViewModel.searchResults, on: self)
    }
    func createGraveLocation(name: String, latitude: Double, longitude: Double, birth: String, death: String) -> GraveLocation {
        let graveLocation = GraveLocation(name: name, latitude: latitude, longitude: longitude, birth: birth, death: death)
        return graveLocation
    }
    func toggleToFavorites(grave:Grave){
        
        if favorites.contains(where: {$0.id == grave.id}){
            self.deleteItems(grave: grave)
        } else {
            self.addItem(grave: grave)
        }
    }
    static func getMemorialLocation(for cemetery:String) -> (latitude:Double, longitude:Double){
        let location = staticMemorials[cemetery.lowercased()] ?? (latitude:0, longitude:0)
        return location
    }
    static func getCemeteryLocation(for cemetery:String) -> (latitude:Double, longitude:Double){
        let location = staticCemeteries[cemetery.lowercased()] ?? (latitude:0, longitude:0)
        return location
    }
    func addItem(grave:Grave) {
        
        guard let entity = NSEntityDescription(
            let newFav = FavGraves(context: viewContext)
            newFav.id = grave.id ?? ""
            newFav.deceased = grave.deceased ?? "Ej namngiven"
            newFav.cemetery = grave.cemetery ?? "Ej specificerad"
            newFav.dateBuried = grave.dateBuried ?? "Ej specificerad"
            newFav.dateOfBirth = grave.dateOfBirth ?? "Ej specificerad"
            newFav.dateOfDeath = grave.dateOfDeath ?? "Ej specificerad"
            newFav.graveType = grave.graveType ?? "Ej specificerad"
            newFav.latitude = grave.latitude!
            newFav.longitude = grave.longitude!

            print(newFav)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
    }

    func deleteItems(grave: Grave) {
        
            guard let index = favorites.firstIndex(where: {$0.id == grave.id}) else {return}
            viewContext.delete(favorites[index])
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
    }
}

