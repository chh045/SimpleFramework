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
}
