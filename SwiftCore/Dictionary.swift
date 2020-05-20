//
//  Dictionary.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/7/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension Dictionary {
//    struct Dictionary<K,V>
//   +------------------------------------------------+
//   | enum Dictionary<K,V>._Variant                  |
//   | +--------------------------------------------+ |
//   | | [struct _NativeDictionary<K,V>             | |
//   | +---|----------------------------------------+ |
//   +----/-------------------------------------------+
//       /
//      |
//      V
//    class __RawDictionaryStorage
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
//    |   var _rawKeys: UnsafeMutableRawPointer       // 48 byte offset      -----------------------+
//    |   var _rawValues: UnsafeMutableRawPointer     // 56 byte offset      -----------------------+---------------+
//    |   var _bucketCount: Int                                               |                     |               |
//    |   var _metadata(get): UnsafeMutablePointer<_HashTable.Word>          -----------------+     |               |
//    |   var _hashTable(get): _HashTable                                     |               |     |               |
//    +-----------------------------------------------------------------------+               |     |               |
//                                                                                            |     |               |
//                                                                                            |     |               |
//                                                                                            |     |               |
/*    Dictionary                                                                              |     |               |
          |                                                                                   |     |               |
          V                                                                                   |     |               |
      +-------------------------------------+                                                 |     |               |
      |    RawDictionaryStorage (MetaData)  |                                                 |     |               |
      |                                     |                                                 |     |               |
      +-------------------------------------+  <----------------------------------------------+     |               |
      |         Word (Hash Offset)          |                                                       |               |
      |                                     |                                                       |               |
      +-------------------------------------+  <----------------------------------------------------+               |
      |         Keys                        |                                                                       |
      |                                     |                                                                       |
      +-------------------------------------+  <--------------------------------------------------------------------+
      |         Values                      |
      |                                     |
      +-------------------------------------+
     
      Word (Hash Offset)
      |
      V                     64(32) bits
                     /                     \
      if Word[0] = 0b1000000...0000000000100   =>  Keys[2] != nil and Keys[63] != nil
      if Word[1] = 0b1000000...0000000000101   =>  Keys[64] != nil and Keys[66] != nil and ...
     
insert:  if hash(NewKey) = 2(bitOffset), but hash offset is occupied(bit is 1) {
            repeat {
                bitOffset += 1
            }  when hash offset is not occupied(bit is 0)
     
            Word[0] = 0b1000000...0000000001100
            Keys[bitOffset] = NewKey
            Values[bitOffset] = NewValue
         }
        
     
get:    if hash(Key) = 2(bitOffset) {
            when Keys[bitOffset] != Key {
                 bitOffset += 1
            }
            return Values[bitOffset]
        }
 */
    
    
    
    // count value of address
    var countPointer: UnsafeMutablePointer<Int> {
        get {
            return unsafeBitCast(self, to: UnsafeMutableRawPointer.self).advanced(by: 16).assumingMemoryBound(to: Int.self)
        }
    }
    
    // array of keys address
    var keysPointer: UnsafeMutablePointer<Key> {
        get {
            let keysAddrValue = unsafeBitCast(self, to: UnsafeMutableRawPointer.self).advanced(by: 48).assumingMemoryBound(to: Int.self).pointee
            return UnsafeMutableRawPointer(bitPattern: keysAddrValue)!.assumingMemoryBound(to: Key.self)
        }
    }
    
    // array of values address
    var valuesPointer: UnsafeMutablePointer<Value> {
        get {
            let valuesAddrValue = unsafeBitCast(self, to: UnsafeMutableRawPointer.self).advanced(by: 56).assumingMemoryBound(to: Int.self).pointee
            return UnsafeMutableRawPointer(bitPattern: valuesAddrValue)!.assumingMemoryBound(to: Value.self)
        }
    }
}
