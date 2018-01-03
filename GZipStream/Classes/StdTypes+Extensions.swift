//
//  StdTypes+Extensions.swift
//  XML2Swift
//
//  Created by Igor Kotkovets on 12/22/17.
//

import Foundation

public extension FixedWidthInteger {
    func hexString(withAdding prefix: String? = nil) -> String {
        var copy = self

        return withUnsafePointer(to: &copy) { ptr -> String in
            let count = MemoryLayout<Self>.size
            return ptr.withMemoryRebound(to: UInt8.self, capacity: count) { (bytes) -> String in
                var str: String = prefix ?? ""
                for i in 0..<count {
                    str += String(format: "%02x", bytes[i])
                }
                return str
            }
        }
    }
}

public extension Data {
    func hexString(withAdding prefix: String? = nil) -> String {
        var result = prefix ?? ""
        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)

        for byte in bytes {
            result += String(format: "%02x", UInt(byte))
        }

        return result
    }

    public init?(hex string: String) {
        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(character: c) else {
                return nil
            }

            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }

        guard even else {
            return nil
        }
    }

    // Convert 0 ... 9, a ... f, A ...F to their decimal value,
    // return nil for all other input characters
    private func decodeNibble(character: UInt16) -> UInt8? {
        switch character {
        case 0x30 ... 0x39: // 0..9
            return UInt8(character - 0x30)
        case 0x41 ... 0x46: // A..F
            return UInt8(character - 0x41 + 10)
        case 0x61 ... 0x66: // a..f
            return UInt8(character - 0x61 + 10)
        default:
            return nil
        }
    }
}

public extension UnsafeMutablePointer where Pointee: FixedWidthInteger {
    public func isEqual(to buffer: UnsafeMutablePointer<Pointee>, ofLength length: Int) -> Bool {
        for i in 0..<length where self[i] != buffer[i] {
            return false
        }

        return true
    }

    public func isEqual(to buffer: UnsafePointer<Pointee>, ofLength length: Int) -> Bool {
        for i in 0..<length where self[i] != buffer[i] {
            return false
        }

        return true
    }

    public func hexString(ofLength len: Int, withAdding prefix: String? = nil) -> String {
        let count = MemoryLayout<Pointee>.size
        return self.withMemoryRebound(to: UInt8.self, capacity: count) { (bytes) -> String in
            var str: String = prefix ?? ""
            for i in 0..<count*len {
                str += String(format: "%02x", bytes[i])
            }
            return str
        }
    }
}

public extension UnsafePointer where Pointee: FixedWidthInteger {
    public func isEqual(to buffer: UnsafePointer<Pointee>, ofLength length: Int) -> Bool {
        for i in 0..<length where self[i] != buffer[i] {
            return false
        }

        return true
    }

    public func isEqual(to buffer: UnsafeMutablePointer<Pointee>, ofLength length: Int) -> Bool {
        for i in 0..<length where self[i] != buffer[i] {
            return false
        }

        return true
    }

    public func hexString(ofLength len: Int, withAdding prefix: String? = nil) -> String {
        let count = MemoryLayout<Pointee>.size
        return self.withMemoryRebound(to: UInt8.self, capacity: count) { (bytes) -> String in
            var str: String = prefix ?? ""
            for i in 0..<count*len {
                str += String(format: "%02x", bytes[i])
            }
            return str
        }
    }
}

extension String {
    func xmlChar() -> [UInt8]? {
        guard let cStr = cString(using: .utf8) else {
            return nil
        }

        return cStr.withUnsafeBytes {
            return Array($0)
        }
    }
}
