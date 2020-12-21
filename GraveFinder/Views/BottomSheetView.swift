import SwiftUI

struct BottomSheetView : View {

    @EnvironmentObject var viewModel : BottomSheetViewModel
    @State var showFilterSheet: Bool = false

    //If you remove this fix for search click doesn't work
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavGraves.deceased, ascending: true)],
        animation: .default)
    var favoritess: FetchedResults<FavGraves>

    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Sort by"), message: Text("Choose Option"), buttons: [
            .default(Text("Date of birth"),action: {
                viewModel.selectedSortOption = .birthday
            }),
            .default(Text("Date of death"),action: {
                viewModel.selectedSortOption = .deathday
            }),
            .destructive(Text("Reset"),action: {
                viewModel.selectedSortOption = .reset
            })
        ])
    }
    var body: some View{
        BottomSheetPositionModifier() {
            GeometryReader{ reader in
                VStack{
                    HStack{
                        SearchBarView(readerHeight: reader.frame(in: .global).height){
                            EmptyView()
                        }

                        Button(action: {

                            let option = self.showFilterSheet ? BottomSheetViewModel.SortOptions.reset : BottomSheetViewModel.SortOptions.name
                            self.showFilterSheet.toggle()
                            viewModel.selectedSortOption = option
                            viewModel.insertionSortGraves()
                        }){
                            let icon = self.showFilterSheet ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle"
                            Image(systemName: icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
//                        .actionSheet(isPresented: $showFilterSheet, content: {
//                            self.actionSheet
//                        })
                    }
                    ToggleView(){
                        EmptyView()
                    }
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
