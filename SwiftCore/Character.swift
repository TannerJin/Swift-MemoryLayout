//
//  Character.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/1.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension Character {
//    struct Character
//    +-----------------------------------------------------------------------+
//    |   var _str: String                                        unicode     |
//    +-----------------------------------------------------------------------+
    
//              UTF-8  => use 1 ~ 4 bytes        (first byte compatible ASCII, 0x00...0x7F)
//           /
//    unicode - UTF-16 => use 1 ~ 2 bytes        (can't compatible ASCII)
//           \
//              UTF-32 => use 1 bytes
    
    var valuePointer: UnsafeMutableRawPointer {
        mutating get {
            // unicode.bytes.count <= 15
            return withUnsafePointer(to: &self) { (pointer) -> UnsafeMutableRawPointer in
                UnsafeMutableRawPointer(OpaquePointer(pointer))
            }
        }
    }
}
