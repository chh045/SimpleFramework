//
//  MediaPacket.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/24/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

public enum PacketType: String {
    case video = "video"
    case audio = "audio"
}

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
    
    init(type: PacketType, data: ByteSequence = ByteSequence()) {
        self.type = type
        self.data = data
    }
    
    var message: Message {
        return Message(type: type, data: data)
    }
}


public struct MediaPacketList {
    
    private var list: [MediaPacket]
    
    public init() {
        list = [MediaPacket]()
    }
}

extension MediaPacketList: RangeReplaceableCollection {
    public typealias Index = Int
    public typealias Element = MediaPacket
    
    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression, Element == C.Element, Index == R.Bound {
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


