//
//  PasscodeRepositoryType.swift
//  CloudFileManager
//
//  Created by MacMini-2 on 28/06/17.
//  Copyright © 2016 WMT. All rights reserved.
//

import Foundation

public protocol PasscodeRepositoryType {
    
    var hasPasscode: Bool {get}
    var passcode: [String]? {get}
    
    func savePasscode(passcode: [String])
    func deletePasscode()
}
