//  MDArray.swift
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

/// A multidimensional array.
public struct MDArray<T>: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: Properties
    
    /// The multidimensional array's storage.
    public internal(set) var storage: Array<T>
    
    /// The shape of the multidimensional array.
    public internal(set) var shape: Array<Int>
    
    
    
    
    // MARK: Computed properties
    
    /// The rank of the multidimensional array. This property is equivalent to the number of elements in the MDArray's `shape`.
    public var rank: Int {
        return self.shape.count
    }
    
    /// This property is `true` iff the rank of the multidimensional array is `0`.
    public var isEmpty: Bool {
        return self.rank == 0
    }
    
    /// This property is `true` iff the rank of the multidimensional array is `1`.
    public var isVector: Bool {
        return self.rank == 1
    }
    
    /// This property is `true` iff the rank of the multidimensional array is `2`.
    public var isMatrix: Bool {
        return self.rank == 2
    }
    
    /// This property is `true` iff the rank of the multidimensional array is greater than `2`.
    public var hasHigherOrderRepresentation: Bool {
        return self.rank > 2
    }
    
    /**
     This property is `true` if the dimensions of the receiver's simplified shape are all equal.
     
     - Example:
     If the shape of array `A` is `[2, 2, 2, 1]`, then its simplified shape is `[2, 2, 2]` and all dimensions are equal. Therefor, `A` is square.
     */
    public var isSquare: Bool {
        var square = false
        let s = self.simplify(shape: self.shape)
        
        if s.count > 0 {
            square = true
            
            if s.count > 1 {
                for i in 1 ..< s.count {
                    if s[0] != s[i] {
                        square = false
                        break
                    }
                }
            }
            else if s[0] > 1 {
                square = false
            }
        }
        
        return square
    }
    
    /// The multidimensional array's description.
    public var description: String {
        var typeString = ""
        var des = ""
        
        if self.isEmpty {
            typeString = "empty"
            des = String(describing: self.storage)
        }
        else if self.isVector {
            typeString = "vector"
            des = String(describing: self.vector()!)
        }
        else if self.isMatrix {
            typeString = "matrix"
            des = String(describing: self.matrix()!)
        }
        else if self.hasHigherOrderRepresentation {
            typeString = "multi"
            des = String(describing: self.multiArray()!)
        }
        
        return "MDArray \(self.shape) (" + typeString + "): " + des
    }
    
    /// The multidimensional array's debug description.
    public var debugDescription: String {
        return self.description
    }
    
    
    
    
    // MARK: Initializers
    
    /**
     Initializes an empty MDArray.
     */
    public init() {
        self.storage = Array<T>()
        self.shape = Array<Int>()
    }
    
    /**
     - Parameter A: The multidimensional array to copy.
     */
    public init(_ A: MDArray<T>) {
        self.init(shape: A.shape, storage: A.storage)
    }
    
    /**
     - Parameter shape: The shape of the multidimensional array.
     - Parameter storage: The storage array with which to initialize the receiver's storage.
     */
    public init(shape: Array<Int>, storage: Array<T>) {
        self.init()
        let expectedStorageCount = productOfElements(shape)
        
        assert(expectedStorageCount <= storage.count, String(format:"Expected %d elements but storage only has %d.", expectedStorageCount, storage.count))
        
        self.storage.append(contentsOf: storage[0 ..< expectedStorageCount])
        self.shape = shape
    }
    
    /**
     - Parameter shape: The shape of the multidimensional array.
     - Parameter repeating: The value used to fill the array.
     */
    public init(shape: Array<Int>, repeating value: T) {
        self.init()
        self.shape.append(contentsOf: shape)
        self.storage = Array<T>(repeating: value, count: productOfElements(shape))
    }
    
    
    
    
    // MARK: Public functions
    
    /**
     Reshapes the multidimensional array.
     
     - note:
     If the new shape results in a smaller storage storage size, then the multidimensional array's storage is truncated. Otherwise, the value of `repeating` is used to add any new elements to `storage`.
     
     
     - Parameter shape: The new shape of the multidimensional array.
     - Parameter repeating: The value to use if `storage` must grow. Otherwise this value can be nil.
     - Returns: The reshaped multidimensional array.
     */
    public mutating func reshape(shape: Array<Int>, repeating value: T?) {
        var success = true
        
        // If shape is empty, then this array is a scaler and storage should have a capacity of 1.
        let storageLength = shape.count > 0 ? productOfElements(shape) : 1
        
        if storageLength < self.storage.count {
            self.storage.removeLast(self.storage.count - storageLength)
        }
        else if storageLength > self.storage.count {
            if let v = value {
                self.storage.append(contentsOf: Array<T>(repeating: v, count: storageLength - self.storage.count))
            }
            else {
                // The repeating value is required, but is nil... uh oh.
                success = false
            }
        }
        
        if success {
            self.shape = shape
        }
    }
    
    /**
     Sets the receiver's `shape` to its simplified form by calling the static function `simplify(shape:)`.
     */
    public mutating func simplify() {
        self.shape = self.simplify(shape: self.shape)
    }
    
    /**
     Determines if `index` is valid for this multidimensional array.
     
     - Parameter index: The index of the component in the array's storage.
     - Returns: `true` if `index` is valid, or `false` otherwise.
     */
    public func validate(index: Index) -> Bool {
        var valid = false
        
        if index.count == self.shape.count {
            for (i, j) in zip(index, self.shape) {
                valid = i < j
                
                if !valid {
                    break
                }
            }
        }
        
        return valid
    }
    
    /**
     Returns a transposed multidimensional array by transposing the `dx`th and `dy`th dimensions of the receiver.
     
     The traditional matrix transposition is performed on the 1st and 2nd dimensions:
     ```
     let B = A.transpose(0, 1)
     ```
     
     - Requires:
     `dx` and `dy` must both be valid dimension indexes of the receiver. That is, both must be less than `rank`.
     
     - Parameter dx: The first dimension of the transposition.
     - Parameter dy: The second dimension of the transposition.
     - Returns: The transposed multidimensional array.
     */
    public func transpose(_ dx: Int, _ dy: Int) -> MDArray<T> {
        // Get the modified shape
        var modifiedShape = Array<Int>(self.shape)
        let xDim = modifiedShape[dx]
        
        modifiedShape[dx] = modifiedShape[dy]
        modifiedShape[dy] = xDim
        
        // Populate the transposed array with our storage as temp values.
        var t = MDArray<T>(shape: modifiedShape, storage: self.storage)
        
        // Perform the transpose
        for i in 0 ..< self.storage.count {
            // Get the index of our storage index
            var index = self.index(forStorageIndex: i)
            let iXDim = index[dx]
            
            // Swap index at dx and dy
            index[dx] = index[dy]
            index[dy] = iXDim
            
            // Set the element at the new index
            t.setElement(self.storage[i], atIndex: index)
        }
        
        return t
    }
    
    /**
     Converts the multidimensional array to an array of type `T`.
     
     You can check the property `isVector` to determine if this function will return a non-nil value.
     
     - Returns: The multidimensional array in vector form.
     */
    public func vector() -> Array<T>? {
        var v: Array<T>? = nil
        
        if self.isVector {
            v = Array<T>(self.storage)
        }
        
        return v
    }
    
    /**
     Converts the multidimensional array to a single nested array of type `T`.
     
     You can check the property `isMatix` to determine if this function will return a non-nil value.
     
     - Returns: The multidimensional array in matrix form.
     */
    public func matrix() -> Array<Array<T>>? {
        var m: Array<Array<T>>? = nil
        
        if self.isMatrix {
            m = Array<Array<T>>()
            
            for i in 0 ..< self.shape[0] {
                var n = Array<T>()
                
                for j in 0 ..< self.shape[1] {
                    n.append(self.element(atIndex: [i, j]))
                }
                
                m!.append(n)
            }
        }
        
        return m
    }
    
    /**
     Converts the multidimensional array with rank greater than 2 to a nested array of type `T`.
     
     You can check the property `hasHigherOrderRepresentation` to determine if this function will return a non-nil value.
     
     - Returns: The multidimensional array (rank > 2) in the form of nested Swift `Array`s.
     */
    public func multiArray() -> Array<Any>? {
        var ma: Array<Any>? = nil

        if self.hasHigherOrderRepresentation {
            ma = Array<Any>()
            
            for index in self.indices {
                ma!.append(self.element(atIndex: index))
            }
            
            for j in 0 ..< self.shape.count {
                var modifiedIndex = j
                
                if j % 2 == 0 && j + 1 < self.shape.count {
                    modifiedIndex = j + 1
                }
                else if j % 2 == 1 {
                    modifiedIndex -= 1
                }
                
                let s = self.shape[modifiedIndex]
                var subArray = Array<Any>()
                
                for i in 0 ..< ma!.count / s {
                    subArray.append(Array<Any>(ma![i * s ..< i * s + s]))
                }
                
                ma = subArray
            }
        }
        
        return ma
    }
    
    
    
    
    /// MARK: Private functions
    
    /**
     Simplifies `shape` by removing leading pairs of `1`s and trailing `1`s.
     
     - Parameter shape: The shape to simplify.
     - Returns: The simplified shape.
     */
    private func simplify(shape: Array<Int>) -> Array<Int> {
        var simplifiedShape = Array<Int>(shape)
        var finished = false
        
        // Remove trailing 1's
        while simplifiedShape.count > 1 && !finished {
            if let last = simplifiedShape.last {
                if last > 1 {
                    finished = true
                }
                else {
                    let _ = simplifiedShape.popLast()
                }
            }
        }
        
        // Remove leading pairs of 1's
        if simplifiedShape.count > 1 {
            var trimIndex = 0
            for i in stride(from: 0, to: simplifiedShape.count, by: 2) {
                if simplifiedShape[i] == 1 && simplifiedShape[i + 1] == 1 {
                    trimIndex = i + 1
                }
                else {
                    break
                }
            }
            
            if trimIndex > 0 {
                simplifiedShape.removeFirst(trimIndex + 1)
            }
        }
        
        return simplifiedShape
    }
}




// MARK: MDArray MutableCollection extension

extension MDArray: MutableCollection {
    
    /// The index of an element in a multidimensional array.
    public typealias Index = Array<Int>
    
    /// An ordered set of indices of elements of a multidimensional array.
    public typealias Indices = Array<Index>
    
    /// Iterates the elements of a multidimensional array.
    public typealias Iterator = AnyIterator<T>
    
    
    
    
    // Subscripting
    
    /// Gets or sets an element in the multidimensional array at `index`.
    public subscript(index: Int ...) -> T {
        get {
            return self.element(atIndex: index)
        }
        
        set {
            self.setElement(newValue, atIndex: index)
        }
    }
    
    /// Gets or sets an element in the multidimensional array at `index`.
    public subscript(index: Index) -> T {
        get {
            return self.element(atIndex: index)
        }
        
        set {
            self.setElement(newValue, atIndex: index)
        }
    }
    
    /// Gets or sets a sub-array in the multidimensional array in `range`.
    public subscript(range: Range<Index>) -> MDArray<T> {
        get {
            return self.array(withRange: range)
        }
        
        set {
            self.setArray(newValue, forRange: range)
        }
    }
    
    
    
    
    // Variables
    
    /// The index of the first element of the multidimensional array.
    public var startIndex: Index {
        return Array<Int>(repeating: 0, count: self.rank)
    }
    
    /// The index of the last element of the multidimensional array.
    public var endIndex: Index {
        var endIndex = Index(self.shape)
        for i in 0 ..< endIndex.count {
            if endIndex[i] > 0 {
                endIndex[i] -= 1
            }
        }
        
        return endIndex
    }
    
    /// An ordered list of indices of the elements of the multidimensional array.
    public var indices: Indices {
        var indices = Indices()
        let endIndex = swapElements(self.endIndex)
        var currentIndex = swapElements(self.startIndex)
        
        while currentIndex <= endIndex {
            indices.append(swapElements(currentIndex))
            
            // Break if we've reached the upper bound
            if currentIndex == endIndex {
                break
            }
            
            // Incriment currentIndex
            currentIndex = swapElements(self.index(after: swapElements(currentIndex)))
        }
        
        return indices
    }
    
    
    
    
    // Functions
    
    /// Creates an iterator to iterate over the indices of the receiver.
    public func makeIterator() -> Iterator {
        var i = 0
        let indices = self.indices
        
        return AnyIterator {
            var element: T? = nil
            
            if i < indices.count {
                element = self.element(atIndex: indices[i])
                i += 1
            }
            
            return element
        }
    }
    
    /// Sets `i` to the next index of the receiver after `i`.
    public func formIndex(after i: inout Index) {
        i = self.index(after: i)
    }
    
    /// Gets the next index of the receiver after `i`.
    public func index(after i: Index) -> Index {
        var index = swapElements(i)
        let startIndex = swapElements(self.startIndex)
        let endIndex = swapElements(self.endIndex)
        
        for j in 0 ..< index.count {
            if index[j] < endIndex[j] {
                index[j] += 1
                break
            }
            else {
                index[j] = startIndex[j]
            }
        }
        
        return swapElements(index)
    }
    
    /// Transform the values of the receivers storage and return the transformed multidimensional array.
    public func map(_ transform: (T) throws -> T) rethrows -> MDArray<T> {
        var transformedStorage = Array<T>()
        
        for v in self.storage {
            do {
                let tv = try transform(v)
                transformedStorage.append(tv)
            }
            catch {
                break
            }
        }
        
        return MDArray<T>(shape: self.shape, storage: transformedStorage)
    }
    
    
    
    
    // Internal functions
    
    /**
     Converts the index of an element of the multidimensional array to the index of the element in the multidimensional array's storage using row-major order.
     
     This is the inverse function of `index(forStorageIndex:)`.
     
     - Parameter index: The index of the multidimensional array's element.
     - Returns: The index of the element in the multidimensional array's storage.
     */
    internal func storageIndex(forIndex index: Index) -> Int {
        var components = Array<Int>()
        
        for i in 0 ..< index.count {
            let c = index[i] * productOfElements(Array<Int>(self.shape[i + 1 ..< self.shape.count]))
            components.append(c)
        }
        
        return sumOfElements(components)
    }
    
    /**
     Converts the index of the component in the receiver's storage to the index of a component of the receiver.
     
     This is the inverse function of `storageIndex(forIndex:)`.
     
     - Parameter storageIndex: The index of the component in the array's storage.
     - Returns: The index of the array's component.
     */
    internal func index(forStorageIndex storageIndex: Int) -> Index {
        var index = Array<Int>()
        var storageCount = productOfElements(self.shape)
        var currentIndex = storageIndex
        
        for s in self.shape {
            storageCount /= s
            
            let i = Int(floor(Float(currentIndex) / Float(storageCount)))
            currentIndex -= storageCount * i
            
            index.append(i)
        }
        
        return index
    }
    
    /**
     Returns the element at `index`.
     
     - Note: The number of elements in `index` must be equal to the `order` of the receiver.
     
     - Parameter index: The index of the element in the multidimensional array.
     - Returns: The element at `index`.
     */
    internal func element(atIndex index: Index) -> T {
        let storageIndex = self.storageIndex(forIndex: index)
        return self.storage[storageIndex]
    }
    
    /**
     Sets the element's value at `index` to the value of `e`.
     
     - Parameter e: The value to set at `index`.
     - Parameter index: The index of the element in the multidimensional array.
     */
    internal mutating func setElement(_ e: T, atIndex index: Index) {
        let storageIndex = self.storageIndex(forIndex: index)
        self.storage[storageIndex] = e
    }
    
    /**
     Returns the multidimensional array with `range`.
     
     - Parameter range: The upper and lower bounds of the sub array.
     - Returns: The subarray with `range`.
     */
    internal func array(withRange range: Range<Index>) -> MDArray<T> {
        var subShape = Array<Int>() // The shape to use while iterating
        var newShape = Array<Int>() // The shape of the new array
        
        // Find subShape and newShape
        for (x, y) in zip(range.lowerBound, range.upperBound) {
            let diff = y - x
            subShape.append(diff + 1)
            
            // New shape should ignore dimensions with value 0
            if diff > 0 {
                newShape.append(diff + 1)
            }
        }
        
        var A = MDArray<T>(shape: subShape, storage: self.storage) // The temporary array. It will have as many dimensions as self.rank
        
        let startIndex = swapElements(range.lowerBound) // Swap indicies so it's easier to iterate
        let endIndex = swapElements(range.upperBound) // Ditto ^
        
        var currentIndex = startIndex // Our current step
        var newIndex = Array<Int>(repeating: 0, count: subShape.count) // Where we will save the element in the new array
        
        // Iterate over currentIndex and newIndex simultaneously
        while currentIndex <= endIndex {
            // Do something with currentIndex and newIndex
            let element = self.element(atIndex: swapElements(currentIndex))
            A.setElement(element, atIndex: swapElements(newIndex))
            
            // Break if we've reached the upper bound
            if currentIndex == endIndex {
                break
            }
            
            // Incriment currentIndex
            for i in 0 ..< currentIndex.count {
                if currentIndex[i] < endIndex[i] {
                    currentIndex[i] += 1
                    break
                }
                else {
                    currentIndex[i] = startIndex[i]
                }
            }
            
            // Incriment newIndex
            for i in 0 ..< newIndex.count {
                if newIndex[i] < swapElements(subShape)[i] - 1 {
                    newIndex[i] += 1
                    break
                }
                else {
                    newIndex[i] = 0
                }
            }
        }
        
        return MDArray<T>(shape: newShape, storage: A.storage)
    }
    
    /**
     Sets the multidimensional array's value for the given `range` to the value of `A`.
     
     - Parameter e: The value to set at `index`.
     - Parameter index: The index of the element in the multidimensional array.
     */
    internal mutating func setArray(_ A: MDArray<T>, forRange range: Range<Index>) {
        var subShape = Array<Int>() // The shape to use while iterating
        var newShape = Array<Int>() // The shape of the new array
        
        // Find subShape and newShape
        for (x, y) in zip(range.lowerBound, range.upperBound) {
            let diff = y - x
            subShape.append(diff + 1)
            
            // New shape should ignore dimensions with value 0
            if diff > 0 {
                newShape.append(diff + 1)
            }
        }
        
        // Almost identical to array(withRange:) with the exception of this array.
        // We copy A, but use the calculated subShape which results in an array with a larger rank.
        // B will still have as many elements in storage as A because subShape is identical newShape with added 1's.
        let B = MDArray<T>(shape: subShape, storage: A.storage) // The temporary array. It will have as many dimensions as self.rank
        
        let startIndex = swapElements(range.lowerBound) // Swap indicies so it's easier to iterate
        let endIndex = swapElements(range.upperBound) // Ditto ^
        
        var currentIndex = startIndex // Our current step
        var newIndex = Array<Int>(repeating: 0, count: subShape.count) // Where we will save the element in the receiver
        
        // Iterate over currentIndex and newIndex simultaneously
        while currentIndex <= endIndex {
            // Do something with currentIndex and newIndex
            let element = B.element(atIndex: swapElements(newIndex))
            self.setElement(element, atIndex: swapElements(currentIndex))
            
            // Break if we've reached the upper bound
            if currentIndex == endIndex {
                break
            }
            
            // Incriment currentIndex
            for i in 0 ..< currentIndex.count {
                if currentIndex[i] < endIndex[i] {
                    currentIndex[i] += 1
                    break
                }
                else {
                    currentIndex[i] = startIndex[i]
                }
            }
            
            // Incriment newIndex
            for i in 0 ..< newIndex.count {
                if newIndex[i] < swapElements(subShape)[i] - 1 {
                    newIndex[i] += 1
                    break
                }
                else {
                    newIndex[i] = 0
                }
            }
        }
    }
    
}





// MARK: Array Comparable extension

// Adds the ability to compare two indices of a multidimensional array so that `MDArray` can conform to the `MutableCollection` protocol.
extension Array: Comparable {
    
    static public func < (lhs: Array, rhs: Array) -> Bool {
        var leq = true
        
        if lhs.count == rhs.count {
            // Get the max lhs value
            var maxLHS = Int.min
            for i in 0 ..< lhs.count {
                let e = lhs[i]
                if e is Int {
                    if (e as! Int) > maxLHS {
                        maxLHS = e as! Int
                    }
                }
            }
            
            // Get the max rhs value
            var maxRHS = Int.min
            for i in 0 ..< rhs.count {
                let e = rhs[i]
                if e is Int {
                    if (e as! Int) > maxRHS {
                        maxRHS = e as! Int
                    }
                }
            }
            
            // Get the maximum dimensional value and create a shape
            let maxDimension = maxLHS > maxRHS ? maxLHS : maxRHS
            let basicShape = swapElements(Array<Int>(repeating: maxDimension, count: lhs.count))
            let swappedLHS = swapElements(lhs)
            let swappedRHS = swapElements(rhs)
            
            // Find the components of the sum
            var componentsL = Array<Int>()
            var componentsR = Array<Int>()
            
            for i in 0 ..< lhs.count {
                let cL = swappedLHS[i]
                let cR = swappedRHS[i]
                
                if (cL is Int) && (cR is Int) {
                    var icL = cL as! Int
                    var icR = cR as! Int
                    
                    if i > 0 {
                        icL *= productOfElements(Array<Int>(basicShape[0 ..< i]))
                        icR *= productOfElements(Array<Int>(basicShape[0 ..< i]))
                    }
                    
                    componentsL.append(cL as! Int)
                    componentsR.append(cR as! Int)
                }
                else {
                    break
                }
                
            }
            
            // Sum the components and compare the "flat" indices
            let sL = sumOfElements(componentsL)
            let sR = sumOfElements(componentsR)
            
            leq = sL < sR
        }
        
        return leq
    }
    
    static public func == (lhs: Array, rhs: Array) -> Bool {
        var eq = true
        
        if lhs.count == rhs.count {
            for i in 0 ..< lhs.count {
                let a = lhs[i]
                let b = rhs[i]
                
                if (a is Int) && (b is Int) {
                    if (a as! Int) != (b as! Int) {
                        eq = false
                        break
                    }
                }
            }
        }
        else {
            eq = false
        }
        
        return eq
    }
    
}




// MARK: Helper functions

/// Finds the product of the elements in `a` with the corresponding elements of `b`.
fileprivate func productOfElements(_ a: Array<Int>, _ b: Array<Int>) -> Array<Int> {
    var p = Array<Int>()
    for (x, y) in zip(a, b) {
        p.append(x * y)
    }
    
    return p
}

/// Finds the product of the elements of `a`.
fileprivate func productOfElements(_ a: Array<Int>) -> Int {
    var p = Int(1)
    for e in a {
        p *= e
    }
    
    return p
}

/// Finds the sum of the elements of `a`.
fileprivate func sumOfElements(_ a: Array<Int>) -> Int {
    var s = Int(0)
    for e in a {
        s += e
    }
    
    return s
}

/// Swaps consecutive even/odd indexed elements. We'll use this function to convert indices to/from column-major form to make iterating easier.
fileprivate func swapElements<T>(_ A: Array<T>) -> Array<T> {
    var s = Array(A)
    for i in stride(from: 0, to: A.count, by: 2) {
        if i + 1 < A.count {
            swap(&s[i], &s[i + 1])
        }
    }
    
    return s
}

