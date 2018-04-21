//
//  Random.swift
//  Random
//
//  Created by REDSTATION on 4/18/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
fileprivate let seedStr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
@inline(__always)
internal func unsafeBitCast<T, U>(_ value: T) -> U {
    return unsafeBitCast(value, to: U.self)
}
internal func random64() -> UInt64 {
    return unsafeBitCast((arc4random(), arc4random()))
}
public struct RandomG {
    public static func rand<T>() -> T where T: BinaryInteger {
        return T(truncatingIfNeeded: random64())
    }
    public static func rand<T>() -> T where T: BinaryFloatingPoint {
        return T(drand48())
    }
    public static func rand() -> Bool {
        return arc4random_uniform(2) == 0
    }
    public static func rand(_ charCount: Int) -> String {
        var s = ""
        for _ in 0 ..< charCount {
            let i = seedStr.index(seedStr.startIndex, offsetBy: Int(arc4random_uniform(UInt32(seedStr.count))))
            s.append(seedStr[i])
        }
        return s
    }
}

