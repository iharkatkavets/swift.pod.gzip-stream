//
//  ZipInputStream.swift
//  Pods-ZipStream_Example
//
//  Created by Igor Kotkovets on 12/16/17.
//
// https://www.zlib.net/zpipe.c

import Foundation
import zlib

enum GZipStreamError: Swift.Error {
    case failedToCreateStream
    case invalid
    case unableToProcessStream
    case failedToReadCompressedData
    case inflateInit2(Int32)
    case deflateInit2(Int32)
    case deflate(Int32)
    case failedToWrite
}

struct GZipStreamConstants {
    static let gzipInputBufferSize = 32768
    static let gzipOutputBufferSize = 16384
}

public class GZipInputStream: InputStream {
    var zstream: z_stream
    let inputStream: GZipStream.InputStream
    var inputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: GZipStreamConstants.gzipInputBufferSize)
    var outputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: GZipStreamConstants.gzipOutputBufferSize)
    var eofReached: Bool = false
    var bufferOffset = 0
    var bufferSize = 0

    public init(with inputStream: InputStream) throws {
        self.inputStream = inputStream

        zstream = z_stream()
        zstream.zalloc = nil
        zstream.zfree = nil
        zstream.opaque = nil
        zstream.avail_in = 0
        zstream.avail_out = 0
        zstream.next_in = nil
        zstream.next_out = nil

        let result = inflateInit2_(&zstream,
                                   15+32,
                                   ZLIB_VERSION,
                                   Int32(MemoryLayout<z_stream>.size))
        if result != Z_OK {
            throw GZipStreamError.inflateInit2(result)
        }
    }

    deinit {
        inputBuffer.deallocate(capacity: GZipStreamConstants.gzipInputBufferSize)
        outputBuffer.deallocate(capacity: GZipStreamConstants.gzipOutputBufferSize)
    }

    public var hasBytesAvailable: Bool {
        return !eofReached
    }

    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        var remaining = len
        var offset = 0
        var actualLength = 0

        while remaining > 0 {
            if bufferOffset >= bufferSize {
                do {
                    let couldDecompress = try decompress()
                    if couldDecompress == false {
                        return len - remaining
                    }
                } catch {
                    print("Unable to decompress")
                }
            }

            actualLength = min(remaining, bufferSize-bufferOffset)
            (buffer+offset).initialize(from: outputBuffer+bufferOffset, count: actualLength)

            bufferOffset += actualLength
            offset += actualLength
            remaining -= actualLength
        }

        return offset
    }

    func decompress() throws -> Bool {
        if eofReached {
            return false
        }

        var inflateResult: Int32 = 0
        zstream.avail_out = uInt(GZipStreamConstants.gzipOutputBufferSize)
        zstream.next_out = outputBuffer

        repeat {
            if zstream.avail_in == 0 {
                let inputRead = inputStream.read(inputBuffer, maxLength: GZipStreamConstants.gzipInputBufferSize)
                if inputRead <= 0 {
                    inflateEnd(&zstream)
                    throw GZipStreamError.failedToReadCompressedData
                }

                zstream.avail_in = uInt(inputRead)
                zstream.next_in = inputBuffer
            }

            inflateResult = inflate(&zstream, Z_NO_FLUSH)
            if inflateResult != Z_OK {
                inflateEnd(&zstream)

                if inflateResult != Z_STREAM_END {
                    try translateZLib(result: inflateResult)
                }

                eofReached = true
                break
            }

        } while(zstream.avail_out > 0)

        if eofReached {
            bufferSize = GZipStreamConstants.gzipOutputBufferSize - Int(zstream.avail_out)
        } else {
            bufferSize = GZipStreamConstants.gzipOutputBufferSize
        }

        bufferOffset = 0

        return true
    }

    func translateZLib(result: Int32) throws {
        switch result {
        case Z_OK:
            print("Z_OK")
        case Z_STREAM_END:
            print("Z_STREAM_END")
        case Z_NEED_DICT:
            print("Z_NEED_DICT")
        case Z_ERRNO:
            print("Z_ERRNO")
        case Z_STREAM_ERROR:
            print("Z_STREAM_ERROR")
        case Z_DATA_ERROR:
            print("Z_DATA_ERROR")
        case Z_MEM_ERROR:
            print("Z_MEM_ERROR")
        case Z_BUF_ERROR:
            print("Z_BUF_ERROR")
        case Z_VERSION_ERROR:
            print("Z_VERSION_ERROR")
        default:
            print("UNSPECIFIED ERROR")
        }
    }
}

public class GZipOutputStream: OutputStream {
    let outputStream: OutputStream
    var zstream: z_stream
    var outputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: GZipStreamConstants.gzipOutputBufferSize)

    public var hasSpaceAvailable: Bool {
        return true
    }

    public init(with outputStream: OutputStream) throws {
        self.outputStream = outputStream

        zstream = z_stream()
        zstream.zalloc = nil
        zstream.zfree = nil
        zstream.opaque = nil
        zstream.avail_in = 0
        zstream.avail_out = 0
        zstream.next_in = nil
        zstream.next_out = nil

        let result = deflateInit2_(&zstream,
                                   Z_DEFAULT_COMPRESSION,
                                   Z_DEFLATED,
                                   15+16,
                                   8,
                                   Z_DEFAULT_STRATEGY,
                                   ZLIB_VERSION,
                                   Int32(MemoryLayout<z_stream>.size))
        if result != Z_OK {
            throw GZipStreamError.deflateInit2(result)
        }
    }

    deinit {
        outputBuffer.deallocate(capacity: GZipStreamConstants.gzipOutputBufferSize)
    }

    public func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) throws -> Int {
        var processedDataLength = 0

        let mutBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
        mutBuffer.initialize(from: buffer, count: len)
        zstream.avail_in = UInt32(len)
        zstream.next_in = mutBuffer

        while zstream.avail_in > 0 {
            repeat {
                zstream.avail_out = UInt32(GZipStreamConstants.gzipOutputBufferSize)
                zstream.next_out = outputBuffer

                let result = deflate(&zstream, Z_NO_FLUSH)
                if result == Z_STREAM_ERROR {
                    deflateEnd(&zstream)
                    throw GZipStreamError.deflate(result)
                }

                processedDataLength = GZipStreamConstants.gzipOutputBufferSize-Int(zstream.avail_out)
                if try outputStream.write(outputBuffer, maxLength: processedDataLength) != processedDataLength {
                    deflateEnd(&zstream)
                    throw GZipStreamError.failedToWrite
                }
            } while zstream.avail_out == 0
        }

        mutBuffer.deallocate(capacity: len)

        return len
    }

    public func close() throws {
        var result: Int32
        var remaining = 0

        zstream.avail_in = 0
        zstream.next_in = nil

        repeat {
            zstream.avail_out = UInt32(GZipStreamConstants.gzipOutputBufferSize)
            zstream.next_out = outputBuffer

            result = deflate(&zstream, Z_FINISH)
            if result == Z_STREAM_ERROR {
                deflateEnd(&zstream)
                throw GZipStreamError.deflate(result)
            }

            remaining = GZipStreamConstants.gzipOutputBufferSize-Int(zstream.avail_out)
            if try outputStream.write(outputBuffer, maxLength: remaining) != remaining {
                deflateEnd(&zstream)
                throw GZipStreamError.failedToWrite
            }
        } while result != Z_STREAM_END

        deflateEnd(&zstream)

        try outputStream.close()
    }
}
