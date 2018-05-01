//
//  Atomic.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/26/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation

public class Atomic<T>: CustomStringConvertible {
    internal var mutex = NSLock()
    internal var value: T
    /// Returns an atomic object.
    public init(_ value: T) {
        self.value = value
    }
    
    /// Loads the value atomically.
    public func load() -> T {
        mutex.lock()
        defer { mutex.unlock() }
        return value
    }
    
    /// Stores a value atomically.
    public func store(_ value: T) {
        mutex.lock()
        defer { mutex.unlock() }
        self.value = value
    }
    
    /// Exchanges / Swaps values atomically.
    public func exchange(_ atomic: Atomic<T>) {
        atomic.mutex.lock()
        defer { atomic.mutex.unlock() }
        mutex.lock()
        defer { mutex.unlock() }
        let temp = value
        value = atomic.value
        atomic.value = temp
    }
    
    public var description: String {
        mutex.lock()
        defer { mutex.unlock() }
        return "\(value)"
    }
}

@inline(__always) private func lock<T>(_ lhs: Atomic<T>, _ rhs: Atomic<T>) {
    lhs.mutex.lock()
    if lhs !== rhs { rhs.mutex.lock() }
}

@inline(__always) private func lock<T>(_ lhs: Atomic<T>) {
    lhs.mutex.lock()
}

@inline(__always) private func unlock<T>(_ lhs: Atomic<T>, _ rhs: Atomic<T>) {
    lhs.mutex.unlock()
    if lhs !== rhs { rhs.mutex.unlock() }
}

@inline(__always) private func unlock<T>(_ lhs: Atomic<T>) {
    lhs.mutex.unlock()
}

public func == <T: Equatable>(lhs: Atomic<T>, rhs: Atomic<T>) -> Bool {
    lock(lhs, rhs)
    let result = lhs.value == rhs.value
    unlock(lhs, rhs)
    return result
}

public func == <T: Equatable>(lhs: T, rhs: Atomic<T>) -> Bool {
    lock(rhs)
    let result = lhs == rhs.value
    unlock(rhs)
    return result
}

public func == <T: Equatable>(lhs: Atomic<T>, rhs: T) -> Bool {
    lock(lhs)
    let result = lhs.value == rhs
    unlock(lhs)
    return result
}

public func != <T: Equatable>(lhs: Atomic<T>, rhs: Atomic<T>) -> Bool {
    lock(lhs, rhs)
    let result = lhs.value != rhs.value
    unlock(lhs, rhs)
    return result
}

public func != <T: Equatable>(lhs: T, rhs: Atomic<T>) -> Bool {
    lock(rhs)
    let result = lhs != rhs.value
    unlock(rhs)
    return result
}

public func != <T: Equatable>(lhs: Atomic<T>, rhs: T) -> Bool {
    lock(lhs)
    let result = lhs.value != rhs
    unlock(lhs)
    return result
}

public func && (lhs: Atomic<Bool>, rhs: Atomic<Bool>) -> Bool {
    lock(lhs, rhs)
    let result = lhs.value && rhs.value
    unlock(lhs, rhs)
    return result
}

public func && (lhs: Bool, rhs: Atomic<Bool>) -> Bool {
    lock(rhs)
    let result = lhs && rhs.value
    unlock(rhs)
    return result
}

public func && (lhs: Atomic<Bool>, rhs: Bool) -> Bool {
    lock(lhs)
    let result = lhs.value && rhs
    unlock(lhs)
    return result
}

public func || (lhs: Atomic<Bool>, rhs: Atomic<Bool>) -> Bool {
    lock(lhs, rhs)
    let result = lhs.value || rhs.value
    unlock(lhs, rhs)
    return result
}

public func || (lhs: Bool, rhs: Atomic<Bool>) -> Bool {
    lock(rhs)
    let result = lhs || rhs.value
    unlock(rhs); return result
}

public func || (lhs: Atomic<Bool>, rhs: Bool) -> Bool {
    lock(lhs)
    let result = lhs.value || rhs; unlock(lhs)
    return result
}

public func <= <T: Comparable>(lhs: Atomic<T>, rhs: Atomic<T>) -> Bool {
    lock(lhs, rhs)
    let result = lhs.value <= rhs.value
    unlock(lhs, rhs)
    return result
}

public func <= <T: Comparable>(lhs: T, rhs: Atomic<T>) -> Bool {
    lock(rhs)
    let result = lhs <= rhs.value
    unlock(rhs)
    return result
}

public func <= <T: Comparable>(lhs: Atomic<T>, rhs: T) -> Bool { lock(lhs); let result = lhs.value <= rhs; unlock(lhs); return result }
public func >= <T: Comparable>(lhs: Atomic<T>, rhs: Atomic<T>) -> Bool { lock(lhs, rhs); let result = lhs.value >= rhs.value; unlock(lhs, rhs); return result }
public func >= <T: Comparable>(lhs: T, rhs: Atomic<T>) -> Bool { lock(rhs); let result = lhs >= rhs.value; unlock(rhs); return result }
public func >= <T: Comparable>(lhs: Atomic<T>, rhs: T) -> Bool { lock(lhs); let result = lhs.value >= rhs; unlock(lhs); return result }
public func > <T: Comparable>(lhs: Atomic<T>, rhs: Atomic<T>) -> Bool { lock(lhs, rhs); let result = lhs.value > rhs.value; unlock(lhs, rhs); return result }
public func > <T: Comparable>(lhs: T, rhs: Atomic<T>) -> Bool { lock(rhs); let result = lhs > rhs.value; unlock(rhs); return result }
public func > <T: Comparable>(lhs: Atomic<T>, rhs: T) -> Bool { lock(lhs); let result = lhs.value > rhs; unlock(lhs); return result }
public func < <T: Comparable>(lhs: Atomic<T>, rhs: Atomic<T>) -> Bool { lock(lhs, rhs); let result = lhs.value < rhs.value; unlock(lhs, rhs); return result }
public func < <T: Comparable>(lhs: T, rhs: Atomic<T>) -> Bool { lock(rhs); let result = lhs < rhs.value; unlock(rhs); return result }
public func < <T: Comparable>(lhs: Atomic<T>, rhs: T) -> Bool { lock(lhs); let result = lhs.value < rhs; unlock(lhs); return result }
public prefix func ! (val: Atomic<Bool>) -> Atomic<Bool> { lock(val); let result = !val.value; unlock(val); return Atomic(result) }

public typealias IntA = Atomic<Int>
public typealias Int64A = Atomic<Int64>
public typealias Int32A = Atomic<Int32>
public typealias Int16A = Atomic<Int16>
public typealias Int8A = Atomic<Int8>
public typealias UIntA = Atomic<UInt>
public typealias UInt64A = Atomic<UInt64>
public typealias UInt32A = Atomic<UInt32>
public typealias UInt16A = Atomic<UInt16>
public typealias UInt8A = Atomic<UInt8>
public typealias DoubleA = Atomic<Double>
public typealias FloatA = Atomic<Float>
public typealias BoolA = Atomic<Bool>
public typealias StringA = Atomic<String>

public extension Int {
    public init(_ atomic: IntA) { self = Int(atomic.load()) }
    public init(_ atomic: Int64A) { self = Int(atomic.load()) }
    public init(_ atomic: Int32A) { self = Int(atomic.load()) }
    public init(_ atomic: Int16A) { self = Int(atomic.load()) }
    public init(_ atomic: Int8A) { self = Int(atomic.load()) }
    public init(_ atomic: UIntA) { self = Int(atomic.load()) }
    public init(_ atomic: UInt64A) { self = Int(atomic.load()) }
    public init(_ atomic: UInt32A) { self = Int(atomic.load()) }
    public init(_ atomic: UInt16A) { self = Int(atomic.load()) }
    public init(_ atomic: UInt8A) { self = Int(atomic.load()) }
    public init(_ atomic: DoubleA) { self = Int(atomic.load()) }
    public init(_ atomic: FloatA) { self = Int(atomic.load()) }
}

public extension Int64 {
    public init(_ atomic: Int64A) { self = Int64(atomic.load()) }
    public init(_ atomic: IntA) { self = Int64(atomic.load()) }
    public init(_ atomic: Int32A) { self = Int64(atomic.load()) }
    public init(_ atomic: Int16A) { self = Int64(atomic.load()) }
    public init(_ atomic: Int8A) { self = Int64(atomic.load()) }
    public init(_ atomic: UIntA) { self = Int64(atomic.load()) }
    public init(_ atomic: UInt64A) { self = Int64(atomic.load()) }
    public init(_ atomic: UInt32A) { self = Int64(atomic.load()) }
    public init(_ atomic: UInt16A) { self = Int64(atomic.load()) }
    public init(_ atomic: UInt8A) { self = Int64(atomic.load()) }
    public init(_ atomic: DoubleA) { self = Int64(atomic.load()) }
    public init(_ atomic: FloatA) { self = Int64(atomic.load()) }
}

public extension Int32 {
    public init(_ atomic: Int32A) { self = Int32(atomic.load()) }
    public init(_ atomic: IntA) { self = Int32(atomic.load()) }
    public init(_ atomic: Int64A) { self = Int32(atomic.load()) }
    public init(_ atomic: Int16A) { self = Int32(atomic.load()) }
    public init(_ atomic: Int8A) { self = Int32(atomic.load()) }
    public init(_ atomic: UIntA) { self = Int32(atomic.load()) }
    public init(_ atomic: UInt64A) { self = Int32(atomic.load()) }
    public init(_ atomic: UInt32A) { self = Int32(atomic.load()) }
    public init(_ atomic: UInt16A) { self = Int32(atomic.load()) }
    public init(_ atomic: UInt8A) { self = Int32(atomic.load()) }
    public init(_ atomic: DoubleA) { self = Int32(atomic.load()) }
    public init(_ atomic: FloatA) { self = Int32(atomic.load()) }
}

public extension Int16 {
    public init(_ atomic: Int16A) { self = Int16(atomic.load()) }
    public init(_ atomic: IntA) { self = Int16(atomic.load()) }
    public init(_ atomic: Int64A) { self = Int16(atomic.load()) }
    public init(_ atomic: Int32A) { self = Int16(atomic.load()) }
    public init(_ atomic: Int8A) { self = Int16(atomic.load()) }
    public init(_ atomic: UIntA) { self = Int16(atomic.load()) }
    public init(_ atomic: UInt64A) { self = Int16(atomic.load()) }
    public init(_ atomic: UInt32A) { self = Int16(atomic.load()) }
    public init(_ atomic: UInt16A) { self = Int16(atomic.load()) }
    public init(_ atomic: UInt8A) { self = Int16(atomic.load()) }
    public init(_ atomic: DoubleA) { self = Int16(atomic.load()) }
    public init(_ atomic: FloatA) { self = Int16(atomic.load()) }
}

public extension Int8 {
    public init(_ atomic: Int8A) { self = Int8(atomic.load()) }
    public init(_ atomic: IntA) { self = Int8(atomic.load()) }
    public init(_ atomic: Int64A) { self = Int8(atomic.load()) }
    public init(_ atomic: Int32A) { self = Int8(atomic.load()) }
    public init(_ atomic: Int16A) { self = Int8(atomic.load()) }
    public init(_ atomic: UIntA) { self = Int8(atomic.load()) }
    public init(_ atomic: UInt64A) { self = Int8(atomic.load()) }
    public init(_ atomic: UInt32A) { self = Int8(atomic.load()) }
    public init(_ atomic: UInt16A) { self = Int8(atomic.load()) }
    public init(_ atomic: UInt8A) { self = Int8(atomic.load()) }
    public init(_ atomic: DoubleA) { self = Int8(atomic.load()) }
    public init(_ atomic: FloatA) { self = Int8(atomic.load()) }
}

public extension UInt {
    public init(_ atomic: UIntA) { self = UInt(atomic.load()) }
    public init(_ atomic: IntA) { self = UInt(atomic.load()) }
    public init(_ atomic: Int64A) { self = UInt(atomic.load()) }
    public init(_ atomic: Int32A) { self = UInt(atomic.load()) }
    public init(_ atomic: Int16A) { self = UInt(atomic.load()) }
    public init(_ atomic: Int8A) { self = UInt(atomic.load()) }
    public init(_ atomic: UInt64A) { self = UInt(atomic.load()) }
    public init(_ atomic: UInt32A) { self = UInt(atomic.load()) }
    public init(_ atomic: UInt16A) { self = UInt(atomic.load()) }
    public init(_ atomic: UInt8A) { self = UInt(atomic.load()) }
    public init(_ atomic: DoubleA) { self = UInt(atomic.load()) }
    public init(_ atomic: FloatA) { self = UInt(atomic.load()) }
}

public extension UInt64 {
    public init(_ atomic: UInt64A) { self = UInt64(atomic.load()) }
    public init(_ atomic: IntA) { self = UInt64(atomic.load()) }
    public init(_ atomic: Int64A) { self = UInt64(atomic.load()) }
    public init(_ atomic: Int32A) { self = UInt64(atomic.load()) }
    public init(_ atomic: Int16A) { self = UInt64(atomic.load()) }
    public init(_ atomic: Int8A) { self = UInt64(atomic.load()) }
    public init(_ atomic: UIntA) { self = UInt64(atomic.load()) }
    public init(_ atomic: UInt32A) { self = UInt64(atomic.load()) }
    public init(_ atomic: UInt16A) { self = UInt64(atomic.load()) }
    public init(_ atomic: UInt8A) { self = UInt64(atomic.load()) }
    public init(_ atomic: DoubleA) { self = UInt64(atomic.load()) }
    public init(_ atomic: FloatA) { self = UInt64(atomic.load()) }
}

public extension UInt32 {
    public init(_ atomic: UInt32A) { self = UInt32(atomic.load()) }
    public init(_ atomic: IntA) { self = UInt32(atomic.load()) }
    public init(_ atomic: Int64A) { self = UInt32(atomic.load()) }
    public init(_ atomic: Int32A) { self = UInt32(atomic.load()) }
    public init(_ atomic: Int16A) { self = UInt32(atomic.load()) }
    public init(_ atomic: Int8A) { self = UInt32(atomic.load()) }
    public init(_ atomic: UIntA) { self = UInt32(atomic.load()) }
    public init(_ atomic: UInt64A) { self = UInt32(atomic.load()) }
    public init(_ atomic: UInt16A) { self = UInt32(atomic.load()) }
    public init(_ atomic: UInt8A) { self = UInt32(atomic.load()) }
    public init(_ atomic: DoubleA) { self = UInt32(atomic.load()) }
    public init(_ atomic: FloatA) { self = UInt32(atomic.load()) }
}

public extension UInt16 {
    public init(_ atomic: UInt16A) { self = UInt16(atomic.load()) }
    public init(_ atomic: IntA) { self = UInt16(atomic.load()) }
    public init(_ atomic: Int64A) { self = UInt16(atomic.load()) }
    public init(_ atomic: Int32A) { self = UInt16(atomic.load()) }
    public init(_ atomic: Int16A) { self = UInt16(atomic.load()) }
    public init(_ atomic: Int8A) { self = UInt16(atomic.load()) }
    public init(_ atomic: UIntA) { self = UInt16(atomic.load()) }
    public init(_ atomic: UInt64A) { self = UInt16(atomic.load()) }
    public init(_ atomic: UInt32A) { self = UInt16(atomic.load()) }
    public init(_ atomic: UInt8A) { self = UInt16(atomic.load()) }
    public init(_ atomic: DoubleA) { self = UInt16(atomic.load()) }
    public init(_ atomic: FloatA) { self = UInt16(atomic.load()) }
}

public extension UInt8 {
    public init(_ atomic: UInt8A) { self = UInt8(atomic.load()) }
    public init(_ atomic: IntA) { self = UInt8(atomic.load()) }
    public init(_ atomic: Int64A) { self = UInt8(atomic.load()) }
    public init(_ atomic: Int32A) { self = UInt8(atomic.load()) }
    public init(_ atomic: Int16A) { self = UInt8(atomic.load()) }
    public init(_ atomic: Int8A) { self = UInt8(atomic.load()) }
    public init(_ atomic: UIntA) { self = UInt8(atomic.load()) }
    public init(_ atomic: UInt64A) { self = UInt8(atomic.load()) }
    public init(_ atomic: UInt32A) { self = UInt8(atomic.load()) }
    public init(_ atomic: UInt16A) { self = UInt8(atomic.load()) }
    public init(_ atomic: DoubleA) { self = UInt8(atomic.load()) }
    public init(_ atomic: FloatA) { self = UInt8(atomic.load()) }
}

public extension Double {
    public init(_ atomic: DoubleA) { self = Double(atomic.load()) }
    public init(_ atomic: IntA) { self = Double(atomic.load()) }
    public init(_ atomic: Int64A) { self = Double(atomic.load()) }
    public init(_ atomic: Int32A) { self = Double(atomic.load()) }
    public init(_ atomic: Int16A) { self = Double(atomic.load()) }
    public init(_ atomic: Int8A) { self = Double(atomic.load()) }
    public init(_ atomic: UIntA) { self = Double(atomic.load()) }
    public init(_ atomic: UInt64A) { self = Double(atomic.load()) }
    public init(_ atomic: UInt32A) { self = Double(atomic.load()) }
    public init(_ atomic: UInt16A) { self = Double(atomic.load()) }
    public init(_ atomic: UInt8A) { self = Double(atomic.load()) }
    public init(_ atomic: FloatA) { self = Double(atomic.load()) }
}

public extension Float {
    public init(_ atomic: FloatA) { self = Float(atomic.load()) }
    public init(_ atomic: IntA) { self = Float(atomic.load()) }
    public init(_ atomic: Int64A) { self = Float(atomic.load()) }
    public init(_ atomic: Int32A) { self = Float(atomic.load()) }
    public init(_ atomic: Int16A) { self = Float(atomic.load()) }
    public init(_ atomic: Int8A) { self = Float(atomic.load()) }
    public init(_ atomic: UIntA) { self = Float(atomic.load()) }
    public init(_ atomic: UInt64A) { self = Float(atomic.load()) }
    public init(_ atomic: UInt32A) { self = Float(atomic.load()) }
    public init(_ atomic: UInt16A) { self = Float(atomic.load()) }
    public init(_ atomic: UInt8A) { self = Float(atomic.load()) }
    public init(_ atomic: DoubleA) { self = Float(atomic.load()) }
}

public extension Bool {
    public init(_ atomic: BoolA) { self = Bool(atomic.load()) }
}

public extension String {
    public init(_ atomic: StringA) { self = String(atomic.load()) }
}

public func + (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: DoubleA, rhs: DoubleA) -> DoubleA { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: Double, rhs: DoubleA) -> DoubleA { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: DoubleA, rhs: Double) -> DoubleA { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: FloatA, rhs: FloatA) -> FloatA { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: Float, rhs: FloatA) -> FloatA { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: FloatA, rhs: Float) -> FloatA { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: DoubleA, rhs: DoubleA) -> DoubleA { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: Double, rhs: DoubleA) -> DoubleA { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: DoubleA, rhs: Double) -> DoubleA { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func - (lhs: FloatA, rhs: FloatA) -> FloatA { lock(lhs, rhs); let result = lhs.value - rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func - (lhs: Float, rhs: FloatA) -> FloatA { lock(rhs); let result = lhs - rhs.value; unlock(rhs); return Atomic(result) }
public func - (lhs: FloatA, rhs: Float) -> FloatA { lock(lhs); let result = lhs.value - rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: DoubleA, rhs: DoubleA) -> DoubleA { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: Double, rhs: DoubleA) -> DoubleA { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: DoubleA, rhs: Double) -> DoubleA { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func * (lhs: FloatA, rhs: FloatA) -> FloatA { lock(lhs, rhs); let result = lhs.value * rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func * (lhs: Float, rhs: FloatA) -> FloatA { lock(rhs); let result = lhs * rhs.value; unlock(rhs); return Atomic(result) }
public func * (lhs: FloatA, rhs: Float) -> FloatA { lock(lhs); let result = lhs.value * rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: DoubleA, rhs: DoubleA) -> DoubleA { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: Double, rhs: DoubleA) -> DoubleA { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: DoubleA, rhs: Double) -> DoubleA { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func / (lhs: FloatA, rhs: FloatA) -> FloatA { lock(lhs, rhs); let result = lhs.value / rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func / (lhs: Float, rhs: FloatA) -> FloatA { lock(rhs); let result = lhs / rhs.value; unlock(rhs); return Atomic(result) }
public func / (lhs: FloatA, rhs: Float) -> FloatA { lock(lhs); let result = lhs.value / rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value % rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs % rhs.value; unlock(rhs); return Atomic(result) }
public func % (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value % rhs; unlock(lhs); return Atomic(result) }
public func % (lhs: DoubleA, rhs: DoubleA) -> DoubleA { lock(lhs, rhs); let result = lhs.value.truncatingRemainder(dividingBy: rhs.value); unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: Double, rhs: DoubleA) -> DoubleA { lock(rhs); let result =
    lhs.truncatingRemainder(dividingBy: rhs.value); unlock(rhs); return Atomic(result) }
public func % (lhs: DoubleA, rhs: Double) -> DoubleA { lock(lhs); let result = lhs.value.truncatingRemainder(dividingBy: rhs); unlock(lhs); return Atomic(result) }
public func % (lhs: FloatA, rhs: FloatA) -> FloatA { lock(lhs, rhs); let result = lhs.value.truncatingRemainder(dividingBy: rhs.value); unlock(lhs, rhs); return Atomic(result) }
public func % (lhs: Float, rhs: FloatA) -> FloatA { lock(rhs); let result =
    lhs.truncatingRemainder(dividingBy: rhs.value); unlock(rhs); return Atomic(result) }
public func % (lhs: FloatA, rhs: Float) -> FloatA { lock(lhs); let result = lhs.value.truncatingRemainder(dividingBy: rhs); unlock(lhs); return Atomic(result) }
public func << (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func << (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value << rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func << (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs << rhs.value; unlock(rhs); return Atomic(result) }
public func << (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value << rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func >> (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value >> rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func >> (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs >> rhs.value; unlock(rhs); return Atomic(result) }
public func >> (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value >> rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func ^ (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value ^ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func ^ (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs ^ rhs.value; unlock(rhs); return Atomic(result) }
public func ^ (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value ^ rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func & (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value & rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func & (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs & rhs.value; unlock(rhs); return Atomic(result) }
public func & (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value & rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &+ (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value &+ rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &+ (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs &+ rhs.value; unlock(rhs); return Atomic(result) }
public func &+ (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value &+ rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &- (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value &- rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &- (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs &- rhs.value; unlock(rhs); return Atomic(result) }
public func &- (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value &- rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: IntA, rhs: IntA) -> IntA { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: Int, rhs: IntA) -> IntA { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: IntA, rhs: Int) -> IntA { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: Int64A, rhs: Int64A) -> Int64A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: Int64, rhs: Int64A) -> Int64A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: Int64A, rhs: Int64) -> Int64A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: Int32A, rhs: Int32A) -> Int32A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: Int32, rhs: Int32A) -> Int32A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: Int32A, rhs: Int32) -> Int32A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: Int16A, rhs: Int16A) -> Int16A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: Int16, rhs: Int16A) -> Int16A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: Int16A, rhs: Int16) -> Int16A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: Int8A, rhs: Int8A) -> Int8A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: Int8, rhs: Int8A) -> Int8A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: Int8A, rhs: Int8) -> Int8A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: UIntA, rhs: UIntA) -> UIntA { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: UInt, rhs: UIntA) -> UIntA { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: UIntA, rhs: UInt) -> UIntA { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: UInt64A, rhs: UInt64A) -> UInt64A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: UInt64, rhs: UInt64A) -> UInt64A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: UInt64A, rhs: UInt64) -> UInt64A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: UInt32A, rhs: UInt32A) -> UInt32A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: UInt32, rhs: UInt32A) -> UInt32A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: UInt32A, rhs: UInt32) -> UInt32A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: UInt16A, rhs: UInt16A) -> UInt16A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: UInt16, rhs: UInt16A) -> UInt16A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: UInt16A, rhs: UInt16) -> UInt16A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func &* (lhs: UInt8A, rhs: UInt8A) -> UInt8A { lock(lhs, rhs); let result = lhs.value &* rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func &* (lhs: UInt8, rhs: UInt8A) -> UInt8A { lock(rhs); let result = lhs &* rhs.value; unlock(rhs); return Atomic(result) }
public func &* (lhs: UInt8A, rhs: UInt8) -> UInt8A { lock(lhs); let result = lhs.value &* rhs; unlock(lhs); return Atomic(result) }
public func + (lhs: StringA, rhs: StringA) -> StringA { lock(lhs, rhs); let result = lhs.value + rhs.value; unlock(lhs, rhs); return Atomic(result) }
public func + (lhs: String, rhs: StringA) -> StringA { lock(rhs); let result = lhs + rhs.value; unlock(rhs); return Atomic(result) }
public func + (lhs: StringA, rhs: String) -> StringA { lock(lhs); let result = lhs.value + rhs; unlock(lhs); return Atomic(result) }
public prefix func ++ (val: IntA) -> IntA { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: Int64A) -> Int64A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: Int32A) -> Int32A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: Int16A) -> Int16A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: Int8A) -> Int8A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: UIntA) -> UIntA { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: UInt64A) -> UInt64A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: UInt32A) -> UInt32A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: UInt16A) -> UInt16A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: UInt8A) -> UInt8A { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: DoubleA) -> DoubleA { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func ++ (val: FloatA) -> FloatA { lock(val); let result = val.value; val.value += 1; unlock(val); return Atomic(result) }
public prefix func -- (val: IntA) -> IntA { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: Int64A) -> Int64A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: Int32A) -> Int32A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: Int16A) -> Int16A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: Int8A) -> Int8A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: UIntA) -> UIntA { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: UInt64A) -> UInt64A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: UInt32A) -> UInt32A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: UInt16A) -> UInt16A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: UInt8A) -> UInt8A { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: DoubleA) -> DoubleA { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func -- (val: FloatA) -> FloatA { lock(val); let result = val.value; val.value -= 1; unlock(val); return Atomic(result) }
public prefix func + (val: IntA) -> IntA { lock(val); let result = +val.value; unlock(val); return Atomic(result) }
public prefix func + (val: Int64A) -> Int64A { lock(val); let result = +val.value; unlock(val); return Atomic(result) }
public prefix func + (val: Int32A) -> Int32A { lock(val); let result = +val.value; unlock(val); return Atomic(result) }
public prefix func + (val: Int16A) -> Int16A { lock(val); let result = +val.value; unlock(val); return Atomic(result) }
public prefix func + (val: Int8A) -> Int8A { lock(val); let result = +val.value; unlock(val); return Atomic(result) }
public prefix func + (val: DoubleA) -> DoubleA { lock(val); let result = +val.value; unlock(val); return Atomic(result) }
public prefix func + (val: FloatA) -> FloatA { lock(val); let result = +val.value; unlock(val); return Atomic(result) }
public prefix func - (val: IntA) -> IntA { lock(val); let result = -val.value; unlock(val); return Atomic(result) }
public prefix func - (val: Int64A) -> Int64A { lock(val); let result = -val.value; unlock(val); return Atomic(result) }
public prefix func - (val: Int32A) -> Int32A { lock(val); let result = -val.value; unlock(val); return Atomic(result) }
public prefix func - (val: Int16A) -> Int16A { lock(val); let result = -val.value; unlock(val); return Atomic(result) }
public prefix func - (val: Int8A) -> Int8A { lock(val); let result = -val.value; unlock(val); return Atomic(result) }
public prefix func - (val: DoubleA) -> DoubleA { lock(val); let result = -val.value; unlock(val); return Atomic(result) }
public prefix func - (val: FloatA) -> FloatA { lock(val); let result = -val.value; unlock(val); return Atomic(result) }
public prefix func ~ (val: IntA) -> IntA { lock(val); let result = ~val.value; unlock(val); return Atomic(result) }
public prefix func ~ (val: Int64A) -> Int64A { lock(val); let result = ~val.value; unlock(val); return Atomic(result) }
public prefix func ~ (val: Int32A) -> Int32A { lock(val); let result = ~val.value; unlock(val); return Atomic(result) }
public prefix func ~ (val: Int16A) -> Int16A { lock(val); let result = ~val.value; unlock(val); return Atomic(result) }
public prefix func ~ (val: Int8A) -> Int8A { lock(val); let result = ~val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: IntA) -> IntA { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: Int64A) -> Int64A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: Int32A) -> Int32A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: Int16A) -> Int16A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: Int8A) -> Int8A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: UIntA) -> UIntA { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: UInt64A) -> UInt64A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: UInt32A) -> UInt32A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: UInt16A) -> UInt16A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: UInt8A) -> UInt8A { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: DoubleA) -> DoubleA { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func ++ (val: FloatA) -> FloatA { lock(val); val.value += 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: IntA) -> IntA { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: Int64A) -> Int64A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: Int32A) -> Int32A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: Int16A) -> Int16A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: Int8A) -> Int8A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: UIntA) -> UIntA { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: UInt64A) -> UInt64A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: UInt32A) -> UInt32A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: UInt16A) -> UInt16A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: UInt8A) -> UInt8A { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: DoubleA) -> DoubleA { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public postfix func -- (val: FloatA) -> FloatA { lock(val); val.value -= 1; let result = val.value; unlock(val); return Atomic(result) }
public func += (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout Int, rhs: IntA) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: IntA, rhs: Int) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: DoubleA, rhs: DoubleA) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout Double, rhs: DoubleA) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: DoubleA, rhs: Double) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func += (lhs: FloatA, rhs: FloatA) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout Float, rhs: FloatA) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: FloatA, rhs: Float) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func -= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: DoubleA, rhs: DoubleA) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout Double, rhs: DoubleA) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: DoubleA, rhs: Double) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func -= (lhs: FloatA, rhs: FloatA) { lock(lhs, rhs); lhs.value -= rhs.value; unlock(lhs, rhs) }
public func -= (lhs: inout Float, rhs: FloatA) { lock(rhs); lhs -= rhs.value; unlock(rhs) }
public func -= (lhs: FloatA, rhs: Float) { lock(lhs); lhs.value -= rhs; unlock(lhs) }
public func *= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: DoubleA, rhs: DoubleA) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout Double, rhs: DoubleA) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: DoubleA, rhs: Double) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func *= (lhs: FloatA, rhs: FloatA) { lock(lhs, rhs); lhs.value *= rhs.value; unlock(lhs, rhs) }
public func *= (lhs: inout Float, rhs: FloatA) { lock(rhs); lhs *= rhs.value; unlock(rhs) }
public func *= (lhs: FloatA, rhs: Float) { lock(lhs); lhs.value *= rhs; unlock(lhs) }
public func /= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: DoubleA, rhs: DoubleA) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout Double, rhs: DoubleA) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: DoubleA, rhs: Double) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func /= (lhs: FloatA, rhs: FloatA) { lock(lhs, rhs); lhs.value /= rhs.value; unlock(lhs, rhs) }
public func /= (lhs: inout Float, rhs: FloatA) { lock(rhs); lhs /= rhs.value; unlock(rhs) }
public func /= (lhs: FloatA, rhs: Float) { lock(lhs); lhs.value /= rhs; unlock(lhs) }
public func %= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value %= rhs.value; unlock(lhs, rhs) }
public func %= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs %= rhs.value; unlock(rhs) }
public func %= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value %= rhs; unlock(lhs) }
public func %= (lhs: DoubleA, rhs: DoubleA) { lock(lhs, rhs); lhs.value = lhs.value.truncatingRemainder(dividingBy: rhs.value); unlock(lhs, rhs) }
public func %= (lhs: inout Double, rhs: DoubleA) { lock(rhs); lhs = lhs.truncatingRemainder(dividingBy: rhs.value); unlock(rhs) }
public func %= (lhs: DoubleA, rhs: Double) { lock(lhs); lhs.value = lhs.value.truncatingRemainder(dividingBy: rhs); unlock(lhs) }
public func %= (lhs: FloatA, rhs: FloatA) { lock(lhs, rhs); lhs.value = lhs.value.truncatingRemainder(dividingBy: rhs.value); unlock(lhs, rhs) }
public func %= (lhs: inout Float, rhs: FloatA) { lock(rhs); lhs = lhs.truncatingRemainder(dividingBy: rhs.value); unlock(rhs) }
public func %= (lhs: FloatA, rhs: Float) { lock(lhs); lhs.value = lhs.value.truncatingRemainder(dividingBy: rhs); unlock(lhs) }
public func += (lhs: StringA, rhs: StringA) { lock(lhs, rhs); lhs.value += rhs.value; unlock(lhs, rhs) }
public func += (lhs: inout String, rhs: StringA) { lock(rhs); lhs += rhs.value; unlock(rhs) }
public func += (lhs: StringA, rhs: String) { lock(lhs); lhs.value += rhs; unlock(lhs) }
public func <<= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func <<= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value <<= rhs.value; unlock(lhs, rhs) }
public func <<= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs <<= rhs.value; unlock(rhs) }
public func <<= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value <<= rhs; unlock(lhs) }
public func >>= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func >>= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value >>= rhs.value; unlock(lhs, rhs) }
public func >>= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs >>= rhs.value; unlock(rhs) }
public func >>= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value >>= rhs; unlock(lhs) }
public func ^= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func ^= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value ^= rhs.value; unlock(lhs, rhs) }
public func ^= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs ^= rhs.value; unlock(rhs) }
public func ^= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value ^= rhs; unlock(lhs) }
public func &= (lhs: IntA, rhs: IntA) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout Int, rhs: IntA) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: IntA, rhs: Int) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: Int64A, rhs: Int64A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout Int64, rhs: Int64A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: Int64A, rhs: Int64) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: Int32A, rhs: Int32A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout Int32, rhs: Int32A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: Int32A, rhs: Int32) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: Int16A, rhs: Int16A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout Int16, rhs: Int16A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: Int16A, rhs: Int16) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: Int8A, rhs: Int8A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout Int8, rhs: Int8A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: Int8A, rhs: Int8) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: UIntA, rhs: UIntA) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout UInt, rhs: UIntA) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: UIntA, rhs: UInt) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: UInt64A, rhs: UInt64A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout UInt64, rhs: UInt64A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: UInt64A, rhs: UInt64) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: UInt32A, rhs: UInt32A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout UInt32, rhs: UInt32A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: UInt32A, rhs: UInt32) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: UInt16A, rhs: UInt16A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout UInt16, rhs: UInt16A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: UInt16A, rhs: UInt16) { lock(lhs); lhs.value &= rhs; unlock(lhs) }
public func &= (lhs: UInt8A, rhs: UInt8A) { lock(lhs, rhs); lhs.value &= rhs.value; unlock(lhs, rhs) }
public func &= (lhs: inout UInt8, rhs: UInt8A) { lock(rhs); lhs &= rhs.value; unlock(rhs) }
public func &= (lhs: UInt8A, rhs: UInt8) { lock(lhs); lhs.value &= rhs; unlock(lhs) }

