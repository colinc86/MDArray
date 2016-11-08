![MDArray](https://github.com/colinc86/MDArray/blob/master/Web%20Assets/Title.png?raw=true)
-------------------------------------------

`MDArray` is a multidimensional array type for Swift, and uses the Swift 3.0 syntax. You can use it to store vectors, matrices, and other higher order objects. Its computational functions use the `Accelerate` framework and support the `Int32`, `Float`, and `Double` types.

### Why use it?
You can use `MDArray` to store any type in the form of a multidimensional array, such as `String` values in the title banner above. Some of the more interesting applications include machine learning, signal processing, physics, engineering, and just good ol' mathematics.

### Adding it to your project
The `MDArray` type and associated functions are broken up in to separate files. Depending on how you'll be using `MDArray`, you may only need one or two of them. Clone the repository using your terminal of choice and add the appropriate files to your project.
```
https://github.com/colinc86/MDArray.git
```

[`MDArray.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDArray.swift) **(required)** contains the main `MDArray` type declaration. If you only need `MDArray`'s storage handling and organization, then you can get away with only including this file in your project.

[`MDExtensions.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDExtensions.swift) **(optional)** adds computational functions to the `MDArray` type such as calculating determinants and determining symmetry.

[`MDMath.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDMath.swift) **(optional)** contains binary/unary operators and is the file responsible for utilizing the `Accelerate` framework to accomplish mathematical computations between `MDArray`s.

### Contributing
There is still work to be done! Please feel free to contribute to any of the following areas.

- Complex number support (`MDMath` should handle `DSPSplitComplex` and `DSPDoubleSplitComplex` vDSP functions)
- Row reductions
- Multidimensional array inverse, cross product, and dot product.

## MDArray
### Creating a `MDArray`
The default `MDArray` constructor creates an empty multidimensional array. I.e. a multidimensional array with empty storage and shape.
```swift
let A = MDArray<String>()
```
Each `MDArray` has a `shape` property that can either be set on initialization, or at a later point in time. The following creates a multidimensional array with shape `(1, 3, 2, 1)` and repeating value `""`. Ie. a 4-Dimensional array with dimensions `1`, `3`, `2` and `1`, and `1 * 3 * 2 * 1 = 6` elements with value `""`.
```swift
let B = MDArray<String>(shape: [1, 3, 2, 1], repeating: "")
```
It is also possible to initialize a `MDArray` by passing an array of storage values.
```swift
// Creates the multidimensional array in the title banner.
let C = MDArray<String>(shape: [1, 3, 2, 1], storage: ["A", "type", "multidimensional", "for", "array", "Swift"])
```
**Note:** *The constructor `MDArray<T>(shape: Array<Int>, storage: Array<T>)` generally requires that `shape` be equal to the shape of the multidimensional array who owns `storage`.*

### Getting/Setting Elements
`MDArray` conforms to the `MutableCollection` protocol, and therefor supports subscripting.

To get or set an element of a multidimensional array:
```swift
var D = MDArray<Float>(shape: [2, 3, 2], repeating: 0.0)
D[1, 1, 0] = 2.0
D[0, 2, 1] = F[1, 1, 0]
```
If you are unsure if an index is a valid index in the multidimensional array, you can use the `validate(index:)` function before attempting to retrieve an element.

Getting a row, column, or any sub-multidimensional array is just as easy:
```swift
// Get the column that spans the elements from [0, 0, 0] to [1, 0, 0]
let columnRange = [0, 0, 0] ... [1, 0, 0]
let column = D[columnRange]

// Get the row that spans the elements from [0, 0, 0] to [0, 2, 0]
let rowRange = [0, 0, 0] ... [0, 2, 0]
let row = D[rowRange]

// Get the matrix that spans the elements from [0, 0, 1] to [1, 2, 1]
let matrixRange = [0, 0, 1] ... [1, 2, 1]
let matrix = D[matrixRange]
```

### Properties
`MDArray` has two primary properties; `storage` and `shape`.

```swift
// The multidimensional array's storage in row-major order.
internal(set) var storage: Array<T>
    
// The shape of the multidimensional array.
internal(set) var shape: Array<Int>
```

`MDArray` also defines a number of computed properties to make life easier when working with common types of multidimensional arrays.

```swift
// The rank of the multidimensional array. This property is equivalent to the number of elements in the MDArray's `shape`.
public var rank: Int
    
// true iff the rank of the multidimensional array is 0.
public var isEmpty: Bool
    
// true iff the rank of the multidimensional array is 1.
public var isVector: Bool
    
// true iff the rank of the multidimensional array is 2.
public var isMatrix: Bool
    
// true iff the rank of the multidimensional array is greater than 2.
public var hasHigherOrderRepresentation: Bool
    
// This property is `true` if the dimensions of the receiver's simplified shape are all equal.
public var isSquare: Bool
```

### Functions
The following functions are defined by `MDArray`:
```swift
// Reshapes the multidimensional array. If the new shape results in a smaller storage storage size, then the multidimensional array's storage is truncated. Otherwise, the value of `repeating` is used to add any new elements to `storage`.
public mutating func reshape(_ shape: Array<Int>, repeating value: T?)

// Sets the receiver's `shape` to its simplified shape.
public mutating func simplify()

// Determines if `index` is valid in the multidimensional array.
public func validate(index: Array<Int>) -> Bool

// Returns a transposed multidimensional array by transposing its `dx`th and `dy`th dimensions.
public func transpose(_ dx: Int, _ dy: Int) -> MDArray<T>

// Converts the multidimensional array to an array of type `T`. You can check the property `isVector` to determine if this function will return a non-nil value.
public func vector() -> Array<T>?

// Converts the multidimensional array to a single nested array of type `T`. You can check the property `isMatix` to determine if this function will return a non-nil value.
public func matrix() -> Array<Array<T>>?

// Converts the multidimensional array with rank greater than 2 to a nested array of type `T`. You can check the property `hasHigherOrderRepresentation` to determine if this function will return a non-nil value.
public func multiArray() -> Array<Any>?
```

## MDExtensions
### Numeric protocol
Extension functions in `MDExtensions` require that the `MDArray`'s type conform to the `Numeric` protocol. The `Numeric` protocol,  declared in `MDExtensions.swift`, provides common numeric elements, and allows types such as `Int32`, `Float`, and `Double` to share operator declarations.
```swift
public protocol Numeric: Comparable, Equatable, SignedNumber {
    associatedtype ItemType
    
    /// An element that behaves as an identity under addition. I.e. The element `I` in `I + e = e + I = e`, where e is any element in the multidimensional array.
    static var additiveIdentity: ItemType { get }
    
    /// An element that behaves as an identity under multiplication. I.e. The element `I` in `I * e = e * I = e`, where e is any element in the multidimensional array.
    static var multiplicativeIdentity: ItemType { get }
    
    // Operators
    static func * (lhs: Self, rhs: Self) -> Self
    static func + (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
  
    static func *= (lhs: inout Self, rhs: Self)
    static func += (lhs: inout Self, rhs: Self)
    static func /= (lhs: inout Self, rhs: Self)
    static func -= (lhs: inout Self, rhs: Self)
}
```
Conforming to the Numeric protocol is easy, as most standard Swift types already define the static operator functions.
```swift
extension Int32: Numeric {
    public typealias ItemType = Int32
    public static var additiveIdentity: Int32 { return 0 }
    public static var multiplicativeIdentity: Int32 { return 1 }
}
```
The `Numeric` type allows extension functions such as `determinant()`, `symmetric()`, and `antisymmetric()` to do their job without the need to define multiple functions for different number types.

`MDExtensions` extends `Int32`, `Float`, and `Double` number types to conform to `Numeric`, but you may extend your own types to utilize the following functions.

### Functions
The following static functions are defined in `MDExtensions.swift`:
```swift
// Creates and returns a NULL multidimensional array.
public static func null(shape: Array<Int>) -> MDArray<T>

// Creates and returns an identity multidimensional array.
public static func identity(shape: Array<Int>, dx: Int, dy: Int) -> MDArray<T>?

// Finds and returns the determinant of a multidimensional array with `rank = 2`. For all other arrays, this function returns `nil`.
public static func determinant2d(_ A: MDArray<T>) -> T?
```
The following instance functions are defined in `MDExtensions.swift`:
```swift
// Finds and returns the determinant of a multidimensional array.
public func determinant() -> MDArray<T?>?

// Returns a boolean indicating wether or not the multidimensional matrix is symmetric in respect to the `dx`th and `dy`th dimensions.
public func symmetric(_ dx: Int, _ dy: Int) -> Bool

// Returns a boolean indicating wether or not the multidimensional matrix is antisymmetric in respect to the `dx`th and `dy`th dimensions.
public func antisymmetric(_ dx: Int, _ dy: Int) -> Bool
```

## MDMath
`MDMath` uses the `Acclerate` framework which dictates which types `MDMath`'s functions support. Currently `MDMath` supports computations with `Int32`, `Float`, and `Double` storage types.

### Functions
The following can be performed on `MDArray`s with any of the supported storage types. To support other storage types you'll need to define your own functions.
- Zeroing
- Filling
- Component sum
- Component product
- Scaler multiplication
- Scaler division
- Multidimensional array addition
- Multidimensional array subtraction
- Multidimensional array multiplication
- Element-wise multiplication
- Element-wise division
- Element-wise additive inverse

The following can be performed on any `MDArray` with `Equatable` types:
- Equality

Also included are conversion functions for converting between multidimensional arrays with different storage types.
- `Int32` <==> `Float`
- `Int32` <==> `Double`

### Operators
**`MDArray`/`MDArray` binary operators:**

Operator | Description
:---:|---
`==`    | Equality
`*`     | Multidimensional array multiplication
`.*`    | Element-wise multiplication
`./`     | Element-wise division
`+`     | Multidimensional array addition
`-`     | Multidimensional array subtraction

**Note:** *The `*` operator, as a convenience, multiplies the first dimension of the left-hand side of the expression with the second dimension of the right-hand side. To specify different dimensions use the `md_amul(_: _: _: _:)` function.*

**`MDArray`/scaler binary operators:**

Operator | Description
:---:|---
`*`     | Scaler multiplication
`/`     | Scaler division


**`MDArray` unary operators:**

Operator | Description
:---:|---
`-`     | Element-wise additive inverse
