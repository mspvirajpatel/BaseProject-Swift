//
//  PasscodeLockConfigurationType.swift
//  CloudFileManager
//
//  Created by Viraj Patel on 28/06/17.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import Foundation

public protocol PasscodeLockConfigurationType {
    
    var repository: PasscodeRepositoryType {get}
    var passcodeLength: Int {get}
    var isTouchIDAllowed: Bool {get set}
    var shouldRequestTouchIDImmediately: Bool {get}
    var maximumInccorectPasscodeAttempts: Int {get}
}
