//
//  BSDataStructures.swift
//  BaseProjectSwift
//
//  Created by MacMini-2 on 23/11/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import Foundation

// MARK: - Stack class -

/// Primitive Stack implementation

public class Stack: CustomStringConvertible {
    /// Describe the Stack
    public var description: String {
        return "\(stack)"
    }
    
    /// Private, the array behind Stack
    private var stack: Array<AnyObject> = Array<AnyObject>()
    
    /**
     Returns if the Stack is empty or not
    
     - returns: Returns true if the Stack is empty, otherwise false
     */
    public func empty() -> Bool {
        return stack.isEmpty
    }
    
    /**
     Adds an element on top of the Stack
    
     - parameter object: The element to add
     */
    public func push(object: AnyObject) {
        stack.append(object)
    }
    
    /**
     Removes an element on top of the Stack
    
     - returns: Returns the removed element
     */
    public func pop() -> AnyObject? {
        var popped: AnyObject? = nil
        if !self.empty() {
            popped = stack[stack.count - 1]
            stack.remove(at: stack.count - 1)
        }
        
        return popped
    }
}

// MARK: - List class -

/// Primitive List implementation. In order to work, the List must contain only objects that is subclass of NSObject
public class List: CustomStringConvertible {
    /// Describe the List
    public var description: String {
        return "\(list)"
    }
    
    /// Private, the array behind the List
    private var list: Array<AnyObject> = Array<AnyObject>()
    
    /**
     Search an element and returns the index
    
     - parameter object: The element to search
    
     - returns: Returns the index of the searched element
     */
    public func searchData(object: AnyObject) -> Int? {
        for i in 0 ..< list.count {
            if object is NSObject {
                if list[i] as! NSObject == object as! NSObject {
                    return i
                }
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    /**
     Insert an element in the List
    
     - parameter object: The element to insert in the List
     */
    public func insert(object: AnyObject) {
        list.append(object)
    }
    
    /**
     Delete an element in the List
     
     - parameter object: The object to be deleted
     
     - returns: Retruns true if removed, otherwise false
     */
    public func delete(object: AnyObject) -> Bool {
        let search = self.searchData(object: object)
        
        if search != nil {
            list.remove(at: search!)
            return true
        } else {
            return false
        }
    }
    
    /**
     Delete an element at the given index
    
     - parameter index: The index to delete
     */
    public func delete(index: Int) {
        list.remove(at: index)
    }
}

// MARK: - Queue class -

/// Primitive Queue implementation
public class Queue: CustomStringConvertible {
    /// Describe the Queue
    public var description: String {
        return "\(queue)"
    }
    
    /// Private, the array behind the Queue
    private var queue: Array<AnyObject> = Array<AnyObject>()
    
    /**
     Adds an element to the Queue
    
     - parameter object: The element to add
     */
    public func enqueue(object: AnyObject) {
        queue.append(object)
    }
    
    /**
     Dequeue the first element
     
     - returns: Retruns true if removed, otherwise false
     */
    public func dequeue() -> Bool {
        if queue.count > 0 {
            queue.remove(at: 0)
            return true
        } else {
            return false
        }
    }
    
    /**
     Returns the element on the top of the Queue
    
     - returns: Returns the element on the top of the Queue
     */
    public func top() -> AnyObject? {
        return queue.first
    }
    
    /**
     Remove all the elements in the Queue
     */
    public func emptyQueue() {
        queue.removeAll(keepingCapacity: false)
    }
}
