# `MDArray`
## A multidimensional array type for Swift.
-------------------------------------------

`MDArray` was created to manage higher order arrays in Swift. You can use it to represent vectors, matrices, and other higher order objects. Its math functions use the `Accelerate` framework and support the `Int32`, `Float`, `Double`, `DSPSplitComplex`, and `DSPDoubleSplitComplex` types. It also conforms to the `Sequence` protocol.

### Why use it?
The main objective of `MDArray` is to provide a way to work with higher order arrays in Swift. It attempts to be robust, well documented, and as fast as possible.

### To-Do
- Multidimensional array determinant
- Multidimensional array inverse
- Optimize `MDArray` transpose, symmetric, and asymmetric instance functions.

## MDArray
----------
### Creating a `MDArray`

The default `MDArray` constructor creates an empty multidimensional array. I.e. a multidimensional array with empty storage and shape.

```
let A = MDArray<Float>()
```

`MDArray` supports the storage types `Int32`, `Float`, `Double`, `DSPSplitComplex`, and `DSPDoubleSplitComplex` by default. To initialize a `MDArray` with an alternate storage type, use the `init(shape: Array<Int>, defaultValue: T)` constructor to specify the default value the `MDArray` should use when reshaping.

```
let B = MDArray<String>(defaultValue: "")
```

Each `MDArray` has a `shape` property that can either be set on initialization or at a later point in time. The following creates a multidimensional array with shape `(4, 4, 2)`. Ie. a 3-Dimensional array with dimensions `4`, `4`, and `2`.

```
let C = MDArray<Float>(4, 4, 2)
```
It is also possible to initialize a `MDArray` by passing `shape` and `defaultValue` values,

```
let D = MDArray<String>(shape: [4, 4, 2], defaultValue: "")
```

or by providing `shape` and `storage` values.

```
let E = MDArray<Float>(shape: D.shape, storage: C.storage)
var F = MDArray<Float>(E)
```
- note:
*The constructor `MDArray<T>(shape: Array<Int>, storage: Array<T>)` generally requires that `shape` be equal to the shape of the multidimensional array who owns `storage`. For example, the shape of `C` and `D` are both `(4, 4, 2)`.*

### Getting/Setting Elements

`MDArray` supports subscripting:

```
F[0, 0, 0] = 2.0
F[3, 3, 1] = F[0, 0, 0]
```

Or use the functions `elementAtIndices(_:)` and `setElement(_::)`:

```
let element = F.elementAtIndices([0, 0, 0])
F.setElement(element, atIndices: [0, 1, 0])
```

It is generally not necessary to manipulate the multidimensional array's `storage` property directly, but if you need to do so then use the helper functions `storageIndex(:)` and `indices(:)`.

```
// Setting an element in storage for given indices
let index = F.storageIndex(forIndices: [3, 3, 1])
F.storage[index] = 10.0

// Getting the element's indices if we know the storage index
let indices = F.indices(forStorageIndex: 1)
```

### Properties

The three most important properties of a `MDArray`:


- callout(`storage`):
`public var storage: Array<T>`\
*The `MDArray`'s storage.*


- callout(`shape`):
`public var shape: Array<Int>`\
*The shape of the `MDArray`.*\
It is not advised to set this property directly. Use the `reshape(_:)` function instead.


- callout(`defaultValue`):
`public var defaultValue: T?`\
*The default value to use when adding new elements to the multidimensional array.*\
This property is used when reshaping a multidimensional array to an array with more total elements than before the reshaping process. Set this property to provide your own default value for types other than those directly supported, or to override the default value the `MDArray` will use.


The following read-only properties are available for determining the order and common types of multidimensional arrays:


- callout(`order`):
`public var order: Int`\
*The number of elements in the `MDArray`'s `shape`.*


- callout(`isEmpty`):
`public var isEmpty: Bool`\
*`true` if and only if `order == 0`.*


- callout(`isVector`):
`public var isVector: Bool`\
*`true` if and only if `order == 1`.*


- callout(`isMatrix`):
`public var isMatrix: Bool`\
*`true` if and only if `order == 2`.*


- callout(`hasHigherOrderRepresentation`):
`public var hasHigherOrderRepresentation: Bool`\
*`true` if and only if `order > 2`.*


### Functions

This list is not exhaustive. It includes the most notable `MDArray` functions.


- callout( ):
\
`public func dimension(_ index: Int) -> Int`\
\
The dimension of the `n`th index of the multidimensional array's shape.


- callout( ):
\
`public mutating func reshape(_ shape: Array<Int>) -> MDArray<T>`\
\
Reshapes the multidimensional array. If the new shape results in a smaller storage storage size, then the multidimensional array's elements are truncated. Otherwise, the value stored in `defaultValue` is used to fill any new elements added to the multidimensional array's storage.


- callout( ):
\
`public func transpose(_ dx: Int, _ dy: Int) -> MDArray<T>`\
\
Returns a transposed multidimensional array by transposing the `dx`th and `dy`th dimensions of the receiver.


- callout( ):
\
`public func symmetric(_ dx: Int, _ dy: Int) -> Bool`\
\
Returns a boolean indicating wether or not the multidimensional matrix is symmetric in respect to the `dx`th and `dy`th dimensions.\
*Note: This function is only available for `MDArray`s with storage types that conform to the `Equatable` protocol.*


- callout( ):
\
`public func antisymmetric(_ dx: Int, _ dy: Int) -> Bool`\
\
Returns a boolean indicating wether or not the multidimensional matrix is antisymmetric in respect to the `dx`th and `dy`th dimensions.\
*Note: This function is only available for `MDArray`s with storage types that conform to the `SignedNumber` protocol.*


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
