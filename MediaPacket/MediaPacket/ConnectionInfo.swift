//
//  ConnectionInfo.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/24/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
protocol ConnectionInfo {
    var senderIP: String {set get}
    var senderPort: UInt16 {set get}
}
