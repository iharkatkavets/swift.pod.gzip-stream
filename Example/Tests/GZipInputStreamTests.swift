//
//  ZipInputStreamTests.swift
//  ZipStream_Tests
//
//  Created by Igor Kotkovets on 12/18/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import GZipStream
import CleanTests

class GZipInputStreamTests: XCTestCase {
    
    func testThatDecompressGZipData() {
        assertNoThrow({
            let dataStream = DataInputStream(withData: Constants.gzipData)
            let zipStream = try GZipInputStream(with: dataStream)
            let readBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1000000)
            let readBytes = zipStream.read(readBuffer, maxLength: 1000000)
            let unpackText = String(bytesNoCopy: readBuffer, length: readBytes, encoding: .utf8, freeWhenDone: false)
            assertPairsEqual(expected: Constants.originText, actual: unpackText)
            assertFalse(zipStream.hasBytesAvailable)
        })
    }
    
}
