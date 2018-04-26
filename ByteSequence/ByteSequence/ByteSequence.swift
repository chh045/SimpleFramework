//
//  ByteSequence.swift
//  ByteSequence
//
//  Created by REDSTATION on 4/23/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

public struct ByteSequence {

    private var buffer: [UInt8]

    func testBuffer() -> [UInt8] {
        return buffer
    }
    
    /// ByteSequence default initializer, instantiate an empty buffer
    public init() {
        buffer = [UInt8]()
    }

    /// ByteSequence initializer, create a instance of the given sequence copy
    ///
    /// - Parameter sequence: The sequence to be copied
    public init(sequence: ByteSequence) {
        self = sequence
    }

    /// ByteSequence initializer, copy the given buffer to a new instance
    ///
    /// - Parameter buffer: Buffer to be parsed
    public init(buffer: [UInt8]) {
        self.buffer = buffer
    }

    /// ByteSquence initializer, create byte buffer with size
    ///
    /// - Parameter count: size of byte sequence
    public init(count: Int) {
        buffer = [UInt8](repeating: 0, count: count)
    }
}

extension ByteSequence: RangeReplaceableCollection {
    public typealias Index = Int
    public typealias Element = UInt8

    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression, Element == C.Element, Index == R.Bound {
        buffer.replaceSubrange(subrange, with: newElements)
    }

    public subscript(position: Index) -> Element { return buffer[position] }

    public var startIndex: Index {
        return buffer.startIndex
    }

    public var endIndex: Index {
        return buffer.endIndex
    }

    public func index(after i: Index) -> Index {
        return buffer.index(after: i)
    }
}

extension ByteSequence: CustomStringConvertible {
    public var description: String {
        return String(describing: buffer)
    }
}

extension ByteSequence {
    /// Returns a set of ByteSequence that each size matches
    /// the offset. If the original size is not divisible,
    /// surplus size will remain.
    ///
    /// An example of using `partition(by:)`:
    /// ````
    /// let seq = ByteSequence(count: 7)
    /// let seqSet = seq.partition(by: 3)
    /// print(seqSet)
    /// // Prints "[0,0,0], [0,0,0], [0]"
    /// ````
    /// - Parameter by: The offset for division.
    /// - Returns: Array of ByteSequence
    public func partition(by size: Int) -> [ByteSequence] {
        var begin = 0
        var end = size
        var set = [ByteSequence]()
        while end < count {
            set.append(ByteSequence(self[begin ..< end]))
            begin = end
            end += size
        }
        set.append(ByteSequence(self[begin ..< count]))
        return set
    }
}
