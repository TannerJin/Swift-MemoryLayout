//
//  Struct.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/7.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

//    struct StructValue {            (for memory alignment)
//       let a: Int8 = 4               |
//       let b: Int16 = 6     ==>   04 00 06 00 08 00 00 00
//       let c: Int32 = 8           |      \ /   \       /
//    }                             a       b        c


// FYI: if you want to get the offset of each property at runtime, you can see https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst
