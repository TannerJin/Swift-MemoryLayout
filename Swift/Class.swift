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
//    |   var property0: String                                               |                  |
//    |   var property1: [Int]                                                |                  |
//    |   .                                                                   |                  |
//    |   .                                                                   |                  |
//    |   .                                                                   |                  |
//    +-----------------------------------------------------------------------+                  |
                                                                                            //   |
//    class: NSObject                                                                            |
//    +-----------------------------------------------------------------------+                  |
//    |   var isa: objc_class*                                                |                  |
//    |-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -                      |                  |
//    |   var property0: String                                               |                  |
//    |   var property1: [Int]                                                |                  |
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
//    refCount(8 bytes, 64 bits)
//       /
//      |
//      V
//    InlineRefCounts {
//        atomic<InlineRefCountBits> {
//            strong RC + unowned RC + flags
//            OR
//            HeapObjectSideTableEntry*
//        }          /
//    }             |
//                  V
//    HeapObjectSideTableEntry {
//        SideTableRefCounts {
//            object pointer
//            atomic<SideTableRefCountBits> {
//                strong RC + unowned RC + weak RC + flags
//            }
//        }
//    }

//    InlineRefCountBits (64 bits)
//    0000000000000000000000000000000000000000000000000000000000000000
//    ||                            |||                             ||
//    | \         30 bits          / | \          31 bits          / |
//    |  \   StrongExtraRefCount  /  |  \     UnownedRefCount     /  |
//    |   \______________________/   |   \_______________________/   |
//    |                              |                               |
//    V                              V                               V
//   UseSlow                     IsDeiniting                     IsImmortal
//   (1 bit)                       (1 bit)                        (1 bit)

//    HeapObjectSideTableEntry* (64 bits)
//    0000000000000000000000000000000000000000000000000000000000000000
//     ||                                                            |
//     | \                      62 bits                             /
//     |  \              HeapObjectSideTableEntry*                 /
//     |   \______________________________________________________/
//     |
//     V
//   SideTableMark
//   (1 bit)

public func hasWeakRefCount<T: AnyObject>(_ objc: T) -> Bool {
    assertNotNSObject(objc)
    
    let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
    let bitsValue = objcPointer.advanced(by: 1).pointee
    
    let isImmortalMask: UInt64 = 1
    let isImmortalValue = bitsValue & isImmortalMask
    
    let useSlowMask: UInt64 = 1 << 63
    let useSlowValue = (bitsValue & useSlowMask) >> 63
    
    return (useSlowValue == 1) && (isImmortalValue != 1)
}

// Return unowned reference count.
// Note that this is not equal to the number of outstanding unowned pointers.
public func UnownedRefCount<T: AnyObject>(_ objc: T) -> UInt32 {
    assertNotNSObject(objc)
    assert(!hasWeakRefCount(objc), "wait to do")
    
    let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
    let bitsValue = objcPointer.advanced(by: 1).pointee
    var mask: UInt64 = 1 << 31 - 1                    // 31 bits => 111...111
    mask <<= 1                                        // 32 bits => 111...110
    return UInt32((bitsValue & mask) >> 1) - 1        // at init refCount (strong: 0, Unowned: 1)
}

public func StrongRefCount<T: AnyObject>(_ objc: T) -> UInt32 {
    assertNotNSObject(objc)
    assert(!hasWeakRefCount(objc), "wait to do")
    
    let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
    let bitsValue = objcPointer.advanced(by: 1).pointee
    var mask: UInt64 = 1 << 30 - 1                    // 30 bits => 111...111
    mask <<= 33                                       // 63 bits => 111...111000...000
    return UInt32((bitsValue & mask) >> 33) + 1       // at init refCount (strong: 0, Unowned: 1)
}


// nil: has not weak reference
public func WeakRefCount<T: AnyObject>(_ objc: T) -> UInt32? {
    assertNotNSObject(objc)
    
    if !hasWeakRefCount(objc) {
        return nil
    }
    
    // wait to do
    return nil
}


// MARK: - Helper
private func assertNotNSObject<T: AnyObject>(_ objc: T) {  // where T != NSObject
    let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
    let nsobjcPointer = unsafeBitCast(NSObject(), to: UnsafeMutablePointer<UInt64>.self)
    assert((objcPointer.pointee != nsobjcPointer.pointee), "NSObject's instace has not refCount")
}

private func getSileTablePointer<T: AnyObject>(_ objc: T) -> UnsafeMutableRawPointer? {
    assertNotNSObject(objc)
    assert(hasWeakRefCount(objc))
    
    let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
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
