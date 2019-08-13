//
//  Array.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/7/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension Array {
//   struct Array<Element>
//   +--------------------------------------------------------------------+
//   | struct _ArrayBuffer<Element> (_ContiguousArrayBuffer<Element>)     |
//   +----/----------------------------------------|----------------------+
//       /                                        /
//      |(objc)                                  |(nonobjc)
//      V                                        V
//    class __ContiguousArrayStorageBase (_ContiguousArrayStorage)
//    +-----------------------------------------------------------------------+
//    |   var isa: UnsafeMutableRawPointer                                    |
//    |   var refcount: Int                                                   |
//    |   var countAndCapacity: _ArrayBody                                    |
//    +------------------------------|----------------------------------------+
//                                  /
//                                 |
//                                 V
//    struct _ArrayBody
//    +-----------------------------------------------------------------------+
//    |   struct _SwiftArrayBodyStorage                                       |
//    |   +--------------------------------------------------------------+    |
//    |   |   var count: Int                        // 16 bytes offset   |    |
//    |   |   var _capacityAndFlags: Int                                 |    |
//    |   |   var sequence: [Element]               // 32 bytes offset   |    |
//    |   +--------------------------------------------------------------+    |
//    +-----------------------------------------------------------------------+
    
    // count address
    var countPointer: UnsafeMutablePointer<Int> {
        get {
            let pointer = unsafeBitCast(self, to: UnsafeMutableRawPointer.self).advanced(by: 16)
            return pointer.assumingMemoryBound(to: Int.self)
        }
    }

    // sequence address
    var valuePointer: UnsafeMutablePointer<Element> {
        get {
            let pointer = unsafeBitCast(self, to: UnsafeMutableRawPointer.self).advanced(by: 32)
            return pointer.assumingMemoryBound(to: Element.self)
        }
    }
}
