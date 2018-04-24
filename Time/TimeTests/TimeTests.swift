//
//  TimeTests.swift
//  TimeTests
//
//  Created by REDSTATION on 4/23/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import XCTest
@testable import Time

class TimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeDistance() {
        let now = Time()
        for t in stride(from: 1.0, to: 15.0, by: 1.0) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + t) {
                let later = Time()
                let mircoSecDiff = now.distance(to: later)
                XCTAssertEqual(mircoSecDiff/1000000, Int64(t) , "later time should be \(t) second after now.")
                XCTAssertEqual(mircoSecDiff/1000, Int64(t*1000) , "later time should be \(t*1000) second after now.")
                XCTAssertEqual(mircoSecDiff, Int64(t*1000000) , "later time should be \(t*1000000) second after now.")
            }
        }
        
    }
    
}
