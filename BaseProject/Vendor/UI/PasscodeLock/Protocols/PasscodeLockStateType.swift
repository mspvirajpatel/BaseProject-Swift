//
//  PasscodeLockStateType.swift
//  CloudFileManager
//
//  Created by MacMini-2 on 28/06/17.
//  Copyright © 2016 WMT. All rights reserved.
//

import Foundation

public protocol PasscodeLockStateType {
    
    var title: String {get}
    var description: String {get}
    var isCancellableAction: Bool {get}
    var isTouchIDAllowed: Bool {get}
    
    mutating func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType)
}
