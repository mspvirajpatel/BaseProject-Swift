//
//  AppUtility.swift
//  ViewControllerDemo
//
//  Created by Viraj Patel on 24/08/15.
//  Copyright (c) 2015 Viraj Patel. All rights reserved.
//

import UIKit
import Kingfisher

class AppUtility: NSObject {
   
    //  MARK: - Network Connection Methods
    
    class func isNetworkAvailableWithBlock(_ completion: @escaping (_ wasSuccessful: Bool) -> Void) {
    
        NotificationManager.sharedInstance.isNetworkAvailableWithBlock { (wasSuccessful) in
            completion(wasSuccessful)
        }
    }

    class func clearImageData()
    {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    //  MARK: - User Defaults Methods
    
    class func getUserDefaultsObjectForKey(_ key: String)->AnyObject{
        let object: AnyObject? = UserDefaults.standard.object(forKey: key) as AnyObject?
        return object!
    }
    
    class func setUserDefaultsObject(_ object: AnyObject, forKey key: String) {
        UserDefaults.standard.set(object, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    class func clearUserDefaultsForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func clearUserDefaults(){
        let appDomain: String = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
    
    class func getDocumentDirectoryPath() -> String
    {
        let arrPaths : NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        return arrPaths[0] as! String
    }
    class func stringByPathComponet(fileName : String , Path : String) -> String
    {
        var tmpPath : NSString = Path as NSString
        tmpPath = tmpPath.appendingPathComponent(fileName) as NSString
        return tmpPath as String
    }
    
    //  MARK: - UIDevice Methods
    
    class func getDeviceIdentifier()->String{
        let deviceUUID: String = UIDevice.current.identifierForVendor!.uuidString
        return deviceUUID
    }
    
    //  MARK: - Misc Methods
    
    class func getAppDelegate()->AppDelegate{
        let appDelegate: UIApplicationDelegate = UIApplication.shared.delegate!
        return appDelegate as! AppDelegate
    }
    
    //  MARK: - Time-Date Methods
    
    class func convertDateToLocalTime(_ iDate: Date) -> Date {
        let timeZone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: Int = timeZone.secondsFromGMT(for: iDate)
        return Date(timeInterval: TimeInterval(seconds), since: iDate)
    }
    
    class func convertDateToGlobalTime(_ iDate: Date) -> Date {
        let timeZone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: Int = -timeZone.secondsFromGMT(for: iDate)
        return Date(timeInterval: TimeInterval(seconds), since: iDate)
    }
    
    class func getCurrentDateInFormat(_ format: String)->String{
        
        let usLocale: Locale = Locale(identifier: "en_US")
        
        let timeFormatter: DateFormatter = DateFormatter()
        timeFormatter.dateFormat = format
        
        timeFormatter.timeZone = TimeZone.autoupdatingCurrent
        timeFormatter.locale = usLocale
        
        let date: Date = Date()
        let stringFromDate: String = timeFormatter.string(from: date)
        
        return stringFromDate
    }
    
    class func getDate(_ date: Date, inFormat format: String) -> String {
        
        let usLocale: Locale = Locale(identifier: "en_US")
        let timeFormatter: DateFormatter = DateFormatter()
        
        timeFormatter.dateFormat = format
        timeFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        timeFormatter.locale = usLocale
        
        let stringFromDate: String = timeFormatter.string(from: date)
        
        return stringFromDate
    }
    
    
    class func convertStringDateFromFormat(_ inputFormat:String, toFormat outputFormat:String, fromString dateString:String)->String{
        
        let usLocale: Locale = Locale(identifier: "en_US")
        
        var dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = usLocale
        dateFormatter.dateFormat = inputFormat
        
        dateFormatter = DateFormatter()
        let date: Date = dateFormatter.date(from: dateString)!
        
        dateFormatter.locale = usLocale
        dateFormatter.dateFormat = outputFormat
        
        let resultedDateString: String = dateFormatter.string(from: date)
        
        return resultedDateString
    }
    
    class func getTimeStampForCurrentTime()->String{
        let timestampNumber: NSNumber = NSNumber(value: (Date().timeIntervalSince1970) * 1000 as Double)
        return timestampNumber.stringValue
    }
    
    class func getTimeStampFromDate(_ iDate: Date) -> String {
        let timestamp: String = String(iDate.timeIntervalSince1970)
        return timestamp
    }
    
    class func getCurrentTimeStampInGMTFormat() -> String {
        return AppUtility.getTimeStampFromDate(AppUtility.convertDateToGlobalTime(Date()))
    }
    
    //  MARK: - GCD Methods
    
    class func executeTaskAfterDelay(_ delay: CGFloat, completion completionBlock: @escaping () -> Void)
    {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { 
            completionBlock()
        }
    }
    
    class func executeTaskInMainThreadAfterDelay(_ delay: CGFloat, completion completionBlock: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            completionBlock()
        })
    }
    
    class func executeTaskInGlobalQueueWithCompletion(_ completionBlock: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            completionBlock()
        })
    }
    
    class func executeTaskInMainQueueWithCompletion(_ completionBlock: @escaping () -> Void) {
        DispatchQueue.main.async(execute: {() -> Void in
            completionBlock()
        })
    }
    
    class func executeTaskInGlobalQueueWithSyncCompletion(_ completionBlock: () -> Void) {
        DispatchQueue.global(qos: .default).sync(execute: {() -> Void in
            completionBlock()
        })
    }
    
    class func executeTaskInMainQueueWithSyncCompletion(_ completionBlock: () -> Void) {
        DispatchQueue.main.sync(execute: {() -> Void in
            completionBlock()
        })
    }
    
    //  MARK: - Data Validation Methods
    
    class func isValidEmail(_ checkString: String)->Bool{
        
        //let stricterFilter: Bool = false
        
        //let stricterFilterString: String = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let emailRegex: String = laxString
        
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: checkString)
    }
    
    class func isValidPhone(_ phoneNumber: String) -> Bool {
        let phoneRegex: String = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@",phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    class func isValidURL(_ candidate: String) -> Bool {
        let urlRegEx: String = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@",urlRegEx)
        return urlTest.evaluate(with: candidate)
    }
    
    class func isTextFieldBlank(_ textField : UITextField) -> Bool    {
        return (textField.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
    }
    
    class func validateMobileNo(_ mobileNo : String) -> Bool    {
        return mobileNo.characters.count == 10 ? true : false
    }
    
    func validateCharCount(_ name: String,minLimit : Int,maxLimit : Int) -> Bool    {
        // check the name is between 4 and 16 characters
        if !(minLimit...maxLimit ~= name.characters.count) {
            return false
        }
        
        return true
    }
    
    func isRunningSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
        
    }
    
     ///Change file size
    
//    myImageView.image =  ResizeImage(myImageView.image!, targetSize: CGSizeMake(600.0, 450.0))
//    
//    let imageData = UIImageJPEGRepresentation(myImageView.image!,0.50)
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // MARK: - Validation
 
    
    class func validateEmailWithString(email: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    class func validateMobileNo(mobileNo : String) -> Bool
    {
        return mobileNo.characters.count == 10 ? true : false
        //        let phoneRegex = "[0-9]{10}$"
        //        let phoneTest =  NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        //        return phoneTest.evaluateWithObject(phoneRegex)
    }
    class func isValidEmail(checkString: String)->Bool{
        
        //let stricterFilter: Bool = false
        
        //let stricterFilterString: String = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let emailRegex: String = laxString
        
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: checkString)
    }
    
    class func isValidPhone(phoneNumber: String) -> Bool {
        let phoneRegex: String = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@",phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    class func isValidURL(candidate: String) -> Bool {
        let urlRegEx: String = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@",urlRegEx)
        return urlTest.evaluate(with: candidate)
    }
    
    class func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                // something failed
                return nil
        }
        return freeSize.int64Value
    }
    
    class func deviceTotalSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemSize] as? NSNumber
            else {
                // something failed
                return nil
        }
        return freeSize.int64Value
    }
    
    public struct ByteStringOption : OptionSet{
        
        public let rawValue : Int
        
        static let Number = ByteStringOption(rawValue: 1<<0)
        static let Unit = ByteStringOption(rawValue: 1<<1)
        
        public init(rawValue:Int){
            
            self.rawValue = rawValue
        }
    }
    
    
    
    class func stringFromByte(byte:Int64?, displayOptions:ByteStringOption) -> String{
        
        let byteFormatter = ByteCountFormatter()
        
        if let byt = byte{
            
            byteFormatter.countStyle = .decimal
            byteFormatter.includesCount = false
            byteFormatter.includesUnit = false
            
            if displayOptions.contains(.Number){
                
                byteFormatter.includesCount = true
            }
            
            if displayOptions.contains(.Unit){
                
                byteFormatter.includesUnit = true
            }
            
            return byteFormatter.string(fromByteCount: byt)
        }
        
        return "Unkonw"
        
    }
    
    class func documentPath() -> String{
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return documentsPath
    }
    
    class func imageWithBottomShadow(size:CGSize, imageColor:UIColor, shadowColor:UIColor, shadowHeight:CGFloat) -> UIImage{
        
        let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = CGRect(x:0 , y: size.height - shadowHeight, width: size.width, height: shadowHeight)
        shadowLayer.backgroundColor = shadowColor.cgColor
        view.backgroundColor = imageColor
        view.layer.addSublayer(shadowLayer)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }

}
