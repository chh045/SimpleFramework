//
//  MediaStream.swift
//  MediaPacket
//
//  Created by REDSTATION on 4/25/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import Foundation
public enum MediaType {
    case video
    case audio
    case unknownMediaType
}

public enum MediaSubtype {
    case videoIFrame, videoNonIFrame, videoPPS, videoSPS,
        unknownMediaSubtype
}

public enum StreamIntegrity {
    case complete, broken, missOne, missTwo, missThree,
        missMulti
}

public struct MediaStream {
    var type: MediaType
    var subtype: MediaSubtype
    var integrity: StreamIntegrity = .complete
    var data: ByteSequence

    init(mediaStream: MediaStream) {
        self = mediaStream
    }

    init(type: MediaType, subtype: MediaSubtype, data: ByteSequence = ByteSequence()) {
        self.type = type
        self.subtype = subtype
        self.data = data
    }
}

public struct MediaStreamList {
    private var list: [MediaStream]
    public init() {
        list = [MediaStream]()
    }
}

extension MediaStreamList: RangeReplaceableCollection {
    public typealias Index = Int
    public typealias Element = MediaStream

    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression, Element == C.Element, Index == R.Bound {
        list.replaceSubrange(subrange, with: newElements)
    }

    public subscript(position: Index) -> Element { return list[position] }

    public var startIndex: Index {
        return list.startIndex
    }

    public var endIndex: Index {
        return list.endIndex
    }

    public func index(after i: Index) -> Index {
        return list.index(after: i)
    }
}
