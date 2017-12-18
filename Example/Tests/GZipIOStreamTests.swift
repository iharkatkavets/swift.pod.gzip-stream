//
//  ZipIOStreamTests.swift
//  ZipStream_Tests
//
//  Created by Igor Kotkovets on 12/18/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import GZipStream

class GZipIOStreamTests: XCTestCase {
    
    func testThatZipUnzipText() {
        assertNoThrow({
            let dataOutputStream = DataOutputStream()
            let zipOutputStream = try GZipOutputStream(with: dataOutputStream)
            try Constants.originData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
                _ = try zipOutputStream.write(bytes, maxLength: Constants.originData.count)
            }
            try zipOutputStream.close()

            let dataInputStream = DataInputStream(withData: dataOutputStream.data)
            let zipInputStream = try GZipInputStream(with: dataInputStream)
            let readBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Constants.originData.count)
            let readLength = zipInputStream.read(readBuffer, maxLength: Constants.originData.count)
            let string = String(bytesNoCopy: readBuffer, length: readLength, encoding: .utf8, freeWhenDone: false)
            assertPairsEqual(expected: Constants.originText, actual: string)
        })

    }
    
}
