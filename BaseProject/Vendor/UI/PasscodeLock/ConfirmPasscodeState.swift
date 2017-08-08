

import Foundation

struct ConfirmPasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    private var passcodeToConfirm: [String]
    
    init(passcode: [String]) {
        
        passcodeToConfirm = passcode
        title = "PasscodeLockConfirmTitle".localize()
        description = "PasscodeLockConfirmDescription".localize()
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        if passcode == passcodeToConfirm {
            
            lock.repository.savePasscode(passcode: passcode)
            lock.delegate?.passcodeLockDidSucceed(lock: lock)
        
        } else {
            
            let mismatchTitle = "PasscodeLockMismatchTitle".localize()
            let mismatchDescription = "PasscodeLockMismatchDescription".localize()
            
            let nextState = SetPasscodeState(title: mismatchTitle, description: mismatchDescription)
            
            lock.changeStateTo(state: nextState)
            lock.delegate?.passcodeLockDidFail(lock: lock)
        }
    }
}
