//
//  Time.swift
//  Time
//
//  Created by REDSTATION on 4/20/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
public struct Time {
    private var counts: UInt64
    init(counts: UInt64) {
        self.counts = counts
    }
    init() {
        self.counts = UInt64(Date().timeIntervalSince1970 * 1000000)
    }
    
    
}


extension Time: Comparable {
    public static func <(lhs: Time, rhs: Time) -> Bool {
        return lhs.counts < rhs.counts
    }
    
    public static func ==(lhs: Time, rhs: Time) -> Bool {
        return lhs.counts == rhs.counts
    }
}


extension Time: Equatable {
    
}

extension Time: CustomStringConvertible {
    public var description: String {
        return "\(counts)"
    }
}

extension Time {
//    static func -= (lhs: inout Time, rhs: Int) {
//        lhs.counts -= rhs
//    }
}
