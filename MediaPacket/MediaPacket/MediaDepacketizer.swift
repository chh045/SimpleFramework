//
//  MediaDepacketizer.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/25/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
protocol MediaPacketizer: class {
    
    /// Receives a media packet
    ///
    /// - Parameter packet: The packet to be received
    func receive(packet: MediaPacket)
    
    /// Retrieves media stream and load it to the destination container
    ///
    /// - Parameter destination: The container to hold the media stream
    func loadMediaStreams(to destination: inout MediaStreamList)
    
    /// Determines if the media stream is available.
    ///
    /// - Returns: True if media stream is available, false otherwise.
    func isMediaStreamAvailable() -> Bool
    
    /// Returns the type of depacketizer
    var depacketizerType: PacketType { get set }
    
    /// Determines if return message available.
    ///
    /// - Returns: true is return message is available, else otherwise.
    func isReturnMessageAvailable() -> Bool
    
    /// Gets the return message
    var returnMessage: Message? { get }
    
}
