//
//  BottomSheetView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-11-25.
//

import SwiftUI

struct BottomSheetView : View {
    
    @ObservedObject var viewModel : GravesViewModel
    
    @State var offset : CGFloat = 0
    
    var body: some View{
        
        /// to read frame height...
        
        GeometryReader{reader in
            
            VStack{
                
                BottomSheet(viewModel:viewModel,offset: $offset, value: (-reader.frame(in: .global).height + 150))
                    .offset(y: reader.frame(in: .global).height - 150)
                    // adding gesture....
                    .offset(y: offset)
                    .gesture(DragGesture().onChanged({ (value) in
                        
                        withAnimation{
                            
                            // checking the direction of scroll....
                            
                            // scrolling upWards....
                            // using startLocation bcz translation will change when we drag up and down....
                            
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
                            
                            // checking and pulling up the screen...
                            
                            if value.startLocation.y > reader.frame(in: .global).midX{
                                
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
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        
    }
}

struct BottomSheet : View {
    @ObservedObject var viewModel : GravesViewModel
    //    @Binding var searchTxt:String
    
    @State  var query = ""
    @State private var isSearching = false
    @State private var isAutoCompleting = false
    @State private var selectedGrave:Grave? = nil
    
    @Binding var offset : CGFloat
    var value : CGFloat
    
    @State var output: String = ""
    @State var input: String = ""
    @State var typing = false
    
    enum ShowContent {
        case searchResults, noResults, nothing
    }
    @State private var showContent = ShowContent.nothing
    
    var body: some View{
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
                TextField("Search...", text: $query, onCommit: {
                    viewModel.currentPage = 1
                    viewModel.totalGravesList.removeAll()
                    viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                    
                }).onChange(of: query, perform: { _ in
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
                
                //                { (status) in
                //
                //                    withAnimation{
                //
                //                        offset = value
                //                    }
                //
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            // BlurView....
            // FOr Dark Mode Adoption....
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
            .padding()
            
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
                            AutoCompleteText(for: grave, andHighLightIf: isSelectedGrave)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    viewModel.selectedGraves.removeAll()
                                    selectedGrave = grave
                                    offset = 0
                                    let graveLocation = viewModel.createGraveLocation(name: grave.deceased!, latitude: grave.location.latitude!, longitude: grave.location.longitude!, birth: grave.dateOfBirth ?? "", death: grave.dateOfDeath ?? "")
                                    offset = 0
                                    let graveLocation = viewModel.createGraveLocation(name: grave.deceased!, latitude: grave.location.latitude!, longitude: grave.location.longitude!, birth: grave.dateOfBirth ?? "", death: grave.dateOfDeath ?? "")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        viewModel.selectedGraves.append(graveLocation)
                                        print("Dead person: \(graveLocation) added")
                                    }
                                    
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
        }
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(15)
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
