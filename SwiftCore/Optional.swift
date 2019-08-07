//
//  Optional.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/1.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension Optional {
//    enum Optional
//    +-----------------------------------------------------------------------+
//    |   case none                                                           |
//    |   case some(Wrapped)                                                  |
//    +-----------------------------------------------------------------------+
    
//    Optional<Wrapped>.bytes count => 1 + Wrapped.bytes count
    
//    Int8? = nil :  Optional.none => 00 01        00 => self at all not associated enum's value  ;  01 => all associated enum count
//    Int8? = 4   :  Optional.some => 04 00        04 => associated value                         ;  00 => self at all associated enum's value
    
    var valuePointer: UnsafeMutableRawPointer {
        mutating get {
            return withUnsafePointer(to: &self) { (pointer) -> UnsafeMutableRawPointer in
                UnsafeMutableRawPointer(OpaquePointer(pointer))
            }
        }
    }
}
