//
//  Set.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/1.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension Set {
//    struct Set<Element>   Element: Hashable
//   +------------------------------------------------+
//   |   struct Set<Element>._Variant                 |
//   |   +------------------------------------------+ |
//   |   |  var objc: __RawSetStorage               | |
//   |   +--------------|---------------------------+ |
//   +-----------------/------------------------------+
//                    |
//                    V
//    class __RawSetStorage
//    +-----------------------------------------------------------------------+
//    |   var isa: UnsafeMutableRawPointer                                    |
//    |   var refcount: Int                                                   |
//    |   var _count: Int                             // 16 byte offset       |
//    |   var _capacity: Int                                                  |
//    |   var _scale: Int8                                                    |
//    |   var _reservedScale: Int8                                            |
//    |   var _extra: Int16                                                   |
//    |   var _age: Int32                                                     |
//    |   var _seed: Int                                                      |
//    |   var _rawElements: UnsafeMutableRawPointer   // 48 byte offset       |
//    |   var _bucketCount: Int                                               |
//    |   var _metadata: UnsafeMutablePointer<_HashTable.Word>                |
//    |   var _hashTable: _HashTable                                          |
//    +-----------------------------------------------------------------------+
    
    // count value of address
    var countPointer: UnsafeMutablePointer<Int> {
        get {
            return unsafeBitCast(self, to: UnsafeMutableRawPointer.self).advanced(by: 16).assumingMemoryBound(to: Int.self)
        }
    }
    
    // array of values address
    var valuesPointer: UnsafeMutablePointer<Element> {
        get {
            let valuesAddrValue = unsafeBitCast(self, to: UnsafeMutableRawPointer.self).advanced(by: 48).assumingMemoryBound(to: Int.self).pointee
            return UnsafeMutableRawPointer(bitPattern: valuesAddrValue)!.assumingMemoryBound(to: Element.self)
        }
    }
}
