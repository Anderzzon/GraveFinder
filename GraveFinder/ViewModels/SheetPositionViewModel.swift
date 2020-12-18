//
//  SheetPositionViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-17.
//

import UIKit
class SheetPositionViewModel:ObservableObject {
    @Published var top:CGFloat = 10
    @Published var middle:CGFloat
    @Published var bottom:CGFloat
    @Published var sheetPosition:CGFloat
    
    init (middle:CGFloat, bottom:CGFloat, initialPosition:CGFloat){
        self.middle = middle
        self.bottom = bottom
        self.sheetPosition = initialPosition
    }
    
    func initSheetToBottom(){
        sheetPosition = bottom
    }
}
