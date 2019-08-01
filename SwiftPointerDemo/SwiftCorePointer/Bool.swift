//
//  Bool.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/1.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension Bool {
//    struct Bool
//    +-----------------------------------------------------------------------+
//    |   var _value: Int8               1: true ; others: false              |
//    +-----------------------------------------------------------------------+
    
    var valuePointer: UnsafeMutablePointer<Int8> {
        mutating get {
            return withUnsafePointer(to: &self) { (pointer) -> UnsafeMutablePointer<Int8> in
                UnsafeMutablePointer<Int8>(OpaquePointer(pointer))
            }
        }
    }
}
