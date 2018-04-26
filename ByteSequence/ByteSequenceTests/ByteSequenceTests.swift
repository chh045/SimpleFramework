//
//  ByteSequenceTests.swift
//  ByteSequenceTests
//
//  Created by REDSTATION on 4/23/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

@testable import ByteSequence
import XCTest

class ByteSequenceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testByteSequenceInit() {
        let seq1 = ByteSequence()
        XCTAssertNotNil(seq1)

        let buffer: [UInt8] = [1, 2, 3, 4, 5]
        let seq2 = ByteSequence(buffer: buffer)
        XCTAssertNotNil(seq2)
        XCTAssertEqual(seq2.testBuffer(), buffer, "seq2.buffer: \(seq2.testBuffer()), is not equal to buffer: \(buffer)")

        let seq3 = ByteSequence(sequence: seq1)
        XCTAssertNotNil(seq3)
    }

    func testByteSequenceAppendAndCount() {
        var seq = ByteSequence()
        XCTAssert(seq.count == 0, "new sequence created with count 0")

        for i in 0 ..< 5 {
            seq.append(UInt8(i))
            XCTAssert(seq[i] == i, "first element appended is \(i)")
            XCTAssert(seq.count == i + 1, "sequence now has size \(i + 1)")
        }
    }

    func testByteSequenceRemove() {
        let buf: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        var seq = ByteSequence(buffer: buf)

        for i in 0 ..< seq.count {
            let r = seq.removeFirst()
            XCTAssert(r == i + 1, "removal of element return wrong result")
        }

        seq += [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        XCTAssert(seq.count == 10, "sequence append with sequeunce failed.")

        for i in 0 ..< seq.count {
            XCTAssert(seq[i] == i + 1, "sequence slice unmatch")
        }

        seq.removeAll()
        XCTAssert(seq.count == 0, "reset sequence")
    }
    
    func testByteSequenceSubrange() {
        let seq = ByteSequence(buffer: [1,2,3,4,5,6,7,8,9,10])
        let tests: [(Range<Int>, [UInt8])] =
            [((0 ..< 10), [1,2,3,4,5,6,7,8,9,10]),
             ((0 ..< 3), [1,2,3]),
             ((4 ..< 8), [5,6,7,8]),
             ((7 ..< 10), [8, 9, 10]),
             ((0 ..< 5), [1,2,3,4,5]),
             ((1 ..< 1), [])]
        for (test, result) in tests {
            let testResult = ByteSequence(seq[test]).testBuffer()
            XCTAssertEqual(testResult, result, "Testing \(test), test result: \(testResult) not equal to expectation: \(result)")
        }
        
    }
    
    func testByteSequencePartition() {
        let seq = ByteSequence(count: 2800)
        let tests    = [2801, 2800, 2801, 1400, 1388, 1399, 1]
        let expectCount = [1, 1, 1, 2, 3, 3, 2800]
        let expectEachSetCount = [
            [2800], [2800], [2800], [1400, 1400], [1388, 1388, 24],
            [1399, 1399, 2],  Array(repeating: 1, count: 2800)]
        for i in 0..<tests.count {
            let set = seq.partition(by: tests[i])
            XCTAssertEqual(set.count, expectCount[i], "Test case [\(i)]. set.count: \(set.count) not equal to \(expectCount[i])")
            for j in 0..<set.count {
                XCTAssertEqual(set[j].count, expectEachSetCount[i][j], "Test case [\(i)] subset.count: \(set[j].count) not equal to \(expectEachSetCount[i][j])")
            }
        }
    }
}
