//
//  InputStream.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/3/17.
//

public protocol InputStream {
    var hasBytesAvailable: Bool { get }
    func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int
}

public protocol OutputStream {
    var hasSpaceAvailable: Bool { get }
    func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) throws -> Int
    func close() throws
}
