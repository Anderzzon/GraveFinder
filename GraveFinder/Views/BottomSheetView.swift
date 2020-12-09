import SwiftUI

struct BottomSheet : View {
    
    enum ShowContent {
        case searchResults, nothing
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
    @State var refresh = false
    @State var offset : CGFloat = 0
    @State var pulledUp = false
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
                .padding(.vertical,10)
                .padding(.horizontal)
                // BlurView....
                // For Dark Mode Adoption....
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(15)
                .padding()
                
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
                    default:
                        EmptyView()
                    }
                })
            }
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
            .offset(y: reader.frame(in: .global).height - 140)
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
