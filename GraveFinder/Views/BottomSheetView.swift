import SwiftUI

struct BottomSheetView : View {
    
    @ObservedObject var viewModel : BottomSheetViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favorites: FetchedResults<FavGraves>
    

    var body: some View{
        BottomSheetModifier(sheetPos: $viewModel.sheetPos) {_ in
            GeometryReader{ reader in
                VStack{
                    SearchViewModifier(readerHeight: reader.frame(in: .global).height)
                    ToggleViewModifier()
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                    ScrollViewWithOffset(onOffsetChange:{_ in hideKeyboard()}, content: {
                        switch viewModel.showContent {
                        case .searchResults:
                            SearchGravesModifier()
                        case .favorites:
                            FavGravesModifier()
                        default:
                            EmptyView()
                        }
                    }).padding(.bottom, 40)
                }

            }.ignoresSafeArea(.all, edges: .bottom)
        }
    }
    internal func setFrame(index: Int, frame: CGRect) {
        viewModel.frames[index] = frame
    }
    internal func setOptions(index: Int){

        viewModel.selectedIndex = index
        if(index == 0){
            viewModel.showContent = .searchResults
        } else {
            viewModel.showContent = .favorites
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
