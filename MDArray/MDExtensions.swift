//  MDExtensions.swift
//

//  The MIT License (MIT)
//  Copyright © 2016 Colin Campbell. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

// MARK: Numeric protocol

/// Provides common numeric elements, and allows types such as `Int32`, `Float`, and `Double` to share operator declarations.
public protocol Numeric: Comparable, Equatable, SignedNumber {
    associatedtype ItemType
    
    /// An element that behaves as an identity under addition. I.e. The element `I` in `I + e = e + I = e`, where e is any element in the multidimensional array.
    static var additiveIdentity: ItemType { get }
    
    /// An element that behaves as an identity under multiplication. I.e. The element `I` in `I * e = e * I = e`, where e is any element in the multidimensional array.
    static var multiplicativeIdentity: ItemType { get }
    
    // Regular binary operators
    static func * (lhs: Self, rhs: Self) -> Self
    static func + (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    
    // Shorthand binary operators
    static func *= (lhs: inout Self, rhs: Self)
    static func += (lhs: inout Self, rhs: Self)
    static func /= (lhs: inout Self, rhs: Self)
    static func -= (lhs: inout Self, rhs: Self)
}




// MARK: Numeric protocols

extension Int32: Numeric {
    public typealias ItemType = Int32
    public static var additiveIdentity: Int32 { return 0 }
    public static var multiplicativeIdentity: Int32 { return 1 }
}

extension Float: Numeric {
    public typealias ItemType = Float
    public static var additiveIdentity: Float { return 0.0 }
    public static var multiplicativeIdentity: Float { return 1.0 }
}

extension Double: Numeric {
    public typealias ItemType = Double
    public static var additiveIdentity: Double { return 0.0 }
    public static var multiplicativeIdentity: Double { return 1.0 }
}




// MARK: MDArry extensions

// The following extension function only apply to `MDArray`s with a storage type that conforms to the `Numeric` protocol.
public extension MDArray where T: Numeric {
    
    // MARK: Static functions
    
    /**
     Creates and returns a NULL multidimensional array.
     
     - Parameter shape: The shape of the multidimensional array to create.
     - Returns: A multidimensional array with `shape` whos elements are each set to the associated type's `additiveIdentity`.
     */
    public static func null(shape: Array<Int>) -> MDArray<T> {
        var count: Int = 1
        for s in shape {
            count *= s
        }
        
        return MDArray<T>(shape: shape, storage: Array<T>(repeating: T.additiveIdentity as! T, count: count))
    }
    
    /**
     Creates and returns an identity multidimensional array.
     
     - Parameter shape: The shape of the multidimensional array to create.
     - Parameter dx: The first dimension of the identity.
     - Parameter dy: The second dimension of the identity.
     - Returns: A multidimensional array with `shape` who acts as an identity multidimensional array over the `dx` and `dy` dimensions.
     */
    public static func identity(shape: Array<Int>, dx: Int, dy: Int) -> MDArray<T>? {
        MDArray.checkCondition(dx < shape.count, "MDInvalidDimensionException", "identity(shape:dx:dy:) \(dx) (dx) should be less than the rank (\(shape.count)) of the array.")
        MDArray.checkCondition(dy < shape.count, "MDInvalidDimensionException", "identity(shape:dx:dy:) \(dy) (dy) should be less than the rank (\(shape.count)) of the array.")
        
        var I: MDArray<T>? = nil
        
        if dx < shape.count && dx < shape.count {
            if shape[dx] == shape[dx] {
                var tempI = MDArray<T>.null(shape: shape)
                
                if tempI.isSquare {
                    let indices = tempI.indices
                    for i in indices {
                        if i[dx] == i[dy] {
                            tempI.setElement(T.multiplicativeIdentity as! T, atIndex: i)
                        }
                    }
                    
                    I = tempI
                }
            }
        }
        
        return I
    }
    
    /**
     Finds and returns the determinant of a multidimensional array with `rank = 2`. For all other arrays, this function returns `nil`.
     
     - Parameter A: A multidimensional array with `rank = 2`.
     - Returns: The determinant of `A`, or `nil` if the determinant does not exist.
     */
    public static func determinant2d(_ A: MDArray<T>) -> T? {
        var det: T? = nil
        
        if A.isSquare && A.rank == 2 {
            let dim = A.shape[0]
            
            if dim == 2 { // 2x2 matrices
                det = (A.element(atIndex: [0, 0]) * A.element(atIndex: [1, 1])) - (A.element(atIndex: [0, 1]) * A.element(atIndex: [1, 0]))
            }
            else if dim > 2 { // nxn matricies, n > 2
                // Forward sum
                var fSum = T.additiveIdentity as! T
                for i in 0 ..< dim {
                    var product = T.multiplicativeIdentity as! T
                    
                    for j in 0 ..< dim {
                        let currentX = (i + j) % dim
                        let currentY = j
                        product *= A.element(atIndex: [currentX, currentY])
                    }
                    
                    fSum += product
                }
                
                // Reverse sum
                var rSum = T.additiveIdentity as! T
                for i in 0 ..< dim {
                    var product = T.multiplicativeIdentity as! T
                    
                    for j in 0 ..< dim {
                        let currentX = i - j >= 0 ? i - j : (i - j) + dim
                        let currentY = j
                        product *= A.element(atIndex: [currentX, currentY])
                    }
                    
                    rSum += product
                }
                
                det = fSum - rSum
            }
        }
        
        return det
    }
    
    
    
    
    // MARK: Public functions
    
    /**
     Finds and returns the determinant of a multidimensional array.
     
     - Parameter A: A multidimensional array.
     - Returns: The determinant of `A`, or `nil` if the determinant does not exist.
     */
    public func determinant() -> MDArray<T?>? {
        var det: MDArray<T?>? = nil
        
        if self.rank > 1 {
            if self.rank == 2 {
                if self.isSquare {
                    if let subDet = MDArray<T>.determinant2d(self) {
                        det = MDArray<T?>(shape: [1], storage: [subDet])
                    }
                }
            }
            else {
                let subShape = Array<Int>(self.shape[2 ..< self.shape.count])
                det = MDArray<T?>(shape: subShape, repeating: T.additiveIdentity as? T)
                
                let baseDimX = self.shape[0]
                let baseDimY = self.shape[1]
                
                var currentIndex = self.startIndex
                var endIndex = self.endIndex
                endIndex[0] = 0
                endIndex[1] = 0
                
                while currentIndex <= endIndex {
                    let lowerBound = currentIndex
                    var upperBound = [baseDimX - 1, baseDimY - 1]
                    upperBound.append(contentsOf: currentIndex[2 ..< currentIndex.count])

                    let subArray = self.array(withRange: lowerBound ... upperBound)
                    let subDet = MDArray<T>.determinant2d(subArray)
                    let newIndex = Array<Int>(currentIndex[2 ..< currentIndex.count])
                    det!.setElement(subDet, atIndex: newIndex)
                    
                    if currentIndex == endIndex {
                        break
                    }
                    
                    // Incriment currentIndex
                    for i in 2 ..< currentIndex.count {
                        if currentIndex[i] < endIndex[i] {
                            currentIndex[i] += 1
                            break
                        }
                        else {
                            currentIndex[i] = self.startIndex[i]
                        }
                    }
                }
            }
        }
        
        return det
    }
    
    /**
     Returns a boolean indicating wether or not the multidimensional matrix is symmetric in respect to the `dx`th and `dy`th dimensions.
     
     - Parameter dx: The first dimension of symmetry.
     - Parameter dy: The second dimension of symmetry.
     - Returns: A boolean indicating wether or not the multidimensional matrix is symmetric.
     */
    public func symmetric(_ dx: Int, _ dy: Int) -> Bool {
        MDArray.checkCondition(dx < self.rank, "MDInvalidDimensionException", "symmetric(_:_:) \(dx) (dx) should be less than the rank (\(self.rank)) of the array.")
        MDArray.checkCondition(dy < self.rank, "MDInvalidDimensionException", "symmetric(_:_:) \(dy) (dy) should be less than the rank (\(self.rank)) of the array.")
        
        var isSymmetric = true
        
        for i in 0 ..< self.storage.count {
            // Get the storage value
            let value = self.storage[i]
            
            // Get the index of our storage index
            var index = self.index(forStorageIndex: i)
            let iXDim = index[dx]
            
            // Swap index at dx and dy
            index[dx] = index[dy]
            index[dy] = iXDim
            
            if self.validate(index: index) {
                let element =  self.element(atIndex: index)
                
                if value != element {
                    isSymmetric = false
                    break
                }
            }
        }
        
        return isSymmetric
    }
    
    /**
     Returns a boolean indicating wether or not the multidimensional matrix is antisymmetric in respect to the `dx`th and `dy`th dimensions.
     
     - Parameter dx: The first dimension of the symmetry.
     - Parameter dy: The second dimension of the symmetry.
     - Returns: A boolean indicating wether or not the multidimensional matrix is antisymmetric.
     */
    public func antisymmetric(_ dx: Int, _ dy: Int) -> Bool {
        MDArray.checkCondition(dx < self.rank, "MDInvalidDimensionException", "antisymmetric(_:_:) \(dx) (dx) should be less than the rank (\(self.rank)) of the array.")
        MDArray.checkCondition(dy < self.rank, "MDInvalidDimensionException", "antisymmetric(_:_:) \(dy) (dy) should be less than the rank (\(self.rank)) of the array.")
        
        var isAntisymmetric = true
        
        for i in 0 ..< self.storage.count {
            // Get the storage value
            let value = self.storage[i]
            
            // Get the index of our storage index
            var index = self.index(forStorageIndex: i)
            let iXDim = index[dx]
            
            // Swap index at dx and dy
            index[dx] = index[dy]
            index[dy] = iXDim
            
            if self.validate(index: index) {
                let element =  self.element(atIndex: index)
                if value != -element {
                    isAntisymmetric = false
                    break
                }
            }
        }
        
        return isAntisymmetric
    }
    
}

