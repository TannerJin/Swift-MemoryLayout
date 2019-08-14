//
//  Protocol.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/6.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

//    protocol
//    +-----------------------------------------------------------------------+
//    |   var payload_data_0                                          8 bytes | --
//    |   var payload_data_1                                          8 bytes |    payload_data => 24 bytes store instance_type's data
//    |   var payload_data_2                                          8 bytes | --        |
//    |   ---------------------------------------------------                 |           |
//    |   var instance_type: Any.Type                                 8 bytes |           |
//    |   var witness_table_protocol: UnsafeMutableRawPointer         8 bytes |           |
//    +--------------|--------------------------------------------------------+           |
//                   |                                                                    |
//                   V                                                                    V
//    witness_table
//    +----------------------------------------+                              if instance_type.size <= 24 {
//    |  data: pointer                         |                                 payload_data = instance
//    |  protocol_method_0: void*              |                              } else {
//    |  protocol_method_1: void*              |                                 payload_data = instance*
//    |  protocol_method_2: void*              |                              }
//    |  .                                     |
//    |  .                                     |
//    +----------------------------------------+
//                   ∧
//                   |_____________________________________________________________
//                                                                                 |
//                                                                                 |
//    protocol: class                                                              |
//    +-----------------------------------------------------------------------+    |
//    |  var instance: UnsafeMutableRawPointer                                |    |
//    |  var witness_table_protocol: UnsafeMutableRawPointer                  |    |
//    +-------------|---------------------------------------------------------+    |
//                  |                                                              |
//                  |______________________________________________________________|
