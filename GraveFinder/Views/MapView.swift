//
//  MapView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    //@State internal var region: MKCoordinateRegion?
    //@State internal var mapType: MKMapType = .standard

    //@State internal var annotations = [Grave]()
    @State internal var showGraveDeatil = false

    //@State internal var selectedIndex = 0
    //@State internal var mapOptions = ["Standard","Satelite","Hybrid"]
    @State internal var frames = Array<CGRect>(repeating: .zero, count: 3)

    init(graves: [Grave]) {
        self.viewModel = MapViewModel(selectedGraves: graves)
    }
    
    var body: some View {
        ZStack(alignment: .top){
            ZStack {
                MapViewUI(showGraveDetail: $showGraveDeatil, viewModel: viewModel).edgesIgnoringSafeArea(.all)
                if showGraveDeatil {
                    NavigationModifier()
                }
                
            }
            MapPickrsView()
                .foregroundColor(Color.black)
                .padding()

            Spacer()
        }
//        .alert(isPresented: $showGraveDeatil, content: {
//            print("Alert navigation")
//            let name = viewModel.selectedGraves[0].title ?? "Grave"
//            return Alert(title: Text(name), message: Text("Vill du öppna Maps och navigera till \(name)?"), primaryButton: .default(Text("OK")) {
//                navigate()
//            }, secondaryButton: .cancel())
//        })
    }
//    func navigate() {
//
//        let graveAnnotation = viewModel.selectedGraves[0]
//        let placemark = MKPlacemark(coordinate: graveAnnotation.coordinate, addressDictionary: nil)
//        let mapItem = MKMapItem(placemark: placemark)
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
//        mapItem.name = placemark.title
//        mapItem.openInMaps(launchOptions: launchOptions)
//    }
    func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
}


//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
