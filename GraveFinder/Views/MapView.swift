//
//  MapView.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-11-24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: GravesViewModel
    @State private var region: MKCoordinateRegion?
    @State private var mapType: MKMapType = .standard
    
    @State private var annotations = [Grave]()
    @State private var showGraveDeatil = false

    @State private var selectedIndex = 0
    @State private var mapOptions = ["Standard","Satelite","Hybrid"]
    @State private var frames = Array<CGRect>(repeating: .zero, count: 3)
    init(viewModel: GravesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top){
            MapViewUI(showGraveDetail: $showGraveDeatil, graves: viewModel.selectedGraves, mapViewType: mapType).edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading){
                HStack(spacing: 10) {
                    ForEach(self.mapOptions.indices, id: \.self) { index in
                        Button(action: {setMapType(index: index)}) {
                            Text(self.mapOptions[index])
                        }
                        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                        .background(
                            GeometryReader { geo in
                                Color.clear.onAppear { self.setFrame(index: index, frame: geo.frame(in: .global)) }
                            }
                        )
                        .foregroundColor(Color.black).font(.caption)
                    }
                }
                .background(
                    Capsule().fill(
                        Color.white.opacity(0.8))
                        .frame(width: self.frames[self.selectedIndex].width,
                               height: self.frames[self.selectedIndex].height, alignment: .topLeading)
                        .offset(x: self.frames[self.selectedIndex].minX - self.frames[0].minX)
                    , alignment: .leading
                )
                .animation(.default)
                .background(Capsule().stroke(Color.gray, lineWidth: 0.2))

            }
            .background(
                Capsule().fill(
                    Color.white.opacity(0.4))
                , alignment: .leading
            )
            .foregroundColor(Color.black)
            Spacer()
        }
        .alert(isPresented: $showGraveDeatil, content: {
            let name = viewModel.selectedGraves[0].title ?? "Grave"
            return Alert(title: Text(name), message: Text("Vill du öppna Maps och navigera till \(name)?"), primaryButton: .default(Text("OK")) {
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
    private func setMapType(index: Int){

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
