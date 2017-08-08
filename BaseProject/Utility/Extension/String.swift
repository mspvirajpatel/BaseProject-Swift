//
//  String+BFKit.swift
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
import UIKit

/**
 * Create String from formatted string.
 * Also can be use to convert any type to String.
 * Usages:
 Str("1+1=%d", 2)        //"1+1=2"
 Str(1024)               //"1024"
 Str(3.14)               //"3.14"
 ...
 */
public func Str(_ any: Any, _ arguments: CVarArg...) -> String {
    let str = String(format: String(describing: any), arguments: Array(arguments))
    return str
}

/// This extesion adds some useful functions to String
public extension String {
    
    public func localize(comment: String?) -> String {
        if comment != nil
        {
            return NSLocalizedString(self, comment: comment!)
        }
        else
        {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    public func localize() -> String {
        
        return NSLocalizedString(self, comment: "")
        
    }
    
    internal var urlEncoded: String {
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowed) ?? self
    }
    
    internal var queryParameters: [String: String] {
        var parameters = [String: String]()
        
        let scanner = Scanner(string: self)
        
        var key: NSString?
        var value: NSString?
        
        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo("=", into: &key)
            scanner.scanUpTo("=", into: nil)
            
            value = nil
            scanner.scanUpTo("&", into: &value)
            scanner.scanUpTo("&", into: nil)
            
            if let key = key as String?, let value = value as String? {
                parameters.updateValue(value, forKey: key)
            }
        }
        
        return parameters
    }
    
    /**
    * Return substring from index or to some particular string.
    * Usages:
    "hello world".subFrom(6)        //"world"
    "hello world".subFrom(-5)       //"world"
    "hello world".subFrom("wo")     //"world"
    */
    @discardableResult public func subFrom(_ indexOrSubstring: Any) -> String {
        if var index = indexOrSubstring as? Int {
            if index < 0 { index += self.characters.count }
            return self.substring(from: self.index(self.startIndex, offsetBy: index))
            
        } else if let substr = indexOrSubstring as? String {
            if let range = self.range(of: substr) {
                return self.substring(from: range.lowerBound)
            }
        }
        
        return ""
    }
    
    
    /**
     * Return substring to index or to some particular string.
     * Usages:
     "hello world".subTo(5)          //"hello"
     "hello world".subTo(-6)         //"hello"
     "hello world".subTo(" ")        //"hello"
     */
    @discardableResult public func subTo(_ indexOrSubstring: Any) -> String {
        if var index = indexOrSubstring as? Int {
            if index < 0 { index += self.characters.count }
            return self.substring(to: self.index(self.startIndex, offsetBy: index))
            
        } else if let substr = indexOrSubstring as? String {
            if let range = self.range(of: substr) {
                return self.substring(to: range.lowerBound)
            }
        }
        
        return ""
    }
    
    
    /**
     * Return substring at index or in range.
     * Usages:
     "hello world".subAt(1)          //"e"
     "hello world".subAt(1..<4)      //"ell"
     */
    @discardableResult public func subAt(_ indexOrRange: Any) -> String {
        if let index = indexOrRange as? Int {
            return String(self[self.index(self.startIndex, offsetBy: index)])
            
        } else if let range = indexOrRange as? Range<String.Index> {
            return self.substring(with: range)
            
        } else if let range = indexOrRange as? Range<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound)
            return self.substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? CountableRange<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound)
            return self.substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? ClosedRange<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound + 1)
            return self.substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? CountableClosedRange<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound + 1)
            return self.substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? NSRange {
            let lower = self.index(self.startIndex, offsetBy: range.location)
            let upper = self.index(self.startIndex, offsetBy: range.location + range.length)
            return self.substring(with: lower..<upper)
        }
        
        return ""
    }
    
    
    /**
     * Return substring that match the pattern.
     * Usages:
     "abc123".subMatch("\\d+")       //"123"
     */
    @discardableResult public func subMatch(_ pattern: String) -> String {
        let options = NSRegularExpression.Options(rawValue: 0)
        
        if let exp = try? NSRegularExpression(pattern: pattern, options: options) {
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            let matchRange = exp.rangeOfFirstMatch(in: self,
                                                   options:options,
                                                   range: NSMakeRange(0, self.characters.count))
            
            if matchRange.location != NSNotFound {
                return self.subAt(matchRange)
            }
        }
        
        return ""
    }
    
    
    /**
     * Replace substring with template.
     * Usages:
     "abc123".subReplace("abc", "ABC")               //ABC123
     "abc123".subReplace("([a-z]+)(\\d+)", "$2$1")   //"123abc"
     */
    @discardableResult public func subReplace(_ pattern: String, _ template: String) -> String {
        let options = NSRegularExpression.Options(rawValue: 0)
        
        if let exp = try? NSRegularExpression(pattern: pattern, options: options) {
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            return exp.stringByReplacingMatches(in: self,
                                                options: options,
                                                range: NSMakeRange(0, self.characters.count),
                                                withTemplate: template)
        }
        
        return ""
    }
    
    // MARK: - Variables -
    
    var first: String {
        return String(characters.prefix(1))
    }
    var lowerFirst: String {
        return first.lowercased() + String(characters.dropFirst())
    }

    
    /// Return the float value
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    // MARK: - Instance functions -
    
    
    /**
     Check if self is an email
    
     - returns: Returns true if it's an email, false if not
     */
    public func isEmail() -> Bool {
        return String.isEmail(email: self)
    }
    
    /**
     Encode the given string to Base64
    
     - returns: Returns the encoded string
     */
    public func encodeToBase64() -> String {
        return String.encodeToBase64(string: self)
    }
    
    /**
     Decode the given Base64 to string
    
     - returns: Returns the decoded string
     */
    public func decodeBase64() -> String {
        return String.decodeBase64(string: self)
    }
    
    /**
     Convert self to a NSData
     
     - returns: Returns self as NSData
     */
    public func convertToNSData() -> NSData {
        return NSString.convertToNSData(string: self as NSString)
    }
    
    
    /**
     Returns a new string containing matching regular expressions replaced with the template string
    
     - parameter regexString: The regex string
     - parameter replacement: The replacement string
    
     - returns: Returns a new string containing matching regular expressions replaced with the template string
     */
    public func stringByReplacingWithRegex(regexString: NSString, withString replacement: NSString) throws -> NSString {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regexString as String, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:NSMakeRange(0, self.length), withTemplate: "") as NSString
    }
    

    
    /// Returns the last path component
    public var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    func fileExtension() -> String? {
        
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return nil
        }
    }
    
    
    /// Returns the path extension
    public var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    /// Delete the last path component
    public var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    /// Delete the path extension
    public var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    /// Returns an array of path components
    public var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    /**
     Appends a path component to the string
     
     - parameter path: Path component to append
     
     - returns: Returns all the string
     */
    public func stringByAppendingPathComponent(path: String) -> String {
        let string = self as NSString
        
        return string.appendingPathComponent(path)
    }
    
    /**
     Appends a path extension to the string
     
     - parameter ext: Extension to append
     
     - returns: returns all the string
     */
    public func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
    
    /// Converts self to a NSString
    public var NS: NSString {
        return (self as NSString)
    }
    
    /**
     Returns if self is a valid UUID or not
     
     - returns: Returns if self is a valid UUID or not
     */
    public func isUUID() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.length))
            return matches == 1
        } catch {
            return false
        }
    }
    
    /**
     Returns if self is a valid UUID for APNS (Apple Push Notification System) or not
     
     - returns: Returns if self is a valid UUID for APNS (Apple Push Notification System) or not
     */
    public func isUUIDForAPNS() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{32}$", options: .caseInsensitive)
     
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.length))
            return matches == 1
        } catch {
            return false
        }
    }
    
    
    
    /**
     Used to calculate text height for max width and font
     
     - parameter width: Max width to fit text
     - parameter font:  Font used in text
     
     - returns: Returns the calculated height of string within width using given font
     */
    public func heightForWidth(width: CGFloat, font: UIFont) -> CGFloat {
        var size: CGSize = CGSize.zero
        if self.length > 0 {
            let frame: CGRect = self.boundingRect(with: CGSize.init(width: width, height: 999999), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil)
            size = CGSize.init(width: frame.size.width, height: frame.size.height)
            
        }
        return size.height
    }
   
    
    /**
     Check if the given string is an email
    
     - parameter email: The string to be checked
    
     - returns: Returns true if it's an email, false if not
     */
    public static func isEmail(email: String) -> Bool {
        let emailRegEx: String = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let regExPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return regExPredicate.evaluate(with: email.lowercased()
        )
    }
    
    public func convertToAPNSUUID() -> NSString {
       
         return self.trimmingCharacters(in: NSCharacterSet(charactersIn: "<>") as CharacterSet).replacingOccurrences(of: "", with: "").replacingOccurrences(of:"-", with: "") as NSString
    }
    
    /**
     Encode the given string to Base64
    
     - parameter string: String to encode
    
     - returns: Returns the encoded string
     */
    public static func encodeToBase64(string: String) -> String {
        let data: NSData = string.data(using: String.Encoding.utf8)! as NSData
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    /**
     Decode the given Base64 to string
    
     - parameter string: String to decode
    
     - returns: Returns the decoded string
     */
    public static func decodeBase64(string: String) -> String {
        let data: NSData = NSData(base64Encoded: string as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    /**
     Remove double or more duplicated spaces
     
     - returns: String without additional spaces
     */
    public func removeExtraSpaces() -> String {
        return self.NS.removeExtraSpaces() as String
    }
    
   
    
    
    
    
    
    /**
     Used to create an UUID as String
     
     - returns: Returns the created UUID string
     */
    public static func generateUUID() -> String {
        let theUUID: CFUUID? = CFUUIDCreate(kCFAllocatorDefault)
        let string: CFString? = CFUUIDCreateString(kCFAllocatorDefault, theUUID)
        return string! as String
    }
    
    //MARK: Helper methods
    
    /**
     Returns the length of the string.
     
     - returns: Int length of the string.
     */
    

    var objcLength: Int {
        return self.utf16.count
    }
    
    //MARK: - Linguistics
    
    /**
     Returns the langauge of a String
     
     NOTE: String has to be at least 4 characters, otherwise the method will return nil.
     
     - returns: String! Returns a string representing the langague of the string (e.g. en, fr, or und for undefined).
     */
    func detectLanguage() -> String? {
        if self.length > 4 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagSchemeLanguage], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
        }
        return nil
    }
    
    /**
     Returns the script of a String
     
     - returns: String! returns a string representing the script of the String (e.g. Latn, Hans).
     */
    func detectScript() -> String? {
        if self.length > 1 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagSchemeScript], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeScript, tokenRange: nil, sentenceRange: nil)
        }
        return nil
    }
    
    /**
     Check the text direction of a given String.
     
     NOTE: String has to be at least 4 characters, otherwise the method will return false.
     
     - returns: Bool The Bool will return true if the string was writting in a right to left langague (e.g. Arabic, Hebrew)
     
     */
    var isRightToLeft : Bool {
        let language = self.detectLanguage()
        return (language == "ar" || language == "he")
    }
    
    
    //MARK: - Usablity & Social
    
 
    /**
     Check that a String is 'tweetable' can be used in a tweet.
     
     - returns: Bool
     */
    func isTweetable() -> Bool {
        let tweetLength = 140,
        // Each link takes 23 characters in a tweet (assuming all links are https).
        linksLength = self.getLinks().count * 23,
        remaining = tweetLength - linksLength
        
        if linksLength != 0 {
            return remaining < 0
        } else {
            return !(self.utf16.count > tweetLength || self.utf16.count == 0 )
        }
    }
    
    /**
     Gets an array of Strings for all links found in a String
     
     - returns: [String]
     */
    func getLinks() -> [String] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
        
        return links!.filter { link in
            return link.url != nil
            }.map { link -> String in
                return link.url!.absoluteString
        }
    }
    
    /**
     Gets an array of URLs for all links found in a String
     
     - returns: [NSURL]
     */
//    func getURLs() -> [NSURL] {
//        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        
//        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
//        
//        return links!.filter { link in
//            return link.url != nil
//            }.map { link -> NSURL in
//                return link.url!
//        }
//    }
//    
//    
    /**
     Gets an array of dates for all dates found in a String
     
     - returns: [NSDate]
     */
//    func getDates() -> [NSDate] {
//        var error: NSError = NSError()
//        let detector: NSDataDetector?
//        do {
//            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
//        } catch let error1 as NSError {
//            error = error1
//            detector = nil
//        }
//        let dates = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, self.utf16.count)) .map {$0 }
//        
//        return dates!.filter { date in
//            return date.date != nil
//            }.map { link -> NSDate in
//                return link.date!
//        }
//    }
    
    /**
     Gets an array of strings (hashtags #acme) for all links found in a String
     
     - returns: [String]
     */
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.rangeAt(1))
        })
    }
    
    /**
     Gets an array of distinct strings (hashtags #acme) for all hashtags found in a String
     
     - returns: [String]
     */
    func getUniqueHashtags() -> [String]? {
        return Array(Set(getHashtags()!))
    }
    
    
    
    /**
     Gets an array of strings (mentions @apple) for all mentions found in a String
     
     - returns: [String]
     */
    func getMentions() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "@(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.rangeAt(1))
        })
    }
    
    /**
     Check if a String contains a Date in it.
     
     - returns: Bool with true value if it does
     */
    func getUniqueMentions() -> [String]? {
        return Array(Set(getMentions()!))
    }
    
    
    /**
     Check if a String contains a link in it.
     
     - returns: Bool with true value if it does
     */
    func containsLink() -> Bool {
        return self.getLinks().count > 0
    }
    
    /**
     Check if a String contains a date in it.
     
     - returns: Bool with true value if it does
     */
//    func containsDate() -> Bool {
//        return self.getDates().count > 0
//    }
    
    /**
     - returns: Base64 encoded string
     */
    func encodeToBase64Encoding() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
       
    }
    
    /**
     - returns: Decoded Base64 string
     */
    func decodeFromBase64Encoding() -> String {
        let base64data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        return NSString(data: base64data! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    
    
    // MARK: Subscript Methods
    
    subscript (i: Int) -> String {
        return String(Array(self.characters)[i])
    }
    
    
    var utf8StringEncodedData: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    var base64DecodedData: Data? {
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
    }
    
    
    public func stringToFloat() -> CGFloat{
        
        var floatNumber : CGFloat = 0.0
        
        let number : NSNumber! = NumberFormatter().number(from: self)
        if (number != nil){
            floatNumber = CGFloat(number)
            
        }
        
        return floatNumber
        
    }
    
    // https://gist.github.com/stevenschobert/540dd33e828461916c11
    func camelize() -> String {
        let source = clean(with: " ", allOf: "-", "_")
        if source.characters.contains(" ") {
            let first = source.substring(to: source.characters.index(source.startIndex, offsetBy: 1))
            let cammel = NSString(format: "%@", (source as NSString).capitalized.replacingOccurrences(of: " ", with: "", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercased.substring(to: source.characters.index(source.startIndex, offsetBy: 1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    func capitalize() -> String {
        return capitalized
    }
    
    func contains(_ substring: String) -> Bool {
        return range(of: substring) != nil
    }
    
    func chompLeft(_ prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
                return self[startIndex..<prefixRange.lowerBound]
            } else {
                return self[prefixRange.upperBound..<endIndex]
            }
        }
        return self
    }
    
    func chompRight(_ suffix: String) -> String {
        if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
                return self[startIndex..<suffixRange.lowerBound]
            } else {
                return self[suffixRange.upperBound..<endIndex]
            }
        }
        return self
    }
    
    func collapseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
    
    func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count-1
    }
    
    func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    func ensureLeft(_ prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    func ensureRight(_ suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    func indexOf(_ substring: String) -> Int? {
        if let range = range(of: substring) {
            return characters.distance(from: startIndex, to: range.lowerBound)
        }
        return nil
    }
    
    func isAlpha() -> Bool {
        for chr in characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = CharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").length == 0
    }
    
    func isEmpty() -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length == 0
    }
    
    func join<S: Sequence>(_ elements: S) -> String {
        return elements.map{String(describing: $0)}.joined(separator: self)
    }
    
    func latinize() -> String {
        return self.folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    func lines() -> [String] {
        return self.components(separatedBy: CharacterSet.newlines)
    }
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func pad(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self, string.times(n)])
    }
    
    func padLeft(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self])
    }
    
    func padRight(_ n: Int, _ string: String = " ") -> String {
        return "".join([self, string.times(n)])
    }
    
    func slugify(withSeparator separator: Character = "-") -> String {
        let slugCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(separator)")
        return latinize().lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter { $0 != "" }
            .joined(separator: String(separator))
    }
    
    func split(_ separator: Character) -> [String] {
        return characters.split{$0 == separator}.map(String.init)
    }
    
    func startsWith(_ prefix: String) -> Bool {
        return hasPrefix(prefix)
    }
    
    
    func times(_ n: Int) -> String {
        return (0..<n).reduce("") { $0.0 + self }
    }
    
    func toFloat() -> Float? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    
    func toBool() -> Bool? {
        let trimmed = self.trimmed().lowercased()
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        return dateFormatter(format).date(from: self)
    }
    
    func toDateTime(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return toDate(format)
    }
    
    func trimmedLeft() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) {
            return self[range.lowerBound..<endIndex]
        }
        return self
    }
    
    func trimmedRight() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted, options: NSString.CompareOptions.backwards) {
            return self[startIndex..<range.upperBound]
        }
        return self
    }
    
    func replace(string:String, replacement:String) -> String {
        do{
             return try self.stringByReplacingWithRegex(regexString: string as NSString, withString: replacement as NSString) as String
        }
        catch{
             return ""
        }
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }

    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    subscript(r: Range<Int>) -> String {
        get {
            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
            return self[startIndex..<endIndex]
        }
    }
    
    func substring(_ startIndex: Int, length: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self[start..<end]
    }
    
    subscript(i: Int) -> Character {
        get {
            let index = self.characters.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    // Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) != nil
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(_ matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
    // Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) == nil
    }
    
    // Returns true if the string represents a proper numeric value.
    // This method uses the device's current locale setting to determine
    // which decimal separator it will accept.
    func isNumeric() -> Bool
    {
        let scanner = Scanner(string: self)
        
        // A newly-created scanner has no locale by default.
        // We'll set our scanner's locale to the user's locale
        // so that it recognizes the decimal separator that
        // the user expects (for example, in North America,
        // "." is the decimal separator, while in many parts
        // of Europe, "," is used).
        scanner.locale = Locale.current
        
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
}


//For String

private enum ThreadLocalIdentifier {
    case dateFormatter(String)
    
    case defaultNumberFormatter
    case localeNumberFormatter(Locale)
    
    var objcDictKey: String {
        switch self {
        case .dateFormatter(let format):
            return "SS\(self)\(format)"
        case .localeNumberFormatter(let l):
            return "SS\(self)\(l.identifier)"
        default:
            return "SS\(self)"
        }
    }
}

private func threadLocalInstance<T: AnyObject>(_ identifier: ThreadLocalIdentifier, initialValue: @autoclosure () -> T) -> T {
    let storage = Thread.current.threadDictionary
    let k = identifier.objcDictKey
    
    let instance: T = storage[k] as? T ?? initialValue()
    if storage[k] == nil {
        storage[k] = instance
    }
    
    return instance
}

private func dateFormatter(_ format: String) -> DateFormatter {
    return threadLocalInstance(.dateFormatter(format), initialValue: {
        let df = DateFormatter()
        df.dateFormat = format
        return df
    }())
}

private func defaultNumberFormatter() -> NumberFormatter {
    return threadLocalInstance(.defaultNumberFormatter, initialValue: NumberFormatter())
}

private func localeNumberFormatter(_ locale: Locale) -> NumberFormatter {
    return threadLocalInstance(.localeNumberFormatter(locale), initialValue: {
        let nf = NumberFormatter()
        nf.locale = locale
        return nf
    }())
}


