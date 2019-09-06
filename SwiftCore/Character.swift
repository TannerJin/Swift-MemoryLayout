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
    
//              UTF-8  => use 1 ~ 4 bytes        (one can byte compatible ASCII, 0x00...0x7F)
//           /
//    unicode - UTF-16 => use 2/4 bytes  
//           \
//              UTF-32 => use 4 bytes
    
    var valuePointer: UnsafeMutableRawPointer {
        mutating get {
            // unicode.bytes.count <= 15
            return withUnsafePointer(to: &self) { UnsafeMutableRawPointer(mutating: $0) }
        }
    }
}
