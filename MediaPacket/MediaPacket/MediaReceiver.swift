//
//  MediaReceiver.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/25/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

protocol MediaReceiver: class {
    
    /// Attach a message hub to the sender
    ///
    /// - Parameter hub: The hub
    func attach(messageHub: MessageHub)
    
    /// Detach message hub
    func detach()
    
    /// Receive one unit. Decodes a media into the decoder's output
    /// buffer if media is avaliable
    func receiveOneUnit()
    
    /// Determines if media avaliable
    func isMediaAvaliable()
}
