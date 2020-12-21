//
//  GravesViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-11-24.
//
import Combine
import SwiftUI

class BottomSheetViewModel: ObservableObject {
    
    enum ShowContent:String { case
        searchResults = "All",
        favorites = "Favorites",
        nothing = ""
    }
    enum SortOptions:String,CaseIterable { case
        name = "Name",
        birthday = "Birthday",
        deathday = "Deathday",
        reset = "Reset",
        clear = ""
    }
    enum Test: CaseIterable {

        static var startBrowsing: LocalizedStringKey {
            return "Start browsing"
        }
    }
    
    @Published var totalGravesSearchResults = [Grave]()
    @Published var selectedGrave:Grave?
    @Published var selectedSortOption:SortOptions = SortOptions.clear
    @Published var favoriteGraves = [Grave]()
    @Published var gravesToDisplayOnMap = [Grave]() //Array to support posibility of multiple graves on map later
    @Published var currentPageForAPIRequest = 1
    @Published var totalPagesInAPIRequest = 0
    @Published var alert:Alert? = nil
    @Published var alertIsPresented:Bool = false
    @Published var contentToDisplayInBottomSheet:ShowContent = .nothing
    @Published var sortOptions:SortOptions = .clear
    @Published var query = ""
    @Published var sheetIsAtTop = false
    @Published var selectedDisplayOption:ShowContent = .searchResults
    @Published var selectedDisplayOptionIndex = 0
    @Published var bottomSheetDisplayOptions:[ShowContent] = [.searchResults, .favorites]

    private var netStatus = NetStatus.shared
    
    var searchResults = SearchResults(graves: [Grave](), pages: 0) {
        didSet {
            totalGravesSearchResults.append(contentsOf: searchResults.graves)
            totalPagesInAPIRequest = searchResults.pages

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
    
    func fetchGraves() {
        guard netStatus.isConnected else { return }
        
        guard currentPageForAPIRequest > 0 else { return }
        
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
            URLQueryItem(name: "page", value: String(currentPageForAPIRequest))
        ]
        
        guard let url = components.url else {return}

        task = URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .replaceError(with: SearchResults(graves: [Grave](), pages: 0))
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \BottomSheetViewModel.searchResults, on: self)
    }

    func insertionSortGraves() {
//        do {
//            try  bubbleUpNilGraves()
//        } catch  {
//            print("ERROR:",error)
//        }

        var data_set = totalGravesSearchResults
        for index in 1..<data_set.count
        {
            let value = data_set[index]
            var position = index

            while position > 0 && data_set[position - 1].deceased! > value.deceased! {
                data_set[position] = data_set[position - 1]
                position -= 1
            }

            data_set[position] = value
        }
        totalGravesSearchResults = data_set
    }
    func bubbleUpNilGraves() {

        var data_set = totalGravesSearchResults
        let last_position = totalGravesSearchResults.count - 1
        var swap = true
        var current:Grave
        var next:Grave

        while swap == true {
             swap = false
            for i in 0..<last_position {
                current = data_set[i]
                next = data_set [i + 1]

                switch selectedSortOption {
                case .name:
                    if current.deceased! > next.deceased! {
                        data_set [i + 1] = current
                        data_set[i] = next

                        swap = true
                    }
                case .birthday:
                    if current.dateOfBirth == nil{
                        data_set [i + 1] = current
                        data_set[i] = next

                        swap = true
                    }
                default:
                    continue
                }
            }
        }
        totalGravesSearchResults = data_set
    }

    func sendNilToEnd(checkParam:SortOptions) -> [Grave] {
        var sortedGraves = totalGravesSearchResults
        for i in 0...sortedGraves.count-1 {
            print("Sorted:",sortedGraves[i].dateOfBirth ?? "NIIIIL")
        }
        switch checkParam {
        case .birthday:
            for i in 0...totalGravesSearchResults.count-1 {
                let grave = totalGravesSearchResults[i]

                if totalGravesSearchResults[i].dateOfBirth == nil {
                    sortedGraves.remove(at: i)
                    sortedGraves.insert(grave, at: sortedGraves.endIndex)
                }
            }

        case .deathday:
            for i in 0...totalGravesSearchResults.count-1 {
                let grave = totalGravesSearchResults[i]

                if totalGravesSearchResults[i].dateOfDeath == nil {
                    sortedGraves.remove(at: i)
                    sortedGraves.insert(grave, at: sortedGraves.endIndex)
                }
            }
        default:
            sortedGraves = totalGravesSearchResults
        }
        for i in 0...sortedGraves.count-1 {
            print("Sortedddd:",sortedGraves[i].dateOfBirth ?? "NUUUUL")
        }
        return sortedGraves
    }
    
    static func getMemorialLocation(for cemetery:String) -> (latitude:Double, longitude:Double){
        let location = staticMemorials[cemetery.lowercased()] ?? (latitude:0, longitude:0)
        return location
    }
    static func getCemeteryLocation(for cemetery:String) -> (latitude:Double, longitude:Double){
        let location = staticCemeteries[cemetery.lowercased()] ?? (latitude:0, longitude:0)
        return location
    }
    func setAlert(alert:Alert){
        self.alert = alert
        self.alertIsPresented = true
    }
    func removeAlert(){
        self.alertIsPresented = false
        self.alert = nil
    }
    func contentToShow(set content:ShowContent){
        selectedDisplayOption = content
        if(content == .favorites){
            selectedDisplayOptionIndex = 1
            contentToDisplayInBottomSheet = .favorites
        }else {
            selectedDisplayOptionIndex = 0
            contentToDisplayInBottomSheet = .searchResults
        }
    }
    
}

