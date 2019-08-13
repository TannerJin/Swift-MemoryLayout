//
//  String.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/7/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension String {
//   struct String
//   +------------------------------------------------+
//   | struct _StringGuts                             |
//   | +--------------------------------------------+ |
//   | | struct _StringObject                       | |
//   | | +----------------------------------------+ | |
//   | | | #if arch(i386) || arch(arm)            | | |
//   | | |   enum Variant {                       | | |
//   | | |     case immortal(UInt)                | | |
//   | | |     case native(AnyObject)             | | |
//   | | |     case bridged(_CocoaString)         | | |
//   | | |   }                                    | | |
//   | | |   var count: UInt                      | | |
//   | | |   var _variant: Variant                | | |
//   | | |   var _discriminator: UInt8            | | |
//   | | |   var _flags: UInt16                   | | |
//   | | |   var _countAndFlagsBits: UInt64       | | |
//   | | | #else                                  | | |
//   | | |   var _countAndFlagsBits: UInt64       | | |
//   | | |   var _object: Builtin.BridgeObject    | | |
//   | | | #endif                                 | | |
//   | | +----------------------------------------+ | |
//   | +--------------------------------------------+ |
//   +------------------------------------------------+
    
    var valuePointer: UnsafeMutableRawPointer? {
        mutating get {
            #if arch(i386) || arch(arm)
            // wati to do
            return nil
            #else
            if self.count < MemoryLayout<String>.size {
                // - Small strings
                return withUnsafePointer(to: &self) { UnsafeMutableRawPointer(mutating: $0) }
            } else {
                // - Large strings
                let _object = unsafeBitCast(self, to: (UInt64, UInt).self).1
                let pointerValue = (_object &<< 8) &>> 8
                return UnsafeMutableRawPointer(bitPattern: pointerValue)?.advanced(by: 32)
            }
            #endif
        }
    }
}
