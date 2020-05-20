//
//  String.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/7/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

//   struct String
//   +------------------------------------------------+
//   | struct _StringGuts                             |
//   | +--------------------------------------------+ |
//   | | struct _StringObject                       | |
//   | | +----------------------------------------+ | |
//   | | | #if arch(i386) || arch(arm)            | | |
//   | | |                                        | | |
//   | | |    --- 32-bit platforms ---            | | |
//   | | |                                        | | |
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
//   | | |                                        | | |
//   | | | #else                                  | | |
//   | | |                                        | | |
//   | | |     --- 64-bit platforms ---           | | |
//   | | |                                        | | |
//   | | |   var _countAndFlagsBits: UInt64       | | |
//   | | |   var _object: Builtin.BridgeObject    | | |
//   | | |                                        | | |
//   | | | #endif                                 | | |
//   | | +----------------------------------------+ | |
//   | +--------------------------------------------+ |
//   +------------------------------------------------+
//                                                                       +--------------------------------------+
//                                                                       |                                      |
//                                                                       |                                      |
//          / count <= 15, Small    =>  15 bytes(string) + 1 byte(_object.abcdeeee)      \                      |
//   String                                                                                 16 bytes            |
//          \ count > 15,  Large    =>  8 bytes(_countAndFlagsBits) + 8 bytes(_object)   /                      |
//                                                       |                       |                              |
//                                                       |                       |                              |
//         +---------------------------------------------+                       +------------------------------+
//         |                                                                                                    |
//         |                                                                                                    |
//         |                                                                                                    |
//         V                                                                                                    |
//    _countAndFlagsBits (64 bits)                                                                              |
//                                                                                                              |
//    abcd               a => isASCII               b => isNFC                                                  |
//    ∧∧∧∧               c => isNativelyStored      d => isTailAllocated                                        |
//    ||||                                                                                                      |
//    0000000000000000000000000000000000000000000000000000000000000000                                          |
//    |              ||                                              |                                          |
//     \   16 bits  /  \                48 bits                     /                                           |
//      \   flags  /    \        count for Large String            /                                            |
//       \________/      \________________________________________/                                             |
//                                                                                                              |
//                                                                                                              |
//                                                                                                              |
//                                                                                                              |
//         +----------------------------------------------------------------------------------------------------+
//         |
//         |
//         V
//    _object (64 bits)
//   
//    abcdeeee          a => isImmortal            b => largeIsCocoa            e(4 bits) => count of Small String
//    ∧∧∧∧∧∧∧∧          c => isSmall               d => providesFastUTF8
//    ||||||||
//    0000000000000000000000000000000000000000000000000000000000000000
//    |      ||                                                      |
//     \    /  \                      56 bits                       /
//      \  /    \               pointer for Large String           /
//       +       \________________________________________________/
//       |
//       V
//       8 bits, 1 byte


public extension String {
    var valuePointer: UnsafeMutableRawPointer? {
        mutating get {
            #if arch(i386) || arch(arm)
            // 32-bit platforms wati to do
            return nil
            #else
            if self.count <= 15 {
                // - Small strings
                return withUnsafePointer(to: &self) { UnsafeMutableRawPointer(mutating: $0) }
            } else {
                // - Large strings
                let _object = unsafeBitCast(self, to: (UInt64, UInt64).self).1
                let pointerMask = 1 << 56 - 1                     // 56 bits => 111...111
                let pointerValue = _object & UInt64(pointerMask)
                return UnsafeMutableRawPointer(bitPattern: UInt(pointerValue))?.advanced(by: 32)
            }
            #endif
        }
    }
}
