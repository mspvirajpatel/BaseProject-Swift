//
//  PasscodeLockStateType.swift
//  CloudFileManager
//
//  Created by Viraj Patel on 28/06/17.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import Foundation

public protocol PasscodeLockStateType {
    
    var title: String {get}
    var description: String {get}
    var isCancellableAction: Bool {get}
    var isTouchIDAllowed: Bool {get}
    
    mutating func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType)
}
