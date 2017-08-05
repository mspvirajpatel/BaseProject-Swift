//
//  NotificationManager.swift
//  ViewControllerDemo
//
//  Created by SamSol on 09/08/16.
//  Copyright © 2016 SamSol. All rights reserved.
//

import Foundation
import SystemConfiguration
import UserNotifications

struct PushNotificationType : OptionSet {
    
    let rawValue: Int
    
    static let InvalidNotificationType = PushNotificationType(rawValue: -1)
    static let HomeNotificationType = PushNotificationType(rawValue: 1)
    static let OtherNotificationType = PushNotificationType(rawValue: 2)
    
}

open class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - Attributes -
    
    var KReloadKeyboard:String = "KReloadKeyboard"
    var KSuccessGoogleLogin:String = "KSuccessGoogleLogin"
    var KunSuccessGoogleLogin:String = "KunSuccessGoogleLogin"
   
   // MARK: - Lifecycle -
    
    static let sharedInstance : NotificationManager = {
        
        let instance = NotificationManager()
        return instance
        
    }()
    
    deinit{
        
    }
    
    // MARK: - Public Interface -
    
    open func isNetworkAvailableWithBlock(_ completion: @escaping (_ wasSuccessful: Bool) -> Void)
    {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            completion(false)
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        completion(isReachable && !needsConnection)
        
    }
    
    
    // MARK: - Internal Helpers -

    open func reloadKeyboard(_ isSet: Bool) {
        
        var userInfo: [String: Bool]? = nil
        
        userInfo = ["user": isSet]
        
        let notification = Notification.init(name: Notification.Name(rawValue: KReloadKeyboard), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    func setSelectedMenuViewType(_ selectedMenuViewType: LeftMenu.RawValue) {
        let appDelegate = AppUtility.getAppDelegate()
        if appDelegate.slidemenuController != nil {
            let mainMenuViewController:LeftMenuController = (appDelegate.slidemenuController?.menuViewController as! LeftMenuController)
            mainMenuViewController.displaySelectedMenuItem(selectedMenuViewType)
            
        }
    }
}
