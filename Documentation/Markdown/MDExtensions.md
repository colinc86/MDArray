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
