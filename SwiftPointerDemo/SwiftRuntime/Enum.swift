//
//  Enum.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/8/6.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

// enum EnumValue {           => 1 byte
//     case a      0x00
//     case b      0x01
//     case c      0x02
//     case d      0x03
// }


// enum EnumValue: String {   => 1 byte
//     case a = "a"        0x00
//     case b              0x01
//     case c              0x02
//     case d = "d"        0x03
// }


// enum EnumValue {           => 17 bytes(ingore memory align)
//     case a                    enum's size + max association's type of enum = 1 + 16(String)
//     case b(String)
//     case c(Int32)
//     case d
//     case f(Int64)
//     case e
// }
//       |
//       |
//       V
// +----------------------------------------+ --
// |    case a                    00  count |   \
// |    case d                    01  count |    offset(1 byte) + all association's enum count
// |    case e                    02  count |   /
// |                                        |
// |    case b(String)           string  00 |   \
// |    case c(Int32)             Int32  01 |    association's value(16 bytes) + offset(1 byte)
// |    case f(Int64)             Int64  02 |   /
// +----------------------------------------+ --
