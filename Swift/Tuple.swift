//
//  Tuple.swift
//  SwiftDemo
//
//  Created by jintao on 2019/8/13.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

//    typealias TupleValue = (Int8, Int16, Int32)
//           ∧                                  \
//           |                                   \
//           | same layout                        |
//           |                                    |
//           V                                    V
//
//    struct StructValue {                     04 00 06 00 08 00 00 00
//       let a: Int8 = 4                       |  |   \ /   \       /
//       let b: Int16 = 6        ----->        a  |    b        c
//       let c: Int32 = 8                         V
//    }                                        (for memory alignment)
