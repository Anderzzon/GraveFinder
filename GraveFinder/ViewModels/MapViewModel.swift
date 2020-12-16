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
    
    @Binding var selectedGraves:[Grave]
    
    init(selectedGraves:Binding<[Grave]>) {
        self._selectedGraves = selectedGraves
    }
    
}
