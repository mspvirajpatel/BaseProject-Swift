//
//  NSDictionary+BFKit.swift
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

/// This extension adds some useful functions to NSDictionary
public extension NSDictionary {
    // MARK: - Instance functions -
    
    /**
     Convert self to JSON as String
    
     - returns: Returns the JSON as String or nil if error while parsing
     */
    @available(*, deprecated: 1.3.0, message: "Use dictionaryToJSON()")
    public func dictionaryToJson()  throws-> String {
        return try self.dictionaryToJSON()
    }
    
    /**
     Convert self to JSON as String
    
     - returns: Returns the JSON as String or nil if error while parsing
     */
    public func dictionaryToJSON() throws -> String {
        return try NSDictionary.dictionaryToJSON(dictionary: self)
    }
    
    /**
     Returns an object if key exists or nil if not
     
     - parameter key: Key to get value of
     
     - returns: Value for the key Or nil
     */
    public func safeObjectForKey(key: String) -> AnyObject? {
        if let value = self[key] {
            return value as AnyObject?
        } else {
            return nil
        }
    }
    
    // MARK: - Class functions -
    
    /**
     Convert the given dictionary to JSON as String
    
     - parameter dictionary: The dictionary to be converted
    
     - returns: Returns the JSON as String or nil if error while parsing
     */
    @available(*, deprecated: 1.3.0, message: "Use dictionaryToJSON(_ )")
    public static func dictionaryToJson(dictionary: NSDictionary) throws -> String {
        return try self.dictionaryToJSON(dictionary: dictionary)
    }
    
    /**
     Convert the given dictionary to JSON as String
    
     - parameter dictionary: The dictionary to be converted
    
     - returns: Returns the JSON as String or nil if error while parsing
     */
    public static func dictionaryToJSON(dictionary: NSDictionary) throws -> String {
        var json: NSString
        let jsonData: NSData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) as NSData
        
        
        json = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)!
        return json as String
   
    }
    
    //Json String Convert
    
    public func JSONString() -> NSString{
        var jsonString : NSString = ""
        
        do
        {
            let jsonData : Data = try JSONSerialization .data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue : 0))
            jsonString = NSString(data: jsonData ,encoding: String.Encoding.utf8.rawValue)!
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        return jsonString
    }
    
    
    //  Convert NSDictionary to NSData
    public var toNSData : Data! {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)          // success ...
        } catch {
            // failure
            print("Fetch failed: \((error as NSError).localizedDescription)")
        }
        return Data()
    }
    
    //  Check key is exist in NSDictionary or not
    public func has(_ key: Key) -> Bool {
        return object(forKey: key) != nil
    }
    
}
