//
//  PasscodeLockConfigurationType.swift
//  CloudFileManager
//
//  Created by MacMini-2 on 28/06/17.
//  Copyright © 2016 WMT. All rights reserved.
//

import Foundation

public protocol PasscodeLockConfigurationType {
    
    var repository: PasscodeRepositoryType {get}
    var passcodeLength: Int {get}
    var isTouchIDAllowed: Bool {get set}
    var shouldRequestTouchIDImmediately: Bool {get}
    var maximumInccorectPasscodeAttempts: Int {get}
}
