import SwiftUI

struct BottomSheetView : View {

    @EnvironmentObject var viewModel : BottomSheetViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favorites: FetchedResults<FavGraves>

    var body: some View{
        BottomSheetPositionModifier() {
            GeometryReader{ reader in
                VStack{
                    SearchBarView(readerHeight: reader.frame(in: .global).height)
                    ToggleView()
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                    ScrollViewWithOffset(onOffsetChange:{_ in hideKeyboard()}, content: {
                        switch viewModel.contentToDisplayInBottomSheet {
                        case .searchResults:
                            SearchResultsView()
                        case .favorites:
                            FavoritesResultsView()
                        default:
                            EmptyView()
                        }
                    }).padding(.bottom, 40)
                }
            }.ignoresSafeArea(.all, edges: .bottom)
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
