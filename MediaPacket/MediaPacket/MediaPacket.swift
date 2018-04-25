//
//  MediaPacket.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/24/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

public struct MediaPacket {
    
    var type: PacketType
    var data: ByteSequence
    
    init(packet: MediaPacket) {
        self = packet
    }
    
    init(message: Message) {
        self.type = message.type
        self.data = message.data
    }
    
    init(type: PacketType) {
        self.type = type
        self.data = ByteSequence()
    }
    
    init(type: PacketType, data: ByteSequence) {
        self.type = type
        self.data = data
    }

    /// Convert to network message
    ///
    /// - Returns: The message
    var message: Message {
        return Message(type: type, data: data)
    }
}


public struct MediaPacketList {
    public typealias PacketList = [MediaPacket]
    
    private var list: PacketList
    
    public init() {
        list = PacketList()
    }
}

extension MediaPacketList: RangeReplaceableCollection {
    public typealias Index = PacketList.Index
    public typealias Element = PacketList.Element
    
    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression, PacketList.Element == C.Element, PacketList.Index == R.Bound {
        list.replaceSubrange(subrange, with: newElements)
    }
    
    public subscript(position: Index) -> Element { return list[position] }
    
    public var startIndex: Index {
        return list.startIndex
    }
    
    public var endIndex: Index {
        return list.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return list.index(after: i)
    }
}


