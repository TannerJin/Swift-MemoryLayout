# SwiftCorePointer
swiftCorePointer based on swiftCore memoryLayout

**swift version =>: swift 5.0**

## Swift

### [Class](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftRuntime/Class.swift)   

```swift
class A {
  var a = 666
}
let objcA = A()
unowned let unowned_objcA = objcA
let objcAPointer = unsafeBitCast(a1, to: UnsafeMutablePointer<UInt64>.self)

let strongRefCount = StrongRefCount(objcAPointer)
let unownedRefCount = UnownedRefCount(objcAPointer)
let hasWeakRef = hasWeakRefCount(objcAPointer)
```

## SwiftCore

### [Bool](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftCorePointer/Bool.swift)

```swift
var bool = true
let boolPointer = bool.valuePointer
boolPointer.initialize(to: 0)

// bool = false 
```

### [Optional](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftCorePointer/Optional.swift)

```swift
var optional: Int16?
var optionalPointer = optional.valuePointer
optionalPointer.assumingMemoryBound(to: Int16.self).initialize(to: 99)

// optional = 99
```

### [String](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftCorePointer/String.swift)

```swift
var string = "TannerJin"
let stringPointer = string.valuePointer
stringPointer.assumingMemoryBound(to: Int8.self).initialize(to: 0x40)      // 0x40 => "@"

// string = "@anner Jin"    
```

### [Character](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftCorePointer/Character.swift)

```swift
var character = Character("😂")
let characterPointer = character.valuePointer.assumingMemoryBound(to: UInt8.self)
characterPointer.initialize(to: 0xf0)                             // f0 9f 9a 80 => "🚀"  unicode(utf-8)
characterPointer.advanced(by: 1).initialize(to: 0x9f)
characterPointer.advanced(by: 2).initialize(to: 0x9a)
characterPointer.advanced(by: 3).initialize(to: 0x80)

// character = "🚀"
```

### [Array](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftCorePointer/Array.swift)

```swift
let array = ["Apple", "Swift"]
let arrayPointer = array.valuePointer
arrayPointer.initialize(to: "Tanner")

// array = ["Tanner", "Swift"]

array.countPointer.initialize(to: 3)

// array.count = 3
```

### [Set](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftCorePointer/Set.swift)

 ```swift
 let set: Set<String> = ["Apple", "iOS", "Swift"]
 set.valuesPointer.initialize(to: "Tanner")
 
 // set =  ["Tanner", "Swift", "iOS"] ||  ["Tanner", "Swift", "Apple"] || ...
 
 set.countPointer.initialize(to: 2)
 
 // set.count = 2
 ```

### [Dictionary](https://github.com/TannerJin/SwiftCorePointer/blob/master/SwiftPointerDemo/SwiftCorePointer/Dictionary.swift)

```swift
let dictionary = ["Swift": 5.0, "iOS": 2019]

let dicCountPointer = dictionary.countPointer
let dicKeysPointer = dictionary.keysPointer
let dicValuesPointer = dictionary.valuesPointer
```
