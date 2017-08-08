//
//  Constants.swift
//  ViewControllerDemo
//
//  Created by Viraj Patel on 27/06/16.
//  Copyright @ 2017 Viraj Patel. All rights reserved.
//

import Foundation
import UIKit

//  MARK: - System Oriented Constants -

struct SystemConstants {
    
    static let showLayoutArea = true
    static let hideLayoutArea = false
    static let showVersionNumber = 1
    
    static let IS_IPAD = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    static let IS_DEBUG = false
}

struct General{
    static let textFieldColorAlpha : CGFloat = 0.5
}

//  MARK: - Thired Party Constants -
struct ThiredPartyKey {
    
}


//  MARK: - Server Constants -
struct APIConstant {
    
    //  Main Domain
    static let baseURL = "http://appsdata2.cloudapp.net/"
    
    //  API - Sub Domain
    
    static let spekarList = "/api/speaker_list"
    static let userPhotoList = "image_upload/display_data.php"
    static let uploadPhoto   = "image_upload/image_data.php"
    static let deletePhoto = "image_upload/delete_data.php"
    
    //  Misc
    static let controlRequestKey : String = "ControlRequestKey"
}


//  MARK: - layoutTime Constants -
struct ControlLayout {
    
    static let name : String = "controlName"
    static let borderRadius : CGFloat = 3.0
    
    static let horizontalPadding : CGFloat = 10.0
    static let verticalPadding : CGFloat = 10.0
    
    static let txtBorderWidth : CGFloat = 1.5
    static let txtBorderRadius : CGFloat = 2.5
    static let textFieldHeight : CGFloat = 30.0
    static let textLeftPadding : CGFloat = 10.0
}


//  MARK: - Cell Identifier Constants -
struct CellIdentifire {
    static let defaultCell  = "cell"
    static let leftMenu = "leftMenuCell"
    static let photo = "photoCell"
}

//  MARK: - Info / Error Message Constants -
struct ErrorMessage {
    
    static let noInternet = "⚠️ Internet connection is not available."
    static let noCurrentLocation = "⚠️ Unable to find current location."
    static let noCameraAvailable = "⚠️ Camera is not available in device."
    
}

struct UserDefaultKey
{
    static let KRegisterOtp             = "registerOtp"
    static let KAccessToken             = "token"
    static let KUserId                  = "userId"
    static let KEmailId                 = "emailId"
    static let KPassword                = "password"
    static let KMobileNo                = "mobileNo"
    static let KFirstName               = "firstName"
    static let KpictureUrl              = "pictureUrl"
    static let KIsLinkedIn              = "IsLinkedIn"
    //Firebase
    static let KFirebaseToken     = "FirebaseToken"
}

// MARK: - Device Compatibility
struct currentDevice {
    static let isIphone = (UIDevice.current.model as NSString).isEqual(to: "iPhone") ? true : false
    static let isIpad = (UIDevice.current.model as NSString).isEqual(to: "iPad") ? true : false
    static let isIPod = (UIDevice.current.model as NSString).isEqual(to: "iPod touch") ? true : false
}

