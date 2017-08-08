//
//  PasscodeLock.swift
//  CloudFileManager
//
//  Created by Viraj Patel on 28/06/17.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import Foundation
import LocalAuthentication

public class PasscodeLock: PasscodeLockType {
    
    public weak var delegate: PasscodeLockTypeDelegate?
    public let configuration: PasscodeLockConfigurationType
    
    public var repository: PasscodeRepositoryType {
        return configuration.repository
    }
    
    public var state: PasscodeLockStateType {
        return lockState
    }
    
    public var isTouchIDAllowed: Bool {
        return isTouchIDEnabled() && configuration.isTouchIDAllowed && lockState.isTouchIDAllowed
    }
    
    private var lockState: PasscodeLockStateType
    private lazy var passcode = [String]()
    
    public init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType) {
        
        precondition(configuration.passcodeLength > 0, "Passcode length sould be greather than zero.")
        
        self.lockState = state
        self.configuration = configuration
    }
    
    public func addSign(sign: String) {
        
        passcode.append(sign)
        delegate?.passcodeLock(lock: self, addedSignAtIndex: passcode.count - 1)
        
        if passcode.count >= configuration.passcodeLength {
            
            lockState.acceptPasscode(passcode: passcode, fromLock: self)
            passcode.removeAll(keepingCapacity: true)
        }
    }
    
    public func removeSign() {
        
        guard passcode.count > 0 else { return }
        
        passcode.removeLast()
        delegate?.passcodeLock(lock: self, removedSignAtIndex: passcode.count)
    }
    
    public func changeStateTo(state: PasscodeLockStateType) {
        
        lockState = state
        delegate?.passcodeLockDidChangeState(lock: self)
    }
    
    public func authenticateWithBiometrics() {
        
        guard isTouchIDAllowed else { return }
        
        let context = LAContext()
        let reason = "PasscodeLockTouchIDReason".localize()

        context.localizedFallbackTitle = "PasscodeLockTouchIDButton".localize()
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            success, error in
            
            self.handleTouchIDResult(success: success)
        }
    }
    
    private func handleTouchIDResult(success: Bool) {
        
        DispatchQueue.main.async {
            if success {
                
                self.delegate?.passcodeLockDidSucceed(lock: self)
            }
        }
    }
    
    private func isTouchIDEnabled() -> Bool {
        
        let context = LAContext()
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
