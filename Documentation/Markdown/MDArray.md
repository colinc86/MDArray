## MDArray
The following outlines the `MDArray` type defined in the file [`MDArray.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDArray.swift).

### Creating a MDArray
The default `MDArray` constructor creates an empty multidimensional array. I.e. a multidimensional array with empty storage and shape.
```swift
let A = MDArray<String>()
```
Each multidimensional array has a `shape` property that can either be set on initialization, or at a later point in time. The following creates a multidimensional array with shape `(1, 3, 2, 1)` and repeating value `""`. Ie. a 4-Dimensional array with dimensions `1`, `3`, `2` and `1`, and `1 * 3 * 2 * 1 = 6` elements with value `""`.
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

// Set the element at [1, 1, 0] to 2.0
D[1, 1, 0] = 2.0

// Set the element at [0, 2, 1] to the element at [1, 1, 0]
D[0, 2, 1] = D[1, 1, 0]
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
public internal(set) var storage: Array<T>
    
// The shape of the multidimensional array.
public internal(set) var shape: Array<Int>
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
In the case that you need to change a multidimensional array's shape, use the `reshape(shape:repeating:)` function:
```swift
var E = MDArray<Float>(shape: [2, 2, 2], repeating: 0.0)

// Reshape to a smaller array
E.reshape(shape: [2, 2], repeating: nil)

// Reshape to a larger array
E.reshape(shape: [2, 3, 4, 2], repeating: 0.0)
```
In the example above, we can pass `nil` for the `repeating` parameter in the first call to `reshape`, because `E` will have less (or equal) elements than before the reshaping process (since `2 * 2 <= 2 * 2 * 2`). In the second call to `reshape`, we pass the value of `0.0` to `reshape` via `repeating` to create the new elements added to `E` (since `2 * 2 <= 2 * 3 * 4 * 2`).

Suppose a multidimensional array has the shape `[1, 1, 4, 1, 5, 1]`. We can simplify this shape by calling `simplify()` on the array. `simplify()` removes leading *pairs* of `1`s, and *all* trailing `1`s from the array's `shape`.
```swift
var F = MDArray<Float>(shape: [1, 1, 4, 1, 5, 1], repeating: 0.0)
print(F.shape) // prints "[1, 1, 4, 1, 5, 1]"

F.simplify()
print(F.shape) // prints "[4, 1, 5]"
```

You may need to determine if an index is valid in a multidimensional array. That is, the index correctly locates a single element in the multidimensional array.
```swift
let G = MDArray<Float>(shape: [2, 3, 2, 2], repeating: 0.0)

let validIndex = [1, 2, 0, 1]
if G.validate(index: validIndex) {
    // Do something with index
}

let invalidIndex = [2, 2, 0, 1]
if G.validate(index: invalidIndex) {
    // Will not get called
}
```

Other functions defined in `MDArray`:
```swift
// Returns a transposed multidimensional array by transposing its `dx`th and `dy`th dimensions.
public func transpose(_ dx: Int, _ dy: Int) -> MDArray<T>

// Converts the multidimensional array to an array of type `T`. You can check the property `isVector` to determine if this function will return a non-nil value.
public func vector() -> Array<T>?

// Converts the multidimensional array to a single nested array of type `T`. You can check the property `isMatix` to determine if this function will return a non-nil value.
public func matrix() -> Array<Array<T>>?

// Converts the multidimensional array with rank greater than 2 to a nested array of type `T`. You can check the property `hasHigherOrderRepresentation` to determine if this function will return a non-nil value.
public func multiArray() -> Array<Any>?
```
