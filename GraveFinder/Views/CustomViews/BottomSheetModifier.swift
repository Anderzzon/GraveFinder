////
////  BottomSheetModifier.swift
////  GraveFinder
////
////  Created by Shafigh Khalili on 2020-12-14.
////
//
//import SwiftUI
//
//internal extension BottomSheetView{
//
//    @ViewBuilder func BottomSheetModifier(readerHeight:CGFloat) -> some View {
//        self
//            .padding()
//            .background(BlurView(style: .systemMaterial))
//            .cornerRadius(15)
//            .offset(y: readerHeight - searchBarHeight)
//            .offset(y: offset)
//            .gesture(DragGesture().onChanged({ (value) in
//                withAnimation{
//                    if value.startLocation.y > reader.frame(in: .global).midX{
//                        if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + searchBarHeight){
//                            offset = value.translation.height
//                        }
//                    }
//                    if value.startLocation.y < reader.frame(in: .global).midX{
//                        if value.translation.height > 0 && offset < 0{
//                            offset = (-reader.frame(in: .global).height + searchBarHeight) + value.translation.height
//                        }
//                    }
//                }
//            }).onEnded({ (value) in
//                withAnimation{
//                    if value.startLocation.y > reader.frame(in: .global).midX{
//                        self.pulledUp = false
//                        if -value.translation.height > reader.frame(in: .global).midX{
//                            offset = (-reader.frame(in: .global).height + searchBarHeight)
//                            return
//                        }
//                        offset = 0
//                    }
//                    if value.startLocation.y < reader.frame(in: .global).midX{
//                        if value.translation.height < reader.frame(in: .global).midX{
//                            offset = (-reader.frame(in: .global).height + searchBarHeight)
//                            return
//                        }
//                    }
//                }
//            }))
//    }
//
//}
