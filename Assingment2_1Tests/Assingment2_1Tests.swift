//
//  Assingment2_1Tests.swift
//  Assingment2_1Tests
//
//  Created by Christopher Burrows on 9/4/19.
//  Copyright © 2019 Christopher Burrows. All rights reserved.
//

import XCTest
@testable import Assingment2_1

class Assingment2_1Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlace() {
        let name = "Sydney CBD"
        let address = "Sydney"
        let latitude = -23.04
        let longitude = 153.02
        let place = Place(name: name, address: address, latitude: latitude, longitude: longitude)
        XCTAssertEqual(place.name, name)
        XCTAssertEqual(place.address, address)
        XCTAssertEqual(place.latitude, latitude)
        XCTAssertEqual(place.longitude, longitude)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
