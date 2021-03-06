//
//  PasscodeLockConfiguration.swift
//  CloudFileManager
//
//  Created by Viraj Patel on 28/06/17.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import Foundation

struct PasscodeLockConfiguration: PasscodeLockConfigurationType {
    
    let repository: PasscodeRepositoryType
    let passcodeLength = 4
    var isTouchIDAllowed = true
    let shouldRequestTouchIDImmediately = true
    let maximumInccorectPasscodeAttempts = -1
    
    init(repository: PasscodeRepositoryType) {
        
        self.repository = repository
    }
    
    init() {
        
        self.repository = UserDefaultsPasscodeRepository()
    }
}
