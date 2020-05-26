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
//                                                                                               |
//                                                                                               |
//                      +------------------------------------------------------------------------+
//                      |
//                      V
//    InlineRefCountBits (64 bits)                                 
//    0000000000000000000000000000000000000000000000000000000000000000
//    ||                            |||                             ||
//    | \         30 bits          / | \          31 bits          / |
//    |  \   StrongExtraRefCount  /  |  \     UnownedRefCount     /  |
//    |   \______________________/   |   \_______________________/   |
//    |                              |                               |
//    V                              V                               V
//   UseSlow(1 bit)            IsDeiniting(1 bit)                IsImmortal(1 bit)
//                                                               (is Static Object 单例)
//    ∧                                                              ∧
//    |                                                              |
//    | HeapObjectSideTableEntry* (64 bits)                          |
//    0000000000000000000000000000000000000000000000000000000000000000
//     ||                                                            |
//     | \                      62 bits                             /
//     |  \              HeapObjectSideTableEntry*                 /
//     |   \______________________________________________________/
//     |
//     V
//   SideTableMark(1 bit)

/*   HeapObject:
     
     if (StrongExtraRefCount or UnownedRefCount is overFlow) or hasWeakRef {
        Use HeapObjectSideTable
     }
     
     struct HeapObjectSideTable {
        let object: UnsafeMutableRawPointer
        let bits: (UInt64, Int64)   // include StrongExtraRefCount and UnownedRefCount
        let weakBits: UInt32
     }
 
     each weak variable will pointe to the same HeapObjectSideTable of the headObject, so *weak_variable = (heapObject*)objc
 
     for example:
        class A {
        }
        let a = A()
        weak var a2 = a    // a2 is pointe to HeapObjectSideTable of a. so, (*a2) = (objc*)object
 */


//    class: NSObject
//    +-----------------------------------------------------------------------+
//    |   var isa: objc_class*                                             -------------+
//    |-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -                      |         |
//    |   var property0: String                                               |         |
//    |   var property1: [Int]                                                |         |
//    |   .                                                                   |         |
//    |   .                                                                   |         |
//    |   .                                                                   |         |
//    +-----------------------------------------------------------------------+         |
//                                                                                      |
//                                                                                      |
//                      +---------------------------------------------------------------+
//                      |
//                      V
//    isa (64 bits)
//    0000000000000000000000000000000000000000000000000000000000000000
//    |      |||||    ||                                          ||||
//    |      |||||    ||                                          ||||
//    |      |||||    ||                                          ||||
//     \    / ||| \  /  \                                        / |||
//    extra_rc||| magic            objc_class*                     |||
//            V||                                                  V||
//   side_table||                                       has_cxx_dtor||
//             ||                                                   ||
//             V|                                                   V|
//  deallocating|                                           has_assoc|
//              |                                                    |
//              V                                                    V
// weakly_referenced                                        nonpointer

/*  NSObject:
 
    if extra_rc > 0xff || objc has weak ref {                                     <--------------+
        use SideTable and set side_table bit = 1                                                 |
    }                                                                                            |
                                                                                                 |
    static GlobalSideTables = Dictionary<objc, SideTable>.init(bucketCount: 8)  // iOS           |
                                                                                                 |
    strct SideTable {                                                                            |
        var lock: spinlock_t                                                                     |
                                                                                                 |
        /*  Int: 0 bit     => objc has weak ref      --------------------------------------------+
            Int: 1 bit     => objc isDeallocating
            Int: 2~62 bits => count of extra_rc
            Int: 63 bit    => ???
        */
        var refcnts: Dictionary<objc, Int>
        var weak_table: Dictionary<objc, weak_entry>
    }
 
    struct weak_entry {
        var _objc: NSObject
 
        /* if weak_variables.count > 4
           weak_variables[0] become pointer and pointe to [&objc]
           weak_variables[1] = count of weak_variables
        */
        var weak_variables: [&objc].init(count: 4)
    }
 
    
 Refcnt:
    GlobalSideTables[objc].refcnts[objc]
 
 WeakEntry:
    GlobalSideTables[objc].weak_table[objc]
 */


// MARK: - Swift Class
/* unsafeBitCast is inlinable. enter unsafeBitCast, objc will retain 1. finish unsafeBitCast, objc will release 1.
   yout can use at debug, but not use at release
 */

public func StrongRefCount<T: AnyObject>(_ objc: T) -> UInt32 {
    assertNotNSObject(objc)
    
    func getStrongRefCount(bitsValue: UInt64) -> UInt32 {
        var mask: UInt64 = 1 << 30 - 1                    // 30 bits => 111...111
        mask <<= 33                                       // 63 bits => 111...111000...000
        return UInt32((bitsValue & mask) >> 33) + 1       // The strong RC is stored as an extra count, so +1
    }
    
    if hasWeakRefCount(objc) {
        let bitsValue = getSileTablePointer(objc)?.pointee.bits.1
        return getStrongRefCount(bitsValue: UInt64(bitsValue!))
    } else {
        let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
        let bitsValue = objcPointer.advanced(by: 1).pointee
        return getStrongRefCount(bitsValue: bitsValue)
    }
}

public func UnownedRefCount<T: AnyObject>(_ objc: T) -> UInt32 {
    assertNotNSObject(objc)

    func getUnownedRefCount(bitsValue: UInt64) -> UInt32 {
        var mask: UInt64 = 1 << 31 - 1                    // 31 bits => 111...111
        mask <<= 1                                        // 32 bits => 111...110
        return UInt32((bitsValue & mask) >> 1) - 1        // The unowned RC also has an extra +1 on behalf of the strong references; this +1 is decremented after deinit completes(Apple)
    }
    
    if hasWeakRefCount(objc) {
        let bitsValue = getSileTablePointer(objc)?.pointee.bits.1
        return getUnownedRefCount(bitsValue: UInt64(bitsValue!))
    } else {
        let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
        let bitsValue = objcPointer.advanced(by: 1).pointee
        return getUnownedRefCount(bitsValue: bitsValue)
    }
}

// nil: has not weak reference
public func WeakRefCount<T: AnyObject>(_ objc: T) -> UInt32? {
    assertNotNSObject(objc)
    
    if hasWeakRefCount(objc), let sileTable = getSileTablePointer(objc)  {
        return sileTable.pointee.weakBits - 1          // The weak RC also has an extra +1, this +1 is decremented after the object's allocation is freed(Apple)
    }
    
    return nil
}


// MARK: - Helper

// useSlowValue && !isImmortalValue
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

private func assertNotNSObject<T: AnyObject>(_ objc: T) {  // where T != NSObject
    assert(!(objc is NSObject), "NSObject's instace has not refCount property, look up it at runtime.objc")
}

private func getSileTablePointer<T: AnyObject>(_ objc: T) -> UnsafeMutablePointer<HeapObjectSideTableEntry>? {
    assertNotNSObject(objc)
    assert(hasWeakRefCount(objc))
    
    let objcPointer = unsafeBitCast(objc, to: UnsafeMutablePointer<UInt64>.self)
    let bitsValue = objcPointer.advanced(by: 1).pointee
    let mask: UInt64 = 1 << 62 - 1                  // 62 bits => 111...111
    let slieTableValue = bitsValue & mask
    return UnsafeMutableRawPointer(bitPattern: UInt(slieTableValue << 3))?.assumingMemoryBound(to: HeapObjectSideTableEntry.self)
}

private struct HeapObjectSideTableEntry {
    let object: UnsafeMutableRawPointer
    let bits: (UInt64, Int64)
    let weakBits: UInt32
}
