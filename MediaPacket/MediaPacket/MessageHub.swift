//
//  MessageHub.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/25/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
public struct MessageHub: MessageListener {
    
    /// Reset network with new connection
    ///
    /// - Parameter new: The new connection
    func reconnect(with new: Connection) {
        
    }
    
    /// Remove all listener
    func reset() {
        
    }
    
    /// Start operation
    func start() {
        
    }
    
    /// Stop operation
    func stop() {
        
    }
    
    /// Attach a connection to the hub
    ///
    /// - Parameter connection: The connection
    func attach(connection: Connection) {
        
    }
    
    /// Register messageListener
    ///
    /// - Parameters:
    ///   - listener: The listen to be registered
    ///   - type: The type of message to be listened
    func register(messageListener listener: MessageListener, type: PacketType) {
        
    }
    
    /// Sends a message
    ///
    /// - Parameter message: The message to be sent
    func send(message: Message) {
        
    }
    
    /// Determines if connection is active
    ///
    /// - Returns: True if connection is active, false otherwise.
    func isConnectionActive() -> Bool {
        return true
    }
    
    /// Handles a message
    ///
    /// - Parameter message: The message
    func handle(message: Message) {
        
    }
}
