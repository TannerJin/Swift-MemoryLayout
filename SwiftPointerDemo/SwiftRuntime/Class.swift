//
//  Class.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/2.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

//    class     
//    +-----------------------------------------------------------------------+
//    |   var isa: objc_class*                                                |
//    |   var refCount: UInt64  >>>>>>>>---------------------------------------------------------+
//    |-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -                      |                  |
//    |   var attribute0: String                                              |                  |
//    |   var attribute1: [Int]                                               |                  |
//    |   .                                                                   |                  |
//    |   .                                                                   |                  |
//    |   .                                                                   |                  |
//    +-----------------------------------------------------------------------+                  |
                                                                                            //   |
//    class: NSObject                                                                            |
//    +-----------------------------------------------------------------------+                  |
//    |   var isa: objc_class*                                                |                  |
//    |-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -                      |                  |
//    |   var attribute0: String                                              |                  |
//    |   var attribute1: [Int]                                               |                  |
//    |   .                                                                   |                  |
//    |   .                                                                   |                  |
//    |   .                                                                   |                  |
//    +-----------------------------------------------------------------------+                  |
                                                                                            //   |
                                                                                            //   |
                                                                                            //   |
//                      +------------------------------------------------------------------------+
//                      |
//                      V
//  refCount(8 bytes, 64 bits)
//     /
//    |
//    V
//  InlineRefCounts {
//      atomic<InlineRefCountBits> {
//          strong RC + unowned RC + flags
//          OR
//          HeapObjectSideTableEntry*
//      }          /
//  }             |
//                V
//  HeapObjectSideTableEntry {
//      SideTableRefCounts {
//          object pointer
//          atomic<SideTableRefCountBits> {
//              strong RC + unowned RC + weak RC + flags
//          }
//      }
//  }

//  InlineRefCountBits (64 bits)
//  0000000000000000000000000000000000000000000000000000000000000000
//  ||                            |||                             ||
//  | \         30 bits          / | \          31 bits          / |
//  |  \   StrongExtraRefCount  /  |  \     UnownedRefCount     /  |
//  |   \______________________/   |   \_______________________/   |
//  |                              |                               |
//  V                              V                               V
// UseSlow                     IsDeiniting                     IsImmortal
// (1 bit)                       (1 bit)                        (1 bit)

//  HeapObjectSideTableEntry* (64 bits)
//  0000000000000000000000000000000000000000000000000000000000000000
//   ||                                                            |
//   | \                      62 bits                             /
//   |  \              HeapObjectSideTableEntry*                 /
//   |   \______________________________________________________/
//   |
//   V
// SideTableMark
// (1 bit)


public func hasWeakRefCount(_ objcPointer: UnsafeMutablePointer<UInt64>) -> Bool {
    // UseSlow && !IsImmortal
    let nsobjcPointer = unsafeBitCast(NSObject(), to: UnsafeMutablePointer<UInt64>.self)
    assert((objcPointer.pointee != nsobjcPointer.pointee), "NSObject's instace has not refCount")
    
    let bitsValue = objcPointer.advanced(by: 1).pointee
    
    let isImmortalMask: UInt64 = 1
    let isImmortalValue = bitsValue & isImmortalMask
    
    let useSlowMask: UInt64 = 1 << 63
    let useSlowValue = (bitsValue & useSlowMask) >> 63
    
    return (useSlowValue == 1) && (isImmortalValue != 1)
}

// Return unowned reference count.
// Note that this is not equal to the number of outstanding unowned pointers.
public func UnownedRefCount(_ objcPointer: UnsafeMutablePointer<UInt64>) -> UInt32 {
    assertNotNSObject(objcPointer)
    assert(!hasWeakRefCount(objcPointer), "wait to do")
    
    let bitsValue = objcPointer.advanced(by: 1).pointee
    var mask: UInt64 = 1 << 31 - 1                    // 31 bits => 111...111
    mask <<= 1                                        // 32 bits => 111...110
    return UInt32((bitsValue & mask) >> 1) - 1        // at init refCount (strong: 0, Unowned: 1)
}

public func StrongRefCount(_ objcPointer: UnsafeMutablePointer<UInt64>) -> UInt32 {
    assertNotNSObject(objcPointer)
    assert(!hasWeakRefCount(objcPointer), "wait to do")
    
    let bitsValue = objcPointer.advanced(by: 1).pointee
    var mask: UInt64 = 1 << 30 - 1                    // 30 bits => 111...111
    mask <<= 33                                       // 63 bits => 111...111000...000
    return UInt32((bitsValue & mask) >> 33) + 1       // at init refCount (strong: 0, Unowned: 1)
}


// nil: has not weak reference
public func WeakRefCount(_ objcPointer: UnsafeMutablePointer<UInt64>) -> UInt32? {
    assertNotNSObject(objcPointer)
    
    if !hasWeakRefCount(objcPointer) {
        return nil
    }
    
    // wait to do
    return nil
}


// MARK: - Helper
private func assertNotNSObject(_ objcPointer: UnsafeMutablePointer<UInt64>) {
    let nsobjcPointer = unsafeBitCast(NSObject(), to: UnsafeMutablePointer<UInt64>.self)
    assert((objcPointer.pointee != nsobjcPointer.pointee), "NSObject's instace has not refCount")
}

private func getSileTablePointer(_ objcPointer: UnsafeMutablePointer<UInt64>) -> UnsafeMutableRawPointer? {
    assertNotNSObject(objcPointer)
    assert(hasWeakRefCount(objcPointer))
    
    let bitsValue = objcPointer.advanced(by: 1).pointee
    let mask: UInt64 = 1 << 62 - 1                  // 62 bits => 111...111
    let slieTableValue = bitsValue & mask
    return UnsafeMutableRawPointer(bitPattern: UInt(slieTableValue << 3))
}

private struct HeapObjectSideTableEntry {
    var objc: UnsafeMutableRawPointer
    var bits: UInt64
    var weakBits: UInt32
}
