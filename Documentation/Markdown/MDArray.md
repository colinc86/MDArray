## MDArray
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
