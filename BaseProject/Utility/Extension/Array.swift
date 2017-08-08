//
//  Array+BFKit.swift
//  BFKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 - 2016 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// This extension adds some useful functions to Array
public extension Array {
    // MARK: - Instance functions -
    
    /**
      Get the object at a given index in safe mode (nil if self is empty or out of range)
    
     - parameter index: The index
    
     - returns: Returns the object at a given index in safe mode (nil if self is empty or out of range)
      */
    func safeObjectAtIndex(index: Int) -> Element? {
        if self.count > 0 && self.count > index {
            return self[index]
        } else {
            return nil
        }
    }
    
    
    /// EZSE: Returns a random element from the array.
    public func random() -> Element? {
        guard self.count > 0 else {
            return nil
        }
        
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    /// EZSE: Prepends an object to the array.
    public mutating func insertAsFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    /// EZSE: Shuffles the array in-place using the Fisher-Yates-Durstenfeld algorithm.
    public mutating func shuffle() {
        var j: Int
        
        for i in 0..<(self.count-2) {
            j = Int(arc4random_uniform(UInt32(self.count - i)))
            if i != i+j { swap(&self[i], &self[i+j]) }
        }
    }
    
    
    /**
     Convert self to JSON as String
    
     - returns: Returns the JSON as String or nil if error while parsing
     */
    func arrayToJSON() throws -> String {
        return try Array.arrayToJSON(array: self as AnyObject)
    }
    
    /**
     Simulates the array as a circle. When it is out of range, begins again
    
     - parameter index: The index
    
     - returns: Returns the object at a given index
     */
    func objectAtCircleIndex(index: Int) -> Element {
        return self[self.superCircle(index: index, size: self.count)]
    }
    
    /**
     Private, to get the index as a circle
    
     - parameter index:   The index
     - parameter maxSize: Max size of the array
    
     - returns: Returns the right index
     */
    func superCircle(index: Int, size maxSize: Int) -> Int {
        var _index = index
        if _index < 0 {
            _index = _index % maxSize
            _index += maxSize
        }
        if _index >= maxSize {
            _index = _index % maxSize
        }
        
        return _index
    }
    
    /**
     Move object from an index to another
    
     - parameter from: The start index
     - parameter to:   The end index
     */
    mutating func moveObjectFromIndex(from: Int, toIndex to: Int) {
        if to != from {
            let obj: Element = self.safeObjectAtIndex(index: from)!
            self.remove(at: from)
            
            if to >= self.count {
                self.append(obj)
            } else {
                self.insert(obj, at: to)
            }
        }
    }
    
    /**
     Create a reversed array from self
    
     - returns: Returns the reversed array
     */
    func reversedArray() -> Array {
        return Array.reversedArray(array: self)
    }
    
    // MARK: - Class functions -
    
    /**
     Create a reversed array from the given array
    
     - parameter array: The array to be reverse
    
     - returns: Returns the reversed array
     */
    static func reversedArray(array: Array) -> Array {
        return array.reversed()
    }
    
    /**
     Create a reversed array from the given array
    
     - parameter array: The array to be converted
    
     - returns: Returns the JSON as String or nil if error while parsing
     */
    static func arrayToJSON(array: AnyObject) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions())
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    }
}
