//
//  BSLog.swift
//  BaseProjectSwift
//
//  Created by MacMini-2 on 23/11/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Global variables -

/// Use this variable to activate or deactivate the BFLog function. No longer used, see http://stackoverflow.com/a/26891797/4032046 on how to use it now
public var BFLogActive: Bool = false

// MARK: - Global functions -

/**
 Exented NSLog

 - parameter message:  Console message
 - parameter filename: File
 - parameter function: Function name
 - parameter line:     Line number
 */
public func BFLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        var _message = message
        if _message.hasSuffix("\n") == false {
            _message += "\n"
        }
        
        BFLogClass.logString += _message
        
       // let filenameNoExt = NSURL(string: NSString(UTF8String: filename)! as String)!.URLByDeletingPathExtension!.lastPathComponent!
        let log = "(\(function))"
       
        print("\(_message)", terminator: "")
        
        BFLogClass.detailedLogString += log
    #endif
//    var _message = message
//    if _message.hasSuffix("\n") == false {
//        _message += "\n"
//    }
//    
//    BFLogClass.logString += _message
//    
//    let filenameNoExt = NSURL(string: NSString(UTF8String: filename)! as String)!.URLByDeletingPathExtension!.lastPathComponent!
//    let log = "(\(function)) (\(filenameNoExt):\(line) \(_message)"
//    let timestamp = NSDate.dateInformationDescriptionWithInformation(NSDate().dateInformation(), dateSeparator: "-", usFormat: true, nanosecond: true)
//    print("\(timestamp) \(filenameNoExt):\(line) \(function): \(_message)", terminator: "")
//    
//    BFLogClass.detailedLogString += log
    
}

/// Get the log string
public var BFLogString: String {
    #if DEBUG
        return BFLogClass.logString
    #else
        return ""
    #endif
}

/// Get the detailed log string
public var BFDetailedLogString: String {
    #if DEBUG
        return BFLogClass.detailedLogString
    #else
        return ""
    #endif
}

/**
 Clear the log string
 */
public func BFLogClear() {
    #if DEBUG
        BFLogClass.clearLog()
    #endif
}

/// The private BFLogClass created to manage the log strings
public class BFLogClass {
    // MARK: - Variables -
    
    /// The log string
    public static var logString: String = ""
    /// The detailed log string
    public static var detailedLogString: String = ""
    
    // MARK: - Class functions -
    
    /**
     Private, clear the log string
     */
    public static func clearLog() {
        logString = ""
        detailedLogString = ""
    }
}
