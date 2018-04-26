//
//  Connection.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/24/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
protocol Connection: class {
    /// Connect to remote interface
    ///
    /// - Parameter async: The asynchronous
    /// - Returns: True if successful, false otherwise
    func connect(async: Bool) -> Bool
    

    /// Disconnect the connection
    ///
    /// - Returns: nil
    func disconnect() -> Void
    
    /// Accept connection
    ///
    /// - Parameters:
    ///   - async: The asynchronous
    ///   - timeout: The timeout
    /// - Returns: True if successful, false otherwise.
    func accept(async: Bool, timeout: Int) -> Bool
    
    /// Send data to the other end. The input message will be destroy after
    /// calling send. This is to reduce processing time.
    ///
    /// - Parameter message: The message
    /// - Returns: True if send successful, false otherwise.
    func send(message: Message) -> Bool
    
    /// Recieve data
    ///
    /// - Parameter message: The message
    /// - Returns: True if receive successful, false otherwise.
    func receive(message: Message) -> Bool
    
    /// Sets the remote network interface.
    ///
    /// - Parameters:
    ///   - address: The address
    ///   - port: The port
    /// - Returns: nil
    func setRemoteNetworkInterface(address: String, port: Int) -> Void
    
    /// Sets the local network interface
    ///
    /// - Parameters:
    ///   - address: The address
    ///   - port: The port
    /// - Returns: nil
    func setLocalNetworkInterface(address: String, port: Int) -> Void
    
    /// Determine if the connection is alive
    ///
    /// - Returns: True if connection alive, flase otherwise.
    func isActive() -> Bool
}
