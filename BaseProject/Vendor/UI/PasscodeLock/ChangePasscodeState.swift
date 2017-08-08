

import Foundation

struct ChangePasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    init() {
        
        title = "PasscodeLockChangeTitle".localize()
        description = "PasscodeLockChangeDescription".localize()
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        guard let currentPasscode = lock.repository.passcode else {
            return
        }
        
        if passcode == currentPasscode {
            
            let nextState = SetPasscodeState()
            
            lock.changeStateTo(state: nextState)
            
        } else {
            
            lock.delegate?.passcodeLockDidFail(lock: lock)
        }
    }
}
