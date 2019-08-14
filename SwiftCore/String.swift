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
//   | | |   var _countAndFlagsBits: UInt64     >>------------------------------------+
//   | | |   var _object: Builtin.BridgeObject  >>------------------------------------ -------------------------+
//   | | |                                        | | |                               |                         |
//   | | | #endif                                 | | |                               |                         |
//   | | +----------------------------------------+ | |                               |                         |
//   | +--------------------------------------------+ |                               |                         |
//   +------------------------------------------------+                               |                         |
//                                                                                    |                         |
//                                                                                    |                         |
//                                                                                    |                         |
//         +--------------------------------------------------------------------------+                         |
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
//      \   flags  /    \        Count for Large String            /                                            |
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
//    abcdeeee          a => isImmortal            b => largeIsCocoa            e(4 bits) => count of Small String (4 bit max => 15 , so perfert design🚀)
//    ∧∧∧∧∧∧∧∧          c => isSmall               d => providesFastUTF8
//    ||||||||
//    0000000000000000000000000000000000000000000000000000000000000000
//    |      ||                                                      |
//     \    /  \                      56 bits                       /
//      \  /    \               Pointer for Large String           /
//       +       \________________________________________________/
//       |
//       |
//       +---> 8 bits, 1 byte => decide to how to store String
//                                      |
//                                      |
//       +------------------------------+
//       |
//       |
//       |
//       V
//    if _object.c == 1 {
//
         // - Small strings
//
//       (_countAndFlagsBits + _object.pointer)'s size to store String  (count <= 15 bytes)
//
//    } else {
//
         // - Large strings
//
//       _object.pointer point to String                                (count > 15 bytes)
//    }

    
    var valuePointer: UnsafeMutableRawPointer? {
        mutating get {
            #if arch(i386) || arch(arm)
            // wati to do
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
