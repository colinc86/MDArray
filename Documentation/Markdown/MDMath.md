## MDMath
The following outlines the file [`MDMath.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDMath.swift).

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
