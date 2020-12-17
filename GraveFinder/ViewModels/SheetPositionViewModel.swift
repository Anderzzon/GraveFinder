//
//  SheetPositionViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-17.
//

import UIKit
class SheetPositionViewModel:ObservableObject {
    @Published private(set) var top:CGFloat = 10
    @Published private(set) var middle:CGFloat = 400
    @Published private(set) var bottom:CGFloat = 680
    @Published var sheetPosition = SheetPosition.bottom

    func setTop(to value:CGFloat){
        self.top = value
    }
    func setMiddle(to value:CGFloat){
        self.middle = value
    }
    func setBottom(to value:CGFloat){
        self.bottom = value
    }
}
