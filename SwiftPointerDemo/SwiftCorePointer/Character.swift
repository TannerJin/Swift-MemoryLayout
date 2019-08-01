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
    
//            UTF-8 => 1 ~ 6 bytes        (first byte compatible ASCII, 00-7F)
//          /
//    unicode
//          \ UTF-16 => 1 ~ 6 bytes       (can't compatible ASCII)
    
    var valuePointer: UnsafeMutableRawPointer {
        mutating get {
            // unicode.bytes.count <= 15
            return withUnsafePointer(to: &self) { (pointer) -> UnsafeMutableRawPointer in
                UnsafeMutableRawPointer(OpaquePointer(pointer))
            }
        }
    }
}
