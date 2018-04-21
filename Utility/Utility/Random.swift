//
//  Random.swift
//  Utility
//
//  Created by REDSTATION on 4/18/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
fileprivate let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
public protocol BinaryRandomBoolProtocol {}
public protocol BinaryRandomStringProtocol{}
extension String: BinaryRandomStringProtocol{}
extension Bool: BinaryRandomBoolProtocol {}

@inline(__always)
internal func _unsafeBitCast<T, U>(_ value: T) -> U {
    return unsafeBitCast(value, to: U.self)
}
internal func _arc4random() -> UInt32 {
    #if !os(Linux) && !os(Android) && !os(Windows)
        return arc4random()
    #else
        return _a4r?() ?? 0
    #endif
}
internal func random32() -> UInt32 {
    return _arc4random()
}
internal func random64() -> UInt64 {
    return _unsafeBitCast((random32(), random32()))
}

public struct RandomG {
    
    public static func rand<T>() -> T where T: BinaryInteger {
        return T(truncatingIfNeeded: random64())
    }
    public static func rand<T>() -> T where T: BinaryFloatingPoint {
        return T(drand48())
    }
    public static func rand<T>() -> T where T: BinaryRandomBoolProtocol{
        return (arc4random_uniform(2) == 0) as! T
    }
    public static func rand<T>(_ charCount: Int) -> T where T: BinaryRandomStringProtocol{
        var s = ""
        for _ in 0 ..< charCount
        {
            let i = a.index(a.startIndex, offsetBy: Int(arc4random_uniform(UInt32(a.count))))
            s.append(a[i])
        }
        return s as! T
    }
}

