//
//  MessageListener.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/25/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
protocol MessageListener {
    func handle(message: Message)
}
