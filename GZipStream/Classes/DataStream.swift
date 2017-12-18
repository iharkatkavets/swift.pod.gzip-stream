//
//  DataInputStream.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/4/17.
//

import Foundation

public class DataInputStream: InputStream {
    var bufferOffset = 0
    var data: Data

    public var hasBytesAvailable: Bool {
        return bufferOffset < data.count
    }

    public init(withData: Data) {
        data = withData
    }

    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        if bufferOffset >= data.count {
            return 0
        }

        let existentData = min(data.count-bufferOffset, len)
        data.withUnsafeBytes {
            buffer.initialize(from: ($0+bufferOffset), count: existentData)
        }
        bufferOffset += existentData

        return existentData
    }
}

public class DataOutputStream: OutputStream {
    public private(set) var data: Data = Data()

    public var hasSpaceAvailable: Bool {
        return true
    }

    public init() {
    }

    public func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) throws -> Int {
        data.append(buffer, count: len)
        return len
    }

    public func close() throws {
    }
}
