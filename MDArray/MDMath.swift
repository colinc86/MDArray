//  MDMath.swift
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
import Accelerate

// MARK: MDArray/MDArray Binary Operators

// MARK: MDArray/MDArray equivalence

public func == <T: Equatable>(A: MDArray<T>, B: MDArray<T>) -> Bool { return md_eq(A, B) }


// MARK: MDArray/MDArray multiplication

public func * (A: MDArray<Float>, B: MDArray<Float>) -> MDArray<Float> { return md_mul(A, 0, B, 1) }

public func * (A: MDArray<Double>, B: MDArray<Double>) -> MDArray<Double> { return md_mulD(A, 0, B, 1) }

public func * (A: MDArray<Int32>, B: MDArray<Int32>) -> MDArray<Int32> { return md_muli(A, 0, B, 1) }


// MARK: MDArray/MDArray multiplication (element-wise)

infix operator .*

public func .* (A: MDArray<Int32>, B: MDArray<Int32>) -> MDArray<Int32> { return md_emuli(A, B) }

public func .* (A: MDArray<Float>, B: MDArray<Float>) -> MDArray<Float> { return md_emul(A, B) }

public func .* (A: MDArray<Double>, B: MDArray<Double>) -> MDArray<Double> { return md_emulD(A, B) }


// MARK: MDArray/MDArray division (element-wise)

infix operator ./

public func ./ (A: MDArray<Int32>, B: MDArray<Int32>) -> MDArray<Int32> { return md_edivi(A, B) }

public func ./ (A: MDArray<Float>, B: MDArray<Float>) -> MDArray<Float> { return md_ediv(A, B) }

public func ./ (A: MDArray<Double>, B: MDArray<Double>) -> MDArray<Double> { return md_edivD(A, B) }


// MARK: MDArray/MDArray addition (element-wise)

public func + (A: MDArray<Int32>, B: MDArray<Int32>) -> MDArray<Int32> { return md_addi(A, B) }

public func + (A: MDArray<Float>, B: MDArray<Float>) -> MDArray<Float> { return md_add(A, B) }

public func + (A: MDArray<Double>, B: MDArray<Double>) -> MDArray<Double> { return md_addD(A, B) }


// MARK: MDArray/MDArray subtraction (element-wise)

public func - (A: MDArray<Int32>, B: MDArray<Int32>) -> MDArray<Int32> { return md_subi(A, B) }

public func - (A: MDArray<Float>, B: MDArray<Float>) -> MDArray<Float> { return md_sub(A, B) }

public func - (A: MDArray<Double>, B: MDArray<Double>) -> MDArray<Double> { return md_subD(A, B) }


// MARK: MDArray/scaler Binary operators

// MARK: MDArray/scaler multiplication

public func * (A: MDArray<Int32>, s: Int32) -> MDArray<Int32> { return md_smuli(A, s) }

public func * (A: MDArray<Float>, s: Float) -> MDArray<Float> { return md_smul(A, s) }

public func * (A: MDArray<Double>, s: Double) -> MDArray<Double> { return md_smulD(A, s) }

public func * (s: Int32, A: MDArray<Int32>) -> MDArray<Int32> { return md_smuli(A, s) }

public func * (s: Float, A: MDArray<Float>) -> MDArray<Float> { return md_smul(A, s) }

public func * (s: Double, A: MDArray<Double>) -> MDArray<Double> { return md_smulD(A, s) }

// MARK: MDArray/scaler division

public func / (A: MDArray<Int32>, s: Int32) -> MDArray<Int32> { return md_sdivi(A, s) }

public func / (A: MDArray<Float>, s: Float) -> MDArray<Float> { return md_sdiv(A, s) }

public func / (A: MDArray<Double>, s: Double) -> MDArray<Double> { return md_sdivD(A, s) }

public func / (s: Int32, A: MDArray<Int32>) -> MDArray<Int32> { return md_sdivi(s, A) }

public func / (s: Float, A: MDArray<Float>) -> MDArray<Float> { return md_sdiv(s, A) }

public func / (s: Double, A: MDArray<Double>) -> MDArray<Double> { return md_sdivD(s, A) }


// MARK: MDArray unary operators

// MARK: MDArray additive inverse

public prefix func - (A: MDArray<Int32>) -> MDArray<Int32> { return md_ainvi(A) }

public prefix func - (A: MDArray<Float>) -> MDArray<Float> { return md_ainv(A) }

public prefix func - (A: MDArray<Double>) -> MDArray<Double> { return md_ainvD(A) }




// MARK: Functions

// MARK: Conversions

/// Convert a multidimensional array with an `Int32` storage type to a multidimensional array with a `Float` storage type.
public func md_convert_i32f(_ A: MDArray<Int32>) -> MDArray<Float> {
    var va = A
    var output = Array<Float>(repeating: 0.0, count: va.storage.count)
    vDSP_vflt32(&va.storage, 1, &output, 1, vDSP_Length(va.storage.count))
    return MDArray<Float>(shape: va.shape, storage: output)
}

/// Convert a multidimensional array with a `Float` storage type to a multidimensional array with an `Int32` storage type.
public func md_convert_fi32(_ A: MDArray<Float>) -> MDArray<Int32> {
    var va = A
    var output = Array<Int32>(repeating: 0, count: va.storage.count)
    vDSP_vfix32(&va.storage, 1, &output, 1, vDSP_Length(va.storage.count))
    return MDArray<Int32>(shape: va.shape, storage: output)
}

/// Convert a multidimensional array with an `Int32` storage type to a multidimensional array with a `Double` storage type.
public func md_convert_i32d(_ A: MDArray<Int32>) -> MDArray<Double> {
    var va = A
    var output = Array<Double>(repeating: 0, count: va.storage.count)
    vDSP_vflt32D(&va.storage, 1, &output, 1, vDSP_Length(va.storage.count))
    return MDArray<Double>(shape: va.shape, storage: output)
}

/// Convert a multidimensional array with a `Double` storage type to a multidimensional array with an `Int32` storage type.
public func md_convert_di32(_ A: MDArray<Double>) -> MDArray<Int32> {
    var va = A
    var output = Array<Int32>(repeating: 0, count: va.storage.count)
    vDSP_vfix32D(&va.storage, 1, &output, 1, vDSP_Length(va.storage.count))
    return MDArray<Int32>(shape: va.shape, storage: output)
}




// MARK: Zeroing

/// Sets the multidimensional array's elements to `0`.
public func md_zeroi(_ A: inout MDArray<Int32>) {
    md_filli(0, &A)
}

/// Sets the multidimensional array's elements to `0.0`.
public func md_zero(_ A: inout MDArray<Float>) {
    vDSP_vclr(&A.storage, 1, vDSP_Length(A.storage.count))
}

/// Sets the multidimensional array's elements to `0.0`.
public func md_zeroD(_ A: inout MDArray<Double>) {
    vDSP_vclrD(&A.storage, 1, vDSP_Length(A.storage.count))
}




// MARK: Filling

/// Sets the multidimensional array's elements to `c`.
public func md_filli(_ c: Int32, _ A: inout MDArray<Int32>) {
    var component = Int32(c)
    vDSP_vfilli(&component, &A.storage, 1, vDSP_Length(A.storage.count))
}

/// Sets the multidimensional array's elements to `c`.
public func md_fill(_ c: Float, _ A: inout MDArray<Float>) {
    var component = Float(c)
    vDSP_vfill(&component, &A.storage, 1, vDSP_Length(A.storage.count))
}

/// Sets the multidimensional array's elements to `c`.
public func md_fillD(_ c: Double, _ A: inout MDArray<Double>) {
    var component = Double(c)
    vDSP_vfillD(&component, &A.storage, 1, vDSP_Length(A.storage.count))
}




// MARK: Component sum

/// Calculates the sum of the components of the MDArray.
public func md_sumi(_ A: MDArray<Int32>) -> Int32 {
    let tf = md_convert_i32f(A)
    let output: Float = md_sum(tf)
    return Int32(output)
}

/// Calculates the sum of the components of the MDArray.
public func md_sum(_ A: MDArray<Float>) -> Float {
    var sum: Float = 0.0
    vDSP_sve(A.storage, 1, &sum, vDSP_Length(A.storage.count))
    return sum
}

/// Calculates the sum of the components of the MDArray.
public func md_sumD(_ A: MDArray<Double>) -> Double {
    var sum: Double = 0.0
    vDSP_sveD(A.storage, 1, &sum, vDSP_Length(A.storage.count))
    return sum
}




// MARK: Component product

/// Returns the product of the components of the MDArray.
public func md_prodi(_ A: MDArray<Int32>) -> Int32 {
    var p = Int32(0)
    var a = UnsafePointer<Int32>(A.storage)
    
    for j in 0 ..< A.storage.count {
        p *= a.pointee as Int32
        
        if j < A.storage.count - 1 {
            a = a.successor()
        }
    }
    
    return p
}

/// Returns the product of the components of the MDArray.
public func md_prod(_ A: MDArray<Float>) -> Float {
    var p = Float(0.0)
    var a = UnsafePointer<Float>(A.storage)
    
    for j in 0 ..< A.storage.count {
        p *= a.pointee as Float
        
        if j < A.storage.count - 1 {
            a = a.successor()
        }
    }
    
    return p
}

/// Returns the product of the components of the MDArray.
public func md_prodD(_ A: MDArray<Double>) -> Double {
    var p = Double(0.0)
    var a = UnsafePointer<Double>(A.storage)
    
    for j in 0 ..< A.storage.count {
        p *= a.pointee as Double
        
        if j < A.storage.count - 1 {
            a = a.successor()
        }
    }
    
    return p
}




// MARK: Component additive inverse

/// Sets each element of the mulidimensional array to the element's additive inverse.
public func md_ainvi(_ A: MDArray<Int32>) -> MDArray<Int32> {
    var a = UnsafePointer<Int32>(A.storage)
    var s = Array<Int32>(repeating: 0, count: A.storage.count)
    
    for j in 0 ..< A.storage.count {
        s[j] = -(a.pointee as Int32)
        
        if j < A.storage.count - 1 {
            a = a.successor()
        }
    }
    
    return MDArray<Int32>(shape: A.shape, storage: s)
}

/// Sets each element of the mulidimensional array to the element's additive inverse.
public func md_ainv(_ A: MDArray<Float>) -> MDArray<Float> {
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_vneg(A.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Sets each element of the mulidimensional array to the element's additive inverse.
public func md_ainvD(_ A: MDArray<Double>) -> MDArray<Double> {
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_vnegD(A.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}




// MARK: Equality

/// Determines if two MDArrays are equal. I.e. Returns `true` iff the shape of `A` is equal to the shape of `B` and each of the cooresponding components of `A` and `B` are equal.
public func md_eq<T: Equatable>(_ A: MDArray<T>, _ B: MDArray<T>) -> Bool {
    var e = A.rank == B.rank
    
    if e && (A.rank > 0) {
        let sa = UnsafeBufferPointer(start: A.shape, count: A.rank)
        let sb = UnsafeBufferPointer(start: B.shape, count: B.rank)
        
        for s in zip(sa, sb) {
            e = s.0 == s.1
            
            if !e {
                return false
            }
        }
    }
    
    if e {
        var e = A.storage.count == B.storage.count
        
        if e && (A.storage.count > 0) {
            let sta = UnsafeBufferPointer(start: A.storage, count: A.storage.count)
            let stb = UnsafeBufferPointer(start: B.storage, count: B.storage.count)
            
            for st in zip(sta, stb) {
                e = (st.0 == st.1)
                
                if !e {
                    return false
                }
            }
        }
    }
    
    return e
}




// MARK: Scaler multiplication

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_smuli(_ A: MDArray<Int32>, _ s: Int32) -> MDArray<Int32> {
    var a = UnsafePointer<Int32>(A.storage)
    var st = Array<Int32>(repeating: 0, count: A.storage.count)
    
    for j in 0 ..< A.storage.count {
        st[j] = (a.pointee as Int32) * s
        
        if j < A.storage.count - 1 {
            a = a.successor()
        }
    }
    
    return MDArray<Int32>(shape: A.shape, storage: st)
}

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_smul(_ A: MDArray<Float>, _ s: Float) -> MDArray<Float> {
    var scaler = Float(s)
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_vsmul(A.storage, 1, &scaler, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_smulD(_ A: MDArray<Double>, _ s: Double) -> MDArray<Double> {
    var scaler = Double(s)
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_vsmulD(A.storage, 1, &scaler, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}




// MARK: Scaler division

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_sdivi(_ A: MDArray<Int32>, _ s: Int32) -> MDArray<Int32> {
    var scaler = Int32(s)
    var output = Array<Int32>(repeating: 0, count: A.storage.count)
    vDSP_vsdivi(A.storage, 1, &scaler, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Int32>(shape: A.shape, storage: output)
}

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_sdiv(_ A: MDArray<Float>, _ s: Float) -> MDArray<Float> {
    var scaler = Float(s)
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_vsdiv(A.storage, 1, &scaler, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_sdivD(_ A: MDArray<Double>, _ s: Double) -> MDArray<Double> {
    var scaler = Double(s)
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_vsdivD(A.storage, 1, &scaler, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_sdivi(_ s: Int32, _ A: MDArray<Int32>) -> MDArray<Int32> {
    var a = UnsafePointer<Int32>(A.storage)
    var st = Array<Int32>(repeating: 0, count: A.storage.count)
    
    for j in 0 ..< A.storage.count {
        st[j] = s * (a.pointee as Int32)
        
        if j < A.storage.count - 1 {
            a = a.successor()
        }
    }
    
    return MDArray<Int32>(shape: A.shape, storage: st)
}

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_sdiv(_ s: Float, _ A: MDArray<Float>) -> MDArray<Float> {
    var scaler = Float(s)
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_svdiv(&scaler, A.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Multiplies each element of the multidimensional array by the scaler `s` and returns the result.
public func md_sdivD(_ s: Double, _ A: MDArray<Double>) -> MDArray<Double> {
    var scaler = Double(s)
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_svdivD(&scaler, A.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}




// MARK: MDArray addition

/// Returns a MDArray whos components are the sum of the corresponding components of `A` and `B`.
public func md_addi(_ A: MDArray<Int32>, _ B: MDArray<Int32>) -> MDArray<Int32> {
    var output = Array<Int32>(repeating: 0, count: A.storage.count)
    vDSP_vaddi(A.storage, 1, B.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Int32>(shape: A.shape, storage: output)
}

/// Returns a MDArray whos components are the sum of the corresponding components of `A` and `B`.
public func md_add(_ A: MDArray<Float>, _ B: MDArray<Float>) -> MDArray<Float> {
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_vadd(A.storage, 1, B.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Returns a MDArray whos components are the sum of the corresponding components of `A` and `B`.
public func md_addD(_ A: MDArray<Double>, _ B: MDArray<Double>) -> MDArray<Double> {
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_vaddD(A.storage, 1, B.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}




// MARK: MDArray subtraction

/// Returns a MDArray whos components are the difference of the corresponding components of `A` and `B`.
public func md_subi(_ A: MDArray<Int32>, _ B: MDArray<Int32>) -> MDArray<Int32> {
    return md_addi(A, md_ainvi(B))
}

/// Returns a MDArray whos components are the difference of the corresponding components of `A` and `B`.
public func md_sub(_ A: MDArray<Float>, _ B: MDArray<Float>) -> MDArray<Float> {
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_vsub(A.storage, 1, B.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Returns a MDArray whos components are the difference of the corresponding components of `A` and `B`.
public func md_subD(_ A: MDArray<Double>, _ B: MDArray<Double>) -> MDArray<Double> {
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_vsubD(A.storage, 1, B.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}




// MARK: MDArray element-wise multiplication

/// Returns a MDArray whos components are the product of the corresponding components of `A` and `B`.
public func md_emuli(_ A: MDArray<Int32>, _ B: MDArray<Int32>) -> MDArray<Int32> {
    var a = UnsafePointer<Int32>(A.storage)
    var b = UnsafePointer<Int32>(B.storage)
    
    let st = Array<Int32>(repeating: 0, count: A.storage.count)
    var c = UnsafeMutablePointer<Int32>(mutating: st)
    
    for j in 0 ..< A.storage.count {
        c.pointee = (a.pointee as Int32) * (b.pointee as Int32)
        
        if j < A.storage.count - 1 {
            a = a.successor()
        }
        
        if j < B.storage.count - 1 {
            b = b.successor()
        }
        
        if j < st.count - 1 {
            c = c.successor()
        }
    }
    
    return MDArray<Int32>(shape: A.shape, storage: st)
}

/// Returns a MDArray whos components are the product of the corresponding components of `A` and `B`.
public func md_emul(_ A: MDArray<Float>, _ B: MDArray<Float>) -> MDArray<Float> {
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_vmul(A.storage, 1, B.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Returns a MDArray whos components are the product of the corresponding components of `A` and `B`.
public func md_emulD(_ A: MDArray<Double>, _ B: MDArray<Double>) -> MDArray<Double> {
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_vmulD(A.storage, 1, B.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}




// MARK: MDArray element-wise division

/// Returns a MDArray whos components are the quotient of the corresponding components of `A` and `B`.
public func md_edivi(_ A: MDArray<Int32>, _ B: MDArray<Int32>) -> MDArray<Int32> {
    var output = Array<Int32>(repeating: 0, count: A.storage.count)
    vDSP_vdivi(B.storage, 1, A.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Int32>(shape: A.shape, storage: output)
}

/// Returns a MDArray whos components are the quotient of the corresponding components of `A` and `B`.
public func md_ediv(_ A: MDArray<Float>, _ B: MDArray<Float>) -> MDArray<Float> {
    var output = Array<Float>(repeating: 0.0, count: A.storage.count)
    vDSP_vdiv(B.storage, 1, A.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Float>(shape: A.shape, storage: output)
}

/// Returns a MDArray whos components are the quotient of the corresponding components of `A` and `B`.
public func md_edivD(_ A: MDArray<Double>, _ B: MDArray<Double>) -> MDArray<Double> {
    var output = Array<Double>(repeating: 0.0, count: A.storage.count)
    vDSP_vdivD(B.storage, 1, A.storage, 1, &output, 1, vDSP_Length(A.storage.count))
    return MDArray<Double>(shape: A.shape, storage: output)
}




// MARK: MDArray multiplication

// A helper function to validate wether or not two arrays can be multiplied using the specified dimensions.
public func md_vmul<T>(_ A: MDArray<T>, _ da: Int, _ B: MDArray<T>, _ db: Int) -> Bool {
    var valid = true
    
    if A.rank != B.rank {
        valid = false
    }
    
    if valid {
        if A.shape[da] != B.shape[db] {
            valid = false
        }
    }
    
    if valid {
        for i in 0 ..< A.rank {
            if (i != da) && (i != db) {
                let dda = A.shape[i]
                let ddb = B.shape[i]
                
                if dda != ddb {
                    valid = false
                    break
                }
            }
        }
    }
    
    return valid
}

/**
 Multiplys the `da`th dimension of `A` with the `db`th dimension of `B`.
 
 - Precondition:
 To multiply two multidimensional arrays the following conditions must be met:
 - The `da`th dimension of `A` must be equal to the `db`th dimension of B. I.e. `A.dimension(da) == B.dimension(db)`.
 - For all `x != da` and `x!= db`, `A.dimension(x) == B.dimension(x)`.
    - This also implies that the order of `A` must be equal to the order of `B`.
 
 If these conditions are not met, then an empty multidimensional array is returned.
 
 - Remark:
 This function assumes both arrays have the same storage ordering (row-major or column-major).
 
 See [Multidimensional Matrix Mathematics: Multidimensional Matrix Equality, Addition, Subtraction, and Multiplication, Part 2 of 6](http://www.iaeng.org/publication/WCE2010/WCE2010_pp1829-1833.pdf) for more information.
 */
public func md_mul(_ A: MDArray<Float>, _ da: Int, _ B: MDArray<Float>, _ db: Int) -> MDArray<Float> {
    var C = MDArray<Float>()
    
    if md_vmul(A, da, B, db) {
        var cShape = Array<Int>(A.shape)
        cShape[da] = B.shape[db]
        cShape[db] = A.shape[da]
        
        C.reshape(shape: cShape, repeating: A.storage[0])
        for i in 0 ..< C.storage.count {
            let index = C.index(forStorageIndex: i)
            
            var sum: Float = 0.0
            for j in 0 ..< A.shape[db] {
                var aIndex = index
                aIndex[db] = j
                
                var bIndex = index
                bIndex[da] = j
                
                sum += A.element(atIndex: aIndex) * B.element(atIndex: bIndex)
            }
            
            C.setElement(sum, atIndex: index)
        }
    }
    
    return C
}

/**
 Multiplys the `da`th dimension of `A` with the `db`th dimension of `B`.
 
 - Precondition:
 To multiply two multidimensional arrays the following conditions must be met:
 - The `da`th dimension of `A` must be equal to the `db`th dimension of B. I.e. `A.dimension(da) == B.dimension(db)`.
 - For all `x != da` and `x!= db`, `A.dimension(x) == B.dimension(x)`.
    - This also implies that the order of `A` must be equal to the order of `B`.
 
 If these conditions are not met, then an empty multidimensional array is returned.
 
 - Remark:
 This function assumes both arrays have the same storage ordering (row-major or column-major).
 
 See [Multidimensional Matrix Mathematics: Multidimensional Matrix Equality, Addition, Subtraction, and Multiplication, Part 2 of 6](http://www.iaeng.org/publication/WCE2010/WCE2010_pp1829-1833.pdf) for more information.
 */
public func md_mulD(_ A: MDArray<Double>, _ da: Int, _ B: MDArray<Double>, _ db: Int) -> MDArray<Double> {
    var C = MDArray<Double>()
    
    if md_vmul(A, da, B, db) {
        var cShape = Array<Int>(A.shape)
        cShape[da] = B.shape[db]
        cShape[db] = A.shape[da]
        
        C.reshape(shape: cShape, repeating: A.storage[0])
        for i in 0 ..< C.storage.count {
            let index = C.index(forStorageIndex: i)
            
            var sum: Double = 0.0
            for j in 0 ..< A.shape[db] {
                var aIndex = index
                aIndex[db] = j
                
                var bIndex = index
                bIndex[da] = j
                
                sum += A.element(atIndex: aIndex) * B.element(atIndex: bIndex)
            }
            
            C.setElement(sum, atIndex: index)
        }
    }
    
    return C
}

/**
 Multiplys the `da`th dimension of `A` with the `db`th dimension of `B`.
 
 - Precondition:
 To multiply two multidimensional arrays the following conditions must be met:
 - The `da`th dimension of `A` must be equal to the `db`th dimension of B. I.e. `A.dimension(da) == B.dimension(db)`.
 - For all `x != da` and `x!= db`, `A.dimension(x) == B.dimension(x)`.
    - This also implies that the order of `A` must be equal to the order of `B`.
 
 If these conditions are not met, then an empty multidimensional array is returned.
 
 - Remark:
 This function assumes both arrays have the same storage ordering (row-major or column-major).
 
 See [Multidimensional Matrix Mathematics: Multidimensional Matrix Equality, Addition, Subtraction, and Multiplication, Part 2 of 6](http://www.iaeng.org/publication/WCE2010/WCE2010_pp1829-1833.pdf) for more information.
 */
public func md_muli(_ A: MDArray<Int32>, _ da: Int, _ B: MDArray<Int32>, _ db: Int) -> MDArray<Int32> {
    var C = MDArray<Int32>()
    
    if md_vmul(A, da, B, db) {
        var cShape = Array<Int>(A.shape)
        cShape[da] = B.shape[db]
        cShape[db] = A.shape[da]
        
        C.reshape(shape: cShape, repeating: A.storage[0])
        for i in 0 ..< C.storage.count {
            let index = C.index(forStorageIndex: i)
            
            var sum: Int32 = 0
            for j in 0 ..< A.shape[db] {
                var aIndex = index
                aIndex[db] = j

                var bIndex = index
                bIndex[da] = j
                
                sum += A.element(atIndex: aIndex) * B.element(atIndex: bIndex)
            }
            
            C.setElement(sum, atIndex: index)
        }
    }
    
    return C
}

