//
//  Message.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/24/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

public struct Message {
    var type: PacketType
    var data: ByteSequence
    var info: ConnectionInfo? = nil
    
    init(type: PacketType, data: ByteSequence) {
        self.type = type
        self.data = data
    }
    
    init(message: Message) {
        self = message
    }
    
    static func makeMessage(type: PacketType, data: ByteSequence) -> Message {
        let message = Message(type: type, data: data)
        return message
    }
    
    static func makeMessage(type: PacketType, buffer: [UInt8]) -> Message {
        let message = Message(type: type, data: ByteSequence(buffer: buffer))
        return message
    }
    
}
