//
//  BottomSheetView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-11-25.
//

import SwiftUI

struct BottomSheet : View {
    @ObservedObject var viewModel : GravesViewModel
    //    @Binding var searchTxt:String
    
    @State  var query = ""
    @State private var isSearching = false
    @State private var isAutoCompleting = false
    @State private var selectedGrave:Grave? = nil
    @State private var isDisabled = false
    //@Binding var offset : CGFloat
    //var value : CGFloat
    
    @State var output: String = ""
    @State var input: String = ""
    @State var typing = false
    
    @State var searchTxt = ""
    //	@Binding var offset : CGFloat
    @State var offset : CGFloat = 0
    @State var pulledUp = false
    @State private var currentPage = 0
    
    enum ShowContent {
        case searchResults, noResults, nothing
    }
    @State private var showContent = ShowContent.nothing
    
    var body: some View{
        GeometryReader{reader in
            VStack{
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 50, height: 5)
                    .padding(.top)
                    .padding(.bottom,5)
                HStack(spacing: 15){
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                    TextField("Search...", text: $query,onEditingChanged: {EditMode in
                        
                        if(!self.pulledUp){
                            offset = (-reader.frame(in: .global).height + 150)
                            self.pulledUp = true
                        }
                        if(!EditMode){
                            self.pulledUp = false
                        }
                    }, onCommit: {
                        viewModel.currentPage = 1
                        viewModel.totalGravesList.removeAll()
                        viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                        
                    }).onChange(of: query, perform: { _ in
                        print(query)
                        viewModel.currentPage = 1
                        viewModel.selectedGraves.removeAll()
                        if(query.count > 0){
                            viewModel.totalGravesList.removeAll()
                            viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                            showContent = .searchResults
                        } else {
                            showContent = .noResults
                        }
                    })
                }
                .padding(.vertical,10)
                .padding(.horizontal)
                // BlurView....
                // FOr Dark Mode Adoption....
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(15)
                .padding()
                ZStack{
                    ScrollView(.vertical, showsIndicators: true, content: {
                        switch showContent {
                        case .noResults:
                            Text("No results")
                                .font(.system(.headline))
                        case .searchResults:
                            LazyVStack(alignment: .leading, spacing: 5, content:{
                                ForEach(viewModel.totalGravesList){
                                    grave in
                                    let isSelectedGrave = grave == selectedGrave
                                    
                                    if let latitude = grave.location.latitude,
                                       let longitude = grave.location.longitude {
                                        
                                        AutoCompleteText(for: grave, andHighLightIf: isSelectedGrave, isDisabled: false)
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                viewModel.selectedGraves.removeAll()
                                                selectedGrave = grave
                                                offset = 0
                                                let graveLocation = viewModel.createGraveLocation(name: grave.deceased ?? "Ej specificierad", latitude: latitude, longitude: longitude, birth: grave.dateOfBirth ?? "", death: grave.dateOfDeath ?? "")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    viewModel.selectedGraves.append(graveLocation)
                                                    print("Dead person: \(graveLocation) added")
                                                }
                                            }
                                    } else if let cemetery = grave.cemetery {
                                        if grave.graveType != nil && grave.graveType == "memorial" {
                                            
                                            AutoCompleteText(for: grave, andHighLightIf: isSelectedGrave, isDisabled: false)
                                                .foregroundColor(.black)
                                                .onTapGesture {
                                                    viewModel.selectedGraves.removeAll()
                                                    selectedGrave = grave
                                                    offset = 0
                                                    
                                                    if let memorialLocation = viewModel.staticMemorials[cemetery] {
                                                        let graveLocation = viewModel.createGraveLocation(name: grave.deceased ?? "Ej specificierad", latitude: memorialLocation.latitude!, longitude: memorialLocation.longitude!, birth: grave.dateOfBirth ?? "", death: grave.dateOfDeath ?? "")
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                            viewModel.selectedGraves.append(graveLocation)
                                                            print("Dead person: \(graveLocation) added")
                                                        }
                                                        
                                                    }
                                                }
                                        } else {
                                            AutoCompleteText(for: grave, andHighLightIf: isSelectedGrave, isDisabled: false)
                                                .foregroundColor(.black)
                                                .onTapGesture {
                                                    viewModel.selectedGraves.removeAll()
                                                    selectedGrave = grave
                                                    offset = 0
                                                    
                                                    if let cemeteryLocation = viewModel.staticCemeteries[cemetery] {
                                                        let graveLocation = viewModel.createGraveLocation(name: grave.deceased ?? "Ej specificierad", latitude: cemeteryLocation.latitude!, longitude: cemeteryLocation.longitude!, birth: grave.dateOfBirth ?? "", death: grave.dateOfDeath ?? "")
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                            viewModel.selectedGraves.append(graveLocation)
                                                            print("Dead person: \(graveLocation) added")
                                                        }
                                                        
                                                    }
                                                }
                                        }
                                    } else {
                                        AutoCompleteText(for: grave, andHighLightIf: isSelectedGrave, isDisabled: true)
                                    }
                                }
                                LazyHStack(alignment: .center) {
                                    Spacer()
                                    Text("Loading more...").padding().onAppear {
                                        viewModel.currentPage += 1
                                        viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                                    }
                                    Spacer()
                                }
                            })
                        default:
                            EmptyView()
                        }
                        
                    })
                    VStack{
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                self.currentPage += 1
                                viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                            }){
                                Image(systemName: "ellipsis.circle.fill").imageScale(.large)
                                    .font(.system(.largeTitle))
                                    .frame(width: 77, height: 70)
                                    .foregroundColor(Color.blue)
                                    .padding(.bottom, 7)
                            }
                        }
                    }
                }
            }
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
            .offset(y: reader.frame(in: .global).height - 150)
            .offset(y: offset)
            .gesture(DragGesture().onChanged({ (value) in
                withAnimation{
                    if value.startLocation.y > reader.frame(in: .global).midX{
                        if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + 150){
                            offset = value.translation.height
                        }
                    }
                    if value.startLocation.y < reader.frame(in: .global).midX{
                        if value.translation.height > 0 && offset < 0{
                            offset = (-reader.frame(in: .global).height + 150) + value.translation.height
                        }
                    }
                }
            }).onEnded({ (value) in
                withAnimation{
                    if value.startLocation.y > reader.frame(in: .global).midX{
                        self.pulledUp = false
                        if -value.translation.height > reader.frame(in: .global).midX{
                            offset = (-reader.frame(in: .global).height + 150)
                            return
                        }
                        offset = 0
                    }
                    if value.startLocation.y < reader.frame(in: .global).midX{
                        if value.translation.height < reader.frame(in: .global).midX{
                            offset = (-reader.frame(in: .global).height + 150)
                            return
                        }
                    }
                }
            }))
        }.ignoresSafeArea(.all, edges: .bottom)
    }
}

struct BlurView : UIViewRepresentable {
    var style : UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView{
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}
