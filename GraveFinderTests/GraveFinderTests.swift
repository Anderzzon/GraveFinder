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
    
    func test_for_correct_fetch_request() {
        let vm = BottomSheetViewModel()
        let testString = "Hans Gustavsson"
        
        vm.query = testString

        var resultsRecived = false
          
        let fetch = vm.fetchGraves()
        
        let expectation = XCTestExpectation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

            if vm.totalGravesSearchResults.count > 0 {
                resultsRecived = true
            }
            print("Number of graves sync: ", vm.totalGravesSearchResults.count)

            print("Number of graves:", resultsRecived)
            XCTAssertTrue(resultsRecived)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_for_inCorrect_fetch_request() {
        let vm = BottomSheetViewModel()
        let testString = "sDFWEHJSDFZGQADGVC"
        
        vm.query = testString

        var noResults = true
          
        let fetch = vm.fetchGraves()
        
        let expectation = XCTestExpectation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

            if vm.totalGravesSearchResults.count > 0 {
                noResults = false
            }
            print("Number of graves sync: ", vm.totalGravesSearchResults.count)

            print("Number of graves:", noResults)
            XCTAssertTrue(noResults)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testEncryption(){
        let vm = ComplianceViewModel()
        let encryptedValue = vm.encrypt(string: "test", password: "password")
        XCTAssertNotNil(encryptedValue)
    }
    func testDecryption() {
        let vm = ComplianceViewModel()
        guard let encryptedValue = vm.encrypt(string: "test", password: "password") else {
            XCTAssertTrue(false)
            return
        }
        
        guard let decryptedValue = vm.decrypt(data: encryptedValue, password: "password") else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("test", decryptedValue)
        
    }
    

}
