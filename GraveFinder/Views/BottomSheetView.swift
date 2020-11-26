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
                    .offset(y: reader.frame(in: .global).height - 140)
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
                                
                                offset = 0
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
    
    @State  var txt = ""
    @State var searchTxt = ""
    @Binding var offset : CGFloat
    var value : CGFloat
    
    @State var output: String = ""
    @State var input: String = ""
    @State var typing = false
    
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
                
                TextField("Search...", text: $txt, onEditingChanged: {_ in
                    
                }, onCommit: {
                    self.searchTxt = self.txt
                    self.viewModel.fetchGraves(for: self.searchTxt, atPage: 1)
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
            
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                LazyVStack(alignment: .leading, spacing: 15, content: {
                    ForEach(viewModel.searchResults.graves,id:\.self){ grave in
                        GraveView(grave: grave)
                    }
                })
                .padding()
                .padding(.top)
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
