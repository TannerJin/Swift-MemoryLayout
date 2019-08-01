# SwiftCorePointer
swiftCorePointer based on swiftCore memoryLayout

**swift version =>: swift 5.0**

### [Bool]()

```swift
var bool = true
let boolPointer = bool.valuePointer
boolPointer.initialize(to: 0)

// bool = false 
```

### [Optional]()

```swift
var optional: Int16?
var optionalPointer = optional.valuePointer
optionalPointer.assumingMemoryBound(to: Int16.self).initialize(to: 99)

// optional = 99
```

### [String]()

```swift
var string = "TannerJin"
let stringPointer = string.valuePointer
stringPointer.assumingMemoryBound(to: Int8.self).initialize(to: 0x40)      // 0x40 => "@"

// string = "@anner Jin"    
```

### [Character]()

```swift
var character = Character("😂")
let characterPointer = character.valuePointer.assumingMemoryBound(to: UInt8.self)
characterPointer.initialize(to: 0xf0)                             // f0 9f 9a 80 => "🚀"
characterPointer.advanced(by: 1).initialize(to: 0x9f)
characterPointer.advanced(by: 2).initialize(to: 0x9a)
characterPointer.advanced(by: 3).initialize(to: 0x80)

// character = "🚀"
```

### [Array]()

```swift
let array = ["Apple", "Swift"]
let arrayPointer = array.valuePointer
array.initialize(to: "Tanner")

// array = ["Tanner", "Swift"]

array.countPointer.initialize(to: 3)

// array.count = 3
```

### [Set]()

 ```swift
 let set: Set<String> = ["Apple", "iOS", "Swift"]
 set.valuesPointer.initialize(to: "Tanner")
 
 // set =  ["Tanner", "Swift", "iOS"] ||  ["Tanner", "Swift", "Apple"] || ...
 
 set.countPointer.initialize(to: 2)
 
 // set.count = 2
 ```

### [Dictionary]()

```swift
let dictionary = ["Swift": 5.0, "iOS": 2019]

let dicCountPointer = dictionary.countPointer
let dicKeysPointer = dictionary.keysPointer
let dicValuesPointer = dictionary.valuesPointer
```
