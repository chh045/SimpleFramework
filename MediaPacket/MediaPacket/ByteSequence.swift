//
//  ByteSequence.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/24/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

public struct ByteSequence {
    
    private var buffer: [UInt8]
    
    /// ByteSequence default initializer, instantiate an empty buffer
    public init() {
        buffer = [UInt8]()
    }
    
    /// ByteSequence initializer, create a instance of the given sequence copy
    ///
    /// - Parameter sequence: The sequence to be copied
    public init(sequence: ByteSequence) {
        buffer = sequence.buffer
    }
    
    /// ByteSequence initializer, copy the given buffer to a new instance
    ///
    /// - Parameter buffer: Buffer to be parsed
    public init(buffer: [UInt8]) {
        self.buffer = buffer
    }
}

extension ByteSequence: RangeReplaceableCollection {
    public typealias Index = Array<UInt8>.Index
    public typealias Element = Array<UInt8>.Element
    
    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression, ByteSequence.Element == C.Element, ByteSequence.Index == R.Bound {
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

