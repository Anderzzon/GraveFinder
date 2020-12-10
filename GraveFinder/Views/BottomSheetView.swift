import SwiftUI

struct BottomSheet : View {
    
    enum ShowContent {
        case searchResults, favorites, nothing
    }
    
    @ObservedObject var viewModel : GravesViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favorites: FetchedResults<FavGraves>
    
    @State  var query = ""
    @State private var isSearching = false
    @State private var isAutoCompleting = false
    @State private var selectedGrave:Grave?
    @State private var offset : CGFloat = 0
    @State private var searchBarHeight:CGFloat = 130
    @State var pulledUp = false
    @State private var showContent = ShowContent.nothing
    @State private var onlyFavorites = 0

    @State private var selectedIndex = 0
    @State private var graveOptions = ["All", "Favorites"]
    @State private var frames = Array<CGRect>(repeating: .zero, count: 2)
    
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
                        .foregroundColor(.gray)
                    TextField("Search...", text: $query,onEditingChanged: {EditMode in

                        if(!self.pulledUp){
                            offset = (-reader.frame(in: .global).height + searchBarHeight)
                            self.pulledUp = true
                        }
                        if(!EditMode){
                            self.pulledUp = false
                        }
                    }, onCommit: {
                        viewModel.currentPage = 1
                        viewModel.totalGravesList.removeAll()
                        viewModel.fetchGraves(for: query, at: viewModel.currentPage)

                    })
                    .onChange(of: query, perform: { _ in
                        self.setOptions(index: 0)
                        if onlyFavorites == 1{
                            onlyFavorites = 0
                            showContent = .searchResults
                        }
                        viewModel.currentPage = 1
                        viewModel.selectedGraves.removeAll()
                        if(query.count > 0){
                            viewModel.totalGravesList.removeAll()
                            viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                            showContent = .searchResults
                        } else {
                            showContent = .nothing
                        }
                    })
                    .disableAutocorrection(true)
                }
                .padding()
                .padding(.horizontal,10)
                .background(
                    Capsule().fill(Color.gray.opacity(0.2)),
                    alignment: .leading
                )
                VStack{
                    HStack(spacing: 10) {
                        ForEach(self.graveOptions.indices, id: \.self) { index in
                            Button(action: {setOptions(index: index)}) {
                                Text(self.graveOptions[index])
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
                    .background(Capsule().stroke(Color.gray, lineWidth: 0.2))

                }

                .background(
                    Capsule().fill(
                        Color.white.opacity(0.4))
                    , alignment: .leading
                )

                .foregroundColor(Color.black)
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                ScrollView(.vertical, showsIndicators: true, content: {
                    switch showContent {
                    case .searchResults:
                        LazyVStack(alignment: .leading, spacing: 5, content:{
                            ForEach(viewModel.totalGravesList){
                                grave in
                                
                                GravesView(for: grave, selectedGrave: $selectedGrave, disabledIf: !grave.isLocatable(), offset: $offset, viewModel: viewModel)
                            }
                            if viewModel.totalPages > 1 && viewModel.currentPage < viewModel.totalPages {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Button(action: {
                                        viewModel.currentPage += 1
                                        viewModel.fetchGraves(for: query, at: viewModel.currentPage)
                                    }, label: {
                                        Text("Visa fler...")
                                    }).padding(.bottom, 40)
                                    Spacer()
                                }
                            } else {
                                HStack{
                                    Spacer()
                                    Text("Slut på resultat...")
                                        .font(.caption2)
                                        .padding(.bottom, 40)
                                    Spacer()
                                }
                            }
                        })
                    case .favorites:
                        LazyVStack(alignment: .leading, spacing: 5, content:{
                            ForEach(favorites){
                                favorite in
                                let grave = Grave(favorite: favorite)
                                GravesView(for: grave, selectedGrave: $selectedGrave, disabledIf: false, offset: $offset, viewModel: viewModel)
                            }
                            
                        })
                    default:
                        EmptyView()
                    }
                })
            }
            .padding()
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
            .offset(y: reader.frame(in: .global).height - searchBarHeight)
            .offset(y: offset)
            .gesture(DragGesture().onChanged({ (value) in
                withAnimation{
                    if value.startLocation.y > reader.frame(in: .global).midX{
                        if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + searchBarHeight){
                            offset = value.translation.height
                        }
                    }
                    if value.startLocation.y < reader.frame(in: .global).midX{
                        if value.translation.height > 0 && offset < 0{
                            offset = (-reader.frame(in: .global).height + searchBarHeight) + value.translation.height
                        }
                    }
                }
            }).onEnded({ (value) in
                withAnimation{
                    if value.startLocation.y > reader.frame(in: .global).midX{
                        self.pulledUp = false
                        if -value.translation.height > reader.frame(in: .global).midX{
                            offset = (-reader.frame(in: .global).height + searchBarHeight)
                            return
                        }
                        offset = 0
                    }
                    if value.startLocation.y < reader.frame(in: .global).midX{
                        if value.translation.height < reader.frame(in: .global).midX{
                            offset = (-reader.frame(in: .global).height + searchBarHeight)
                            return
                        }
                    }
                }
            }))
        }.ignoresSafeArea(.all, edges: .bottom)
    }
    func setGeometry(geo:GeometryProxy)-> some View{
        searchBarHeight = geo.frame(in: .local).size.height
        return EmptyView()
    }
    private func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
    private func setOptions(index: Int){

        self.selectedIndex = index
        if(index == 0){
            showContent = .searchResults
        } else {
            showContent = .favorites
        }
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
