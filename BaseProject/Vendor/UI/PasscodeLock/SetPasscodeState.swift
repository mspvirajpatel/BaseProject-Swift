//
//  SetPasscodeState.swift
//  CloudFileManager
//
//  Created by Viraj Patel on 28/06/17.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import Foundation

struct SetPasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    init(title: String, description: String) {
        
        self.title = title
        self.description = description
    }
    
    init() {
        
        title = "PasscodeLockSetTitle".localize()
        description = "PasscodeLockSetDescription".localize()
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        let nextState = ConfirmPasscodeState(passcode: passcode)
        
        lock.changeStateTo(state: nextState)
    }
}
