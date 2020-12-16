//
//  MapViewModel.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-16.
//

import Foundation
import Combine
import SwiftUI

class MapViewModel: ObservableObject {
    
    @Binding var selectedGrave:Grave?
    
    init(selectedGrave:Binding<Grave?>) {
        self._selectedGrave = selectedGrave
    }
    
}
