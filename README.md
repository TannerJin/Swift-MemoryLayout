# Swift MemoryLayout

**swift version =>: swift 5.0**

- [Swift](#Swift)
  - [Struct](#Struct)
  - [Tuple](#Tuple)
  - [Class](#Class)
  - [Protocol](#Protocol)
  - [Enum](#Enum)
- [SwiftCore](#SwiftCore)  
  - [Bool](#Bool)
  - [Optional](#Optional)
  - [String](#String)
  - [Character](#Character)
  - [Array](#Array)
  - [Set](#Set)
  - [Dictionary](#Dictionary)
  
  
## Swift

### [Struct](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/Swift/Struct.swift)

```swift
struct StructValue {
    let a: Int8 = 4
    let b: Int16 = 6
    let c: Int32 = 8
}

var structValue = StructValue()
let structValuePointer = withUnsafePointer(to: &structValue) { UnsafeMutableRawPointer(mutating: $0) }
structValuePointer.advanced(by: 2).assumingMemoryBound(to: Int16.self).initialize(to: 99)

// structValue.b = 99
```

### [Tuple](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/Swift/Tuple.swift)

```swift
typealias TupleValue = (Int8, Int32, String)

struct StructValue {
    var a: Int8 = 4
    var b: Int32 = 5
    var c: String = "SwiftTuple"
}

let structValue = StructValue()
let tupleValue = unsafeBitCast(structValue, to: TupleValue.self)
print(tupleValue.1)

// print 5    (structValue.b)

// if TupleValue = (Int8, Int8, String) =>  MemoryLayout of TupleValue !=  MemoryLayout of StructValue
```

### [Class](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/Swift/Class.swift)   

```swift
class A {
    var a = 666
}

let a1 = A()
unowned let unowned_a = a1
let a2 = a1

weak var weak_a = a1
weak var weak_a2 = a1

unowned let unowned_a2 = a1

let a3 = a2
let a4 = a2
weak var weak_a3 = a1
unowned let unowned_a3 = a1

print(UnownedRefCount(a1))
print(WeakRefCount(a1)!)
print(StrongRefCount(a2))
```

### [Protocol](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/Swift/Protocol.swift)

```swift
protocol SwiftProtocol {
    func foo()
    func foo2()
}

struct StructValue: SwiftProtocol {
    func foo() {
        print("foo")
    }
    
    func foo2() {
        print("foo2")
    }
}

var Protocol: SwiftProtocol = StructValue()
let protocol_pointer = withUnsafePointer(to: &Protocol) { UnsafeMutableRawPointer(mutating: $0) }

let witness_table_pointer_value = protocol_pointer.advanced(by: 32).assumingMemoryBound(to: UInt.self).pointee
let witness_table_pointer = UnsafeMutablePointer<UnsafeMutableRawPointer>.init(bitPattern: witness_table_pointer_value)

typealias Foo2Method = @convention(thin) ()->Void    // really method => (StructValue) -> ()

let witness_foo2_pointer = unsafeBitCast(witness_table_pointer!.advanced(by: 2).pointee, to: Foo2Method.self)
witness_foo2_pointer()

// print foo2
```

### [Enum](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/Swift/Enum.swift)   

```swift
enum EnumValue {
    case a
    case b(String)
    case c(Int32)
    case d
    case f(Int64)
    case e
}

var enumC = EnumValue.c(8)
let enumCPointer = withUnsafePointer(to: &enumC) { UnsafeMutableRawPointer(mutating: $0) }
enumCPointer.advanced(by: 16).assumingMemoryBound(to: Int8.self).initialize(to: 0x02)

// enumC = EnumValue.f(8)
```


## SwiftCore

### [Bool](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/Bool.swift)

```swift
var bool = true
let boolPointer = bool.valuePointer
boolPointer.initialize(to: -10)

// bool = false 
```

### [Optional](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/Optional.swift)

```swift
var optional: Int16?
var optionalPointer = optional.valuePointer
optionalPointer.assumingMemoryBound(to: Int16.self).initialize(to: 99)
// optionalPointer.advanced(by: MemoryLayout<Int16>.size).assumingMemoryBound(to: UInt8.self).initialize(to: 0x00)

// optional = 99
```

### [String](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/String.swift)

```swift
var string = "TannerJin"
let stringPointer = string.valuePointer
stringPointer.assumingMemoryBound(to: Int8.self).initialize(to: 0x40)      // 0x40 => "@"

// string = "@anner Jin"    
```

### [Character](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/Character.swift)

```swift
var character = Character("😂")
let characterPointer = character.valuePointer.assumingMemoryBound(to: UInt8.self)
characterPointer.initialize(to: 0xf0)                             // f0 9f 9a 80 => "🚀"  unicode(utf-8)
characterPointer.advanced(by: 1).initialize(to: 0x9f)
characterPointer.advanced(by: 2).initialize(to: 0x9a)
characterPointer.advanced(by: 3).initialize(to: 0x80)

// character = "🚀"
```

### [Array](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/Array.swift)

```swift
let array = ["Apple", "Swift"]
let arrayPointer = array.valuePointer
arrayPointer.initialize(to: "Tanner")

// array = ["Tanner", "Swift"]

array.countPointer.initialize(to: 3)

// array.count = 3
```

### [Set](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/Set.swift)

 ```swift
 let set: Set<String> = ["Apple", "iOS", "Swift"]
 set.valuesPointer.initialize(to: "Tanner")
 
 // set =  ["Tanner", "Swift", "iOS"] ||  ["Tanner", "Swift", "Apple"] || ...
 
 set.countPointer.initialize(to: 2)
 
 // set.count = 2
 ```

### [Dictionary](https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/Dictionary.swift)

```swift
let dictionary = ["Swift": 5.0, "iOS": 2019]

let dicCountPointer = dictionary.countPointer
let dicKeysPointer = dictionary.keysPointer
let dicValuesPointer = dictionary.valuesPointer
```
