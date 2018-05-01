//
//  UnreliableConnection.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/30/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

class MessageAssembler{}
class Mutex{}
class ThreadSafeQueue<T>{}
class TransportFormat{}
class MessageQueue{}

class UnreliableConnection: Connection {
    
    private var async: String
    private var assembler: MessageAssembler
    private var mut: Mutex
    private var sendQueue: ThreadSafeQueue<TransportFormat>
    private var recvQueue: MessageQueue
    private var sendBuffer: ByteSequence
    private var recvBuffer: ByteSequence
    private var ongoingSend: Atomic<Bool>
    private var ongoingRecv: Atomic<Bool>
    private var started: Atomic<Bool>
    private var probing: Atomic<Bool>
    
    func connect(async: Bool) -> Bool {
        <#code#>
    }
    
    func disconnect() {
        <#code#>
    }
    
    func accept(async: Bool, timeout: Int) -> Bool {
        <#code#>
    }
    
    func send(message: Message) -> Bool {
        <#code#>
    }
    
    func receive(message: Message) -> Bool {
        <#code#>
    }
    
    func setRemoteNetworkInterface(address: String, port: Int) {
        <#code#>
    }
    
    func setLocalNetworkInterface(address: String, port: Int) {
        <#code#>
    }
    
    func isActive() -> Bool {
        <#code#>
    }
}
