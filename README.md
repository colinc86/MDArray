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
