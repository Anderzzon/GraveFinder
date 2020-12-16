import SwiftUI

struct BottomSheetView : View {
    
    enum ShowContent {
        case searchResults, favorites, nothing
    }
    
    @ObservedObject var viewModel : GravesViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favorites: FetchedResults<FavGraves>
    
    @State  var query = ""
    @State internal var isSearching = false
    @State internal var isAutoCompleting = false
    @State internal var selectedGrave:Grave?
    @State internal var offset : CGFloat = 0
    @State internal var searchBarHeight:CGFloat = 130
    @State var pulledUp = false
    @State internal var showContent = ShowContent.nothing
    @State internal var onlyFavorites = 0

    @State internal var selectedIndex = 0
    @State internal var graveOptions = ["All", "Favorites"]
    @State internal var frames = Array<CGRect>(repeating: .zero, count: 2)
    @State var sheetPos = SheetPosition.bottom

    var body: some View{
        BottomSheetModifier(sheetPos: $sheetPos) {_ in
            GeometryReader{reader in
                VStack{
                    SearchViewModifier(readerHeight: reader.frame(in: .global).height)
                    ToggleViewModifier()
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                    ScrollView(.vertical, showsIndicators: true, content: {
                        switch showContent {
                        case .searchResults:
                            SearchGravesModifier()
                        case .favorites:
                            FavGravesModifier()
                        default:
                            EmptyView()
                        }
                    })
                }

            }.ignoresSafeArea(.all, edges: .bottom)
        }


    }
    func setGeometry(geo:GeometryProxy)-> some View{
        searchBarHeight = geo.frame(in: .local).size.height
        return EmptyView()
    }
    internal func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
    internal func setOptions(index: Int){

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
