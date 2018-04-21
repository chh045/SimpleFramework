//
//  RandomTests.swift
//  RandomTests
//
//  Created by REDSTATION on 4/19/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import XCTest

class RandomTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRandInt() {
        var posCount = 0
        var negCount = 0
        for _ in 0 ..< 1000 {
            let a: Int = RandomG.rand()
            if a >= 0 {
                posCount += 1
            } else {
                negCount += 1
            }
        }
        XCTAssertEqual(posCount + negCount, 1000, "rand() down cast Failure")
        let ratio = negCount == 0 ? 0 : Double(posCount / negCount)
        let e = abs(1-ratio)
        XCTAssertTrue(e < 0.2, "Error range:\(e*100)% rand() fails 20% error tolerance")
        XCTAssertTrue(e < 0.1, "Error range:\(e*100)% rand() fails 10% error tolerance")
        XCTAssertTrue(e < 0.08, "Error range:\(e*100)% rand() fails 8% error tolerance")
        XCTAssertTrue(e < 0.06, "Error range:\(e*100)% rand() fails 6% error tolerance")
        XCTAssertTrue(e < 0.04, "Error range:\(e*100)% rand() fails 4% error tolerance")
        XCTAssertTrue(e < 0.02, "Error range:\(e*100)% rand() fails 2% error tolerance")
        XCTAssertTrue(e < 0.008, "Error range:\(e*100)% rand() fails 0.8% error tolerance")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
