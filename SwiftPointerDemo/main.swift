//
//  main.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/7/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

print("Hello, Swift\n")

// MARK: ---------------------------------- Struct ----------------------------------
struct StructValue {
    let a: Int8 = 4
    let b: Int16 = 6
    let c: Int32 = 8
}

var structValue = StructValue()
let structValuePointer = withUnsafePointer(to: &structValue) { (pointer) -> UnsafeMutableRawPointer in
    UnsafeMutableRawPointer(OpaquePointer(pointer))
}
structValuePointer.advanced(by: 2).assumingMemoryBound(to: Int16.self).initialize(to: 99)
print("Struct =>:", structValue.b)


// MARK: ---------------------------------- Enum ----------------------------------
enum EnumValue {
    case a
    case b(String)
    case c(Int32)
    case d
    case f(Int64)
    case e
}

var enumC = EnumValue.c(8)
print("\nEnum =>:", enumC)
let enumPointer = withUnsafePointer(to: &enumC) { (pointer) -> UnsafeMutableRawPointer in
    UnsafeMutableRawPointer(OpaquePointer(pointer))
}
enumPointer.advanced(by: 16).assumingMemoryBound(to: Int8.self).initialize(to: 0x02)
print("Enum =>:", enumC)


// MARK: ---------------------------------- Class ----------------------------------

class A {
    var a: Int = 9
}

let a1 = A()
let a2 = a1
let a3 = a2
print("\nClass =>")

print("a strong references count =>:", StrongRefCount(a1))

unowned let unowned_a = a1
print("a unowned references count =>:", UnownedRefCount(a1))

print("a has weak references =>:", hasWeakRefCount(a1))
weak var weak_a1 = unowned_a
print("a has weak references =>:", hasWeakRefCount(a1))


// ------------------------------------------------------------------------------------------------------


// MARK: ---------------------------------- Bool ----------------------------------
var bool = true
print("\nBool =>:", bool)
print("Bool.value =>:", bool.valuePointer.pointee)


// MARK: ---------------------------------- String ----------------------------------
var str1 = "Tanner Jin"
print("\nString =>:", str1)
print("String.address =>:", str1.valuePointer!)

var str2 = "124fjieji329110*(*9289fjo"
print("\nString =>:", str2)
print("String.address =>:", str2.valuePointer!)


// MARK: ---------------------------------- Character ----------------------------------
var character = Character("😂")

print("\nCharacter =>:", character)
print("Character.address =>:", character.valuePointer)


// MARK: ---------------------------------- Array ----------------------------------
let arr = ["Swift", "Array"]            // notice: let

print("\nArray =>:", arr)

arr.valuePointer.advanced(by: 1).initialize(to: "Apple")
print("Array.value =>:", arr)

arr.countPointer.initialize(to: 3)
print("Array.count =>:", arr.count)


// MARK: ---------------------------------- Dictionary ----------------------------------
let dic = ["Swift": 3, "Dictionary": 2]

print("\nDictionary =>:", dic)
print("Dictionary.count =>:", dic.countPointer.pointee)
print("Dictionary.keys.address =>:", dic.keysPointer)
print("Dictionary.values.address =>:", dic.valuesPointer)


// MARK: ---------------------------------- Optional ----------------------------------
var optional: Int8?
let optionalPointer = optional.valuePointer
optional = 99

print("\nOptional =>:", optional as Any)
print("Optional.value =>:", optionalPointer.assumingMemoryBound(to: Int8.self).pointee)


// MARK: ---------------------------------- Set ----------------------------------
let set: Set<String> = ["iOS", "Apple", "Swift"]
print("\nSet =>:", set)
print("Set.value.count =>:", set.countPointer.pointee)
print("Set.value.address =>:", set.valuesPointer)
