//
//  main.swift
//  SwiftPointerDemo
//
//  Created by jintao on 2019/7/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

// MARK: ---------------------------------- Bool ----------------------------------
var bool = true
print("Bool =>:", bool)
bool.valuePointer.initialize(to: -10)  // bool = false
print("Bool.value =>", bool)


// MARK: ---------------------------------- String ----------------------------------
var str1 = "Tanner Jin"
print("\nString =>:", str1)
print("String.address =>", str1.valuePointer!)

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
