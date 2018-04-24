//
//  Time.swift
//  Time
//
//  Created by REDSTATION on 4/20/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
public struct Time {
    
    private var counts: Int64
    
    public init(counts: Int64) {
        self.counts = counts
    }
    public init() {
        self.counts = Int64(Date().timeIntervalSince1970 * 1000000)
    }
    
    var seconds: Int64 {
        return counts / 1000000
    }
    
    var milliSeconds: Int64 {
        return counts / 1000
    }
    
    var mircoSeconds: Int64 {
        return counts
    }
    
    var mircoSecondsSince1970: Int64 {
        return counts
    }
    
    func getNtpIn64Bits() -> UInt64 {
        var fractional = UInt64(mircoSeconds - seconds * 1000000)
        fractional = fractional * (UInt64(1 << 32)) / 1000000
        return UInt64(seconds << 32) | fractional
    }
    
    func getNtpIn32Bits() -> UInt32 {
        return UInt32(truncatingIfNeeded: getNtpIn64Bits() >> 16)
    }
    
    static func -=(lhs: inout Time, rhs: Time) {
        lhs.counts -= rhs.counts
    }
    
    static func +=(lhs: inout Time, rhs: Time) {
        lhs.counts += rhs.counts
    }
    
    static func +(lhs: Time, rhs: Time) -> Time {
        return Time(counts: lhs.counts + rhs.counts)
    }
    
    static func -(lhs: Time, rhs: Time) -> Time {
        return Time(counts: lhs.counts - rhs.counts)
    }
}

extension Time: Comparable {
    public static func <(lhs: Time, rhs: Time) -> Bool {
        return lhs.counts < rhs.counts
    }
}

extension Time: Equatable {
    public static func ==(lhs: Time, rhs: Time) -> Bool {
        return lhs.counts == rhs.counts
    }
}

extension Time: Strideable {
    public func distance(to other: Time) -> Time.Stride {
        return abs(counts - other.counts)
    }
    
    public func advanced(by n: Time.Stride) -> Time {
        var result = self
        result.counts += n
        return result
    }
    
    public typealias Stride = Int64
}

extension Time: CustomStringConvertible {
    public var description: String {
        return "\(counts)"
    }
}

