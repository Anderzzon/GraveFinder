//
//  MapView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: BottomSheetViewModel
    @State internal var region: MKCoordinateRegion?
    @State internal var mapType: MKMapType = .standard

    @State internal var annotations = [Grave]()
    @State internal var showGraveDeatil = false

    @State internal var selectedIndex = 0
    @State internal var mapOptions = [NSLocalizedString("standard", comment: "Standard"),NSLocalizedString("satellite", comment: "Satellite"),NSLocalizedString("hybrid", comment: "Hybrid")]
    @State internal var frames = Array<CGRect>(repeating: .zero, count: 3)

    init(viewModel: BottomSheetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top){
            MapViewUI(showGraveDetail: $showGraveDeatil, graves: viewModel.selectedGraves, mapViewType: mapType).edgesIgnoringSafeArea(.all)

            MapPickrsView()
                .foregroundColor(Color.black)
                .padding()

            Spacer()
        }
        .alert(isPresented: $showGraveDeatil, content: {
            let name = viewModel.selectedGraves[0].title ?? "Grave"
            return Alert(title: Text(name), message: Text("\(NSLocalizedString("navigation_to_map_confirmation", comment: "Navigation confirmation")) \(name)?"), primaryButton: .default(Text(NSLocalizedString("ok", comment: "OK"))) {
                navigate()
            }, secondaryButton: .cancel())
        })
    }
    func navigate() {
        
        let graveAnnotation = viewModel.selectedGraves[0] 
        let placemark = MKPlacemark(coordinate: graveAnnotation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        mapItem.name = placemark.title
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
    func setMapType(index: Int){

        self.selectedIndex = index
        switch index {
        case 0:
            mapType = .standard
        case 1:
            mapType = .satellite
        case 2:
            mapType = .hybrid
        default:
            mapType = .standard
        }
    }
}


//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
