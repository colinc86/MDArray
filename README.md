![MDArray](https://github.com/colinc86/MDArray/blob/master/Documentation/Images/Title.png?raw=true)
-------------------------------------------

`MDArray` is a multidimensional array type for Swift. You can use it to represent vectors, matrices, and other higher order objects. It conforms to the `MutableCollection` protocol, and its math functions use the `Accelerate` framework.

### Why use it?
You can use `MDArray` to store any type in the form of a multidimensional array, such as `String` values in the title banner above. Some of the more interesting applications include machine learning, signal processing, physics, engineering, and just good ol' mathematics.

### Adding it to your project
Clone the repository using your terminal of choice, and add the appropriate files to your project.
```
https://github.com/colinc86/MDArray.git
```
The `MDArray` type and associated functions are separated in to different files. Depending on how you'll be using MDArray, you may only need one or two of them.
- [`MDArray.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDArray.swift) - [documentation](https://github.com/colinc86/MDArray/blob/master/Documentation/Markdown/MDArray.md) - Contains the main `MDArray` type declaration. If you only need MDArray's storage handling, then you can get away with only including this file in your project.
- [`MDExtensions.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDExtensions.swift) - [documentation](https://github.com/colinc86/MDArray/blob/master/Documentation/Markdown/MDExtensions.md) - Adds computational functions to the `MDArray` type such as calculating determinants and determining symmetry/antisymmetry.
- [`MDMath.swift`](https://github.com/colinc86/MDArray/blob/master/MDArray/MDMath.swift) - [documentation](https://github.com/colinc86/MDArray/blob/master/Documentation/Markdown/MDMath.md) - Contains binary/unary operators and is the file responsible for utilizing the `Accelerate` framework to accomplish mathematical computations between `MDArray`s.

Please read the documentation for each of the files that you use in your project to get a general idea of how they are used.

### Contributing
There is still work to be done! Please feel free to contribute to any of the following areas.

- Complex number support (`MDMath` should handle `DSPSplitComplex` and `DSPDoubleSplitComplex` vDSP functions)
- Row reductions
- Multidimensional array inverse, outter/inner products.
