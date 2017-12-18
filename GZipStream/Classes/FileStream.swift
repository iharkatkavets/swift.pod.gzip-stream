//
//  FileInputStream.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/3/17.
//

import Foundation

public class FileInputStream: InputStream {
    let fileHandle: FileHandle
    var eofReached = false

    public init(withFileHandle: FileHandle) {
        self.fileHandle = withFileHandle
    }

    public var hasBytesAvailable: Bool {
        return !eofReached
    }

    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        let readData = fileHandle.readData(ofLength: len)
        eofReached = (readData.count != len)
        readData.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            buffer.initialize(from: ptr, count: readData.count)
        }

        return readData.count
    }
}

public class FileOutputStream: OutputStream {
    let fileHandle: FileHandle

    public var hasSpaceAvailable: Bool {
        return true
    }

    public init(with fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }

    public func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) throws -> Int {
        let data = Data(bytes: buffer, count: len)
        fileHandle.write(data)
        return len
    }

    public func close() throws { }
}
