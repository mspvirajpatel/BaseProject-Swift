//
//  UserDefaultsPasscodeRepository.swift
//  CloudFileManager
//
//  Created by Viraj Patel on 28/06/17.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import Foundation

class UserDefaultsPasscodeRepository: PasscodeRepositoryType {
    
    private let passcodeKey = "passcode.lock.passcode"
    
    private lazy var defaultsValue: UserDefaults = {
        
        return UserDefaults.standard
    }()
    
    var hasPasscode: Bool {
        
        if passcode != nil {
            return true
        }
        
        return false
    }
    
    var passcode: [String]? {
        
        return defaultsValue.value(forKey: passcodeKey) as? [String] ?? nil
    }
    
    func savePasscode(passcode: [String]) {
        
        defaultsValue.set(passcode, forKey: passcodeKey)
        defaultsValue.synchronize()
    }
    
    func deletePasscode() {
        
        defaultsValue.removeObject(forKey: passcodeKey)
        defaultsValue.synchronize()
    }
}
