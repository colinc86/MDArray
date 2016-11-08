![MDArray](https://github.com/colinc86/MDArray/blob/master/Web%20Assets/Title.png?raw=true)
-------------------------------------------

`MDArray` was created to manage multidimensional arrays in Swift. You can use it to represent vectors, matrices, and other higher order objects. Its computational functions use the `Accelerate` framework and support the `Int32`, `Float`, and `Double` types.

### Why use it?
The main objective of `MDArray` is to provide a way to work with higher order arrays in Swift. Applications include machine learning, signal processing, physics, and just good ol' mathematics.

### Adding it to your project
The `MDArray` type and associated functions are broken up in to separate files. Depending on how you'll be using `MDArray`, you may only need one or two of them. Clone the repository using your terminal of choice and add the appropriate files to your project.
```
https://github.com/colinc86/MDArray.git
```

`MDArray.swift` **(required)** contains the main `MDArray` type declaration. If you only need `MDArray`'s storage handling and organization, then you can get away with only including this file in your project.

`MDExtensions.swift` **(optional)** adds computational functions to the `MDArray` type such as calculating determinants and determining symmetry.

`MDMath.swift` **(optional)** contains binary/unary operators and is the file responsible for utilizing the `Accelerate` framework to accomplish mathematical computations between `MDArray`s.

## MDArray
----------
`MDArray` has two primary properties; an array of integers, `shape`, and an array of elements ,`storage`, that are of the `MDArray`'s associated type. `shape` dictates the number of elements in `storage` and the order of `storage`'s elements.
### Creating a `MDArray`
The default `MDArray` constructor creates an empty multidimensional array. I.e. a multidimensional array with empty storage and shape.
```swift
let A = MDArray<String>()
```
Each `MDArray` has a `shape` property that can either be set on initialization, or at a later point in time. The following creates a multidimensional array with shape `(1, 3, 2, 1)`. Ie. a 4-Dimensional array with dimensions `1`, `3`, `2` and `1`, and `1 * 3 * 2 * 1 = 6` elements with value `""`.
```swift
let B = MDArray<String>(shape: [1, 3, 2, 1], repeating: "")
```
It is also possible to initialize a `MDArray` by passing an array of storage values,
```swift
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

Getting a row, column, or any sub-multidimensional array is just as easy:
```swift
// Get the column that spans the elements from [0, 0, 0] to [1, 0, 0]
let columnRange = Range<Array<Int>>(uncheckedBounds: ([0, 0, 0], [1, 0, 0]))
let column = D[columnRange]

// Get the row that spans the elements from [0, 0, 0] to [0, 2, 0]
let rowRange = Range<Array<Int>>(uncheckedBounds: ([0, 0, 0], [0, 2, 0]))
let row = D[rowRange]

// Get the matrix that spans the elements from [0, 0, 1] to [1, 2, 1]
let matrixRange = Range<Array<Int>>(uncheckedBounds: ([0, 0, 1], [1, 2, 1]))
let matrix = D[matrixRange]
```

### Properties
**`storage`**: *The `MDArray`'s storage.*
`internal(set) var storage: Array<T>`

**`shape`**: *The shape of the `MDArray`.*
`internal(set) var shape: Array<Int>`

**`rank`**: *The number of elements in `shape`.*
`public var rank: Int`

**`isEmpty`**: *`true` if and only if `order == 0`.*
`public var isEmpty: Bool`

**`isVector`**: *`true` if and only if `order == 1`.*
`public var isVector: Bool`

**`isMatrix`**: *`true` if and only if `order == 2`.*
`public var isMatrix: Bool`

**`hasHigherOrderRepresentation`**: *`true` if and only if `order > 2`.*
`public var hasHigherOrderRepresentation: Bool`

**`isSquare`**: `true` if the dimensions of the multidimensional array's simplified shape are all equal.

### Functions
`public mutating func reshape(_ shape: Array<Int>, repeating value: T?)`
Reshapes the multidimensional array. If the new shape results in a smaller storage storage size, then the multidimensional array's storage is truncated. Otherwise, the value of `repeating` is used to add any new elements to `storage`.

`public mutating func simplify()`
Sets the receiver's `shape` to the shape returned from the static function `simplify(shape:)`.

`public func validate(index: Array<Int>) -> Bool`
Determines if `index` is valid for this multidimensional array.

`public func transpose(_ dx: Int, _ dy: Int) -> MDArray<T>`
Returns a transposed multidimensional array by transposing the `dx`th and `dy`th dimensions of the receiver.

`public func vector() -> Array<T>?`
Converts the multidimensional array to an array of type `T`. You can check the property `isVector` to determine if this function will return a non-nil value.

`public func matrix() -> Array<Array<T>>?`
Converts the multidimensional array to a single nested array of type `T`. You can check the property `isMatix` to determine if this function will return a non-nil value.

`public func multiArray() -> Array<Any>?`
Converts the multidimensional array with rank greater than 2 to a nested array of type `T`. You can check the property `hasHigherOrderRepresentation` to determine if this function will return a non-nil value.


## MDMath
---------

`MDMath` uses the `Acclerate` framework which dictates `MDMath`s functions and the default types supported by `MDArray`.

### Functions

The following can be performed on `MDArray`s with any of the default storage types. To support other storage types you'll need to define your own functions.
- Zeroing
- Filling
- Component sum
- Component product
- Scaler multiplication
- Multidimensional array addition
- Multidimensional array subtraction
- Multidimensional array multiplication
- Element-wise multiplication
- Element-wise division
- Element-wise additive inverse

The following can be performed on any `MDArray` with `Equatable` types:
- Equality

Also included are conversion functions:
- `Int32` <==> `Float`
- `Int32` <==> `Double`



### Operators

The following operators are defined in `MDMath.swift` and support `MDArray`'s default types. To support types other than `Int32`, `Float`, `Double`, `DSPSplitComplex`, and `DSPDoubleSplitComplex`, you will need to define your own `infix`/`prefix` operators. Each operator corresponds to a function defined in `MDMath.swift`. See the MDMath **Functions** section above for more information.

- callout(`MDArray`/`MDArray` binary operators):
`==`    Equality\
`*`     Multidimensional array multiplication (see note)\
`.*`    Element-wise multiplication\
`/`     Element-wise division\
`+`     Multidimensional array addition\
`-`     Multidimensional array subtraction


- note:
*The `*` operator, as a convenience, multiplies the second dimension of the left-hand side of the expression with the first dimension of the right-hand side. To specify different dimensions use the `md_amul(_:_:_:_:)` function.*


- callout(`MDArray`/scaler binary operators):
`*`     Scaler multiplication


- callout(`MDArray` unary operators):
`-`    Element-wise additive inverse
