//
//  GraveFinderTests.swift
//  GraveFinderTests
//
//  Created by Erik Westervind on 2020-12-20.
//

import XCTest
import MapKit
@testable import GraveFinder

class GraveFinderTests: XCTestCase {


    func test_map_type() {
        let vm = MapViewModel(selectedGraves: [])
        
        let standard = MKMapType.standard
        
        vm.setMapType(index: 0)
        
        XCTAssertEqual(standard, vm.mapType)
    }
    
    

}
