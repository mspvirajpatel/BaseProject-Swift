//
//  ExtensionUtility.swift
//  WMTSwiftDemo
//
//  Created by Viraj Patel on 12/09/16.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import UIKit


private var activityIndicatorAssociationKey: UInt8 = 0

extension UIView {
    var activityIndicat: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showActivityIndicator() {
        
        if (self.activityIndicat == nil) {
            self.activityIndicat = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            self.activityIndicat.hidesWhenStopped = true
            self.activityIndicat.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            self.activityIndicat.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            self.activityIndicat.center = CGPoint.init(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            self.activityIndicat.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            
            self.activityIndicat.isUserInteractionEnabled = false
            self.activityIndicat.color = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
            OperationQueue.main.addOperation({
                self.addSubview(self.activityIndicat)
                self.activityIndicat.startAnimating()
            })
        }
    }
    
    
    func hideActivityIndicator() {
        OperationQueue.main.addOperation({
            if self.activityIndicat != nil
            {
                self.activityIndicat.stopAnimating()
            }
        })
    }
}


fileprivate var _topSeparatorTag = 5432 // choose unused tag

extension UITableViewCell {
    func shake(duration: CFTimeInterval = 0.3, pathLength: CGFloat = 15) {
        let position: CGPoint = self.center
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: position.x, y: position.y))
        path.addLine(to: CGPoint(x:position.x-pathLength, y: position.y))
        path.addLine(to: CGPoint(x:position.x+pathLength, y:position.y))
        path.addLine(to: CGPoint(x:position.x-pathLength, y:position.y))
        path.addLine(to: CGPoint(x:position.x+pathLength, y:position.y))
        path.addLine(to: CGPoint(x:position.x, y:position.y))
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        
        positionAnimation.path = path.cgPath
        positionAnimation.duration = duration
        positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        CATransaction.begin()
        self.layer.add(positionAnimation, forKey: nil)
        CATransaction.commit()
    }
}

extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}

extension UIImage {
    func toData() -> Data? {
        return UIImagePNGRepresentation(self) ?? nil
    }
    
    
    // MARK: - Public functions
    
    public func resized(toHeight points: CGFloat) -> UIImage {
        let height = points * scale
        let ratio = height / size.height
        let width = size.width * ratio
        let newSize = CGSize(width: width, height: height)
        return resized(toSize: newSize, withQuality: .high)
    }
    
    public func resized(toWidth points: CGFloat) -> UIImage {
        let width = points * scale
        let ratio = width / size.width
        let height = size.height * ratio
        let newSize = CGSize(width: width, height: height)
        return resized(toSize: newSize, withQuality: .high)
    }
    
    
    
    // MARK: - Private functions
    
    private func resized(toSize newSize: CGSize, withQuality quality: CGInterpolationQuality) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? UIImage()
    }
}

extension UIFont {
    class func titleFont() -> UIFont {
        return UIFont(name: "GeezaPro-Bold", size: 17)!
    }
    
    class func priceListBoldFont() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Semibold", size: 23)!
    }
    
    class func priceListThinFont() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Regular", size: 14)!
    }
    
    class func priceListBoldFontSmall() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Semibold", size: 13)!
    }
    
    class func imageDescriptionBig() -> UIFont {
        return UIFont(name: FontStyle.bold, size: currentDevice.isIpad ? 18.0 : 16.0)!
    }
    
    class func imageDescriptionSmall() -> UIFont {
        return UIFont(name: FontStyle.regular, size: currentDevice.isIpad ? 16.0 : 14.0)!
    }
}


extension Data {
    func toImage() -> UIImage {
        return UIImage(data: self) ?? UIImage()
    }
}

extension UITableView {
    
    fileprivate var _topSeparator: UIView? {
        return superview?.subviews.filter { $0.tag == _topSeparatorTag }.first
    }
    
    override open var contentOffset: CGPoint {
        didSet {
            guard let topSeparator = _topSeparator else { return }
            
            let shouldDisplaySeparator = contentOffset.y > 0
            
            if shouldDisplaySeparator && topSeparator.alpha == 0 {
                UIView.animate(withDuration: 0.15, animations: {
                    topSeparator.alpha = 1
                })
            } else if !shouldDisplaySeparator && topSeparator.alpha == 1 {
                UIView.animate(withDuration: 0.25, animations: {
                    topSeparator.alpha = 0
                })
            }
        }
    }
    
    // Adds a separator to the superview at the top of the table
    // This needs the separator insets to be set on the tableView, not the cell itself
    func showTopSeparatorWhenScrolled(_ enabled: Bool) {
        if enabled {
            if _topSeparator == nil {
                let topSeparator = UIView()
                topSeparator.backgroundColor = separatorColor?.withAlphaComponent(0.85)
                
                // because while scrolling, the other separators seem lighter
                topSeparator.translatesAutoresizingMaskIntoConstraints = false
                
                superview?.addSubview(topSeparator)
                
                topSeparator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: separatorInset.left).isActive = true
                topSeparator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: separatorInset.right).isActive = true
                topSeparator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                topSeparator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                
                topSeparator.tag = _topSeparatorTag
                topSeparator.alpha = 0
                
                superview?.setNeedsLayout()
            }
        } else {
            _topSeparator?.removeFromSuperview()
        }
    }
    
    func removeSeparatorsOfEmptyCells() {
        tableFooterView = UIView(frame: .zero)
    }
}


// MARK: - UIAlertController Extension -

public extension UIAlertController {
    public func kam_show(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        var forefrontVC = rootVC
        while let presentedVC = forefrontVC.presentedViewController {
            forefrontVC = presentedVC
        }
        forefrontVC.present(self, animated: animated, completion: completionHandler)
    }
}


extension UIGestureRecognizerState{
    
    func toString()->String{
        switch self{
        case .began:
            return "Began"
        case .cancelled:
            return "Cancelled"
        case .changed:
            return "Changed"
        case .ended:
            return "Ended"
        case .failed:
            return "Failed"
        case .possible:
            return "invaid value"
        }
    }
}

// MARK: - UIFont Extension -

public extension UIFont {
    
    public convenience init(fontString: String) {
        
        var stringArray : Array = fontString.components(separatedBy: ";")
        self.init(name: stringArray[0], size:stringArray[1].stringToFloat())!
        
    }
}

// MARK: - UIViewController Extension -
private var didKDVCInitialized = false

private var interactiveNavigationBarHiddenAssociationKey: UInt8 = 0

extension UIViewController {
    
    @IBInspectable public var interactiveNavigationBarHidden: Bool {
        get {
            var associateValue = objc_getAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey)
            if associateValue == nil {
                associateValue = false
            }
            return associateValue as! Bool;
        }
        set {
            objc_setAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    override open static func initialize() {
        if !didKDVCInitialized {
            replaceInteractiveMethods()
            didKDVCInitialized = true
        }
    }
    
    fileprivate static func replaceInteractiveMethods() {
        method_exchangeImplementations(
            class_getInstanceMethod(self, #selector(UIViewController.viewWillAppear(_:))),
            class_getInstanceMethod(self, #selector(UIViewController.KD_interactiveViewWillAppear(_:))))
    }
    
    func KD_interactiveViewWillAppear(_ animated: Bool) {
        KD_interactiveViewWillAppear(animated)
        navigationController?.setNavigationBarHidden(interactiveNavigationBarHidden, animated: animated)
    }
    
}


extension Double {
    var second:  TimeInterval { return self }
    var seconds: TimeInterval { return self }
    var minute:  TimeInterval { return self * 60 }
    var minutes: TimeInterval { return self * 60 }
    var hour:    TimeInterval { return self * 3600 }
    var hours:   TimeInterval { return self * 3600 }
}

//Use
//NSTimer.after(1.minute) {
//    println("Are you still here?")
//}
//
//// Repeating an action
//NSTimer.every(0.7.seconds) {
//    statusItem.blink()
//}
//
//// Pass a method reference instead of a closure
//NSTimer.every(30.seconds, align)
//
//// Make a timer object without scheduling
//let timer = NSTimer.new(every: 1.second) {
//    println(self.status)
//}


// MARK: - Character Extension -

public extension Character {
    /// Return true if character is emoji.
    public var isEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        guard let scalarValue = String(self).unicodeScalars.first?.value else {
            return false
        }
        switch scalarValue {
        case 0x3030, 0x00AE, 0x00A9,// Special Characters
        0x1D000...0x1F77F, // Emoticons
        0x2100...0x27BF, // Misc symbols and Dingbats
        0xFE00...0xFE0F, // Variation Selectors
        0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
            return true
        default:
            return false
        }
    }
    
    /// Return true if character is number.
    public var isNumber: Bool {
        return Int(String(self)) != nil
    }
    
    /// Return integer from character (if applicable).
    public var toInt: Int? {
        return Int(String(self))
    }
    
    /// Return string from character.
    public var toString: String {
        return String(self)
    }
}



// MARK: - UIImageView Extension -

extension UIImageView{
    func roundImage()
    {
        //height and width should be the same
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
}



// MARK: - Button Extension -

public extension UIButton {
    
    //  Apply corner radius
    public func applyCornerRadius(_ mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    //  Set background color for state
    public func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    //  Set title text for all state
    public func textForAllState(_ titleText : String) {
        self.setTitle(titleText, for: UIControlState())
        self.setTitle(titleText, for: .selected)
        self.setTitle(titleText, for: .highlighted)
        self.setTitle(titleText, for: .disabled)
    }
    
    //  Set title text for only normal state
    public func textForNormal(_ titleText : String) {
        self.setTitle(titleText, for: UIControlState())
    }
    
    //  Set title text for only selected state
    public func textForSelected(_ titleText : String) {
        self.setTitle(titleText, for: .selected)
    }
    
    //  Set title text for only highlight state
    public func textForHighlighted(_ titleText : String) {
        self.setTitle(titleText, for: .highlighted)
    }
    
    //  Set image for all state
    public func imageForAllState(_ image : UIImage) {
        self.setImage(image, for: UIControlState())
        self.setImage(image, for: .selected)
        self.setImage(image, for: .highlighted)
        self.setImage(image, for: .disabled)
    }
    
    //  Set image for only normal state
    public func imageForNormal(_ image : UIImage) {
        self.setImage(image, for: UIControlState())
    }
    
    //  Set image for only selected state
    public func imageForSelected(_ image : UIImage) {
        self.setImage(image, for: .selected)
    }
    
    //  Set image for only highlighted state
    public func imageForHighlighted(_ image : UIImage) {
        self.setImage(image, for: .highlighted)
    }
    
    //  Set title color for all state
    public func colorOfTitleLabelForAllState(_ color : UIColor) {
        self.setTitleColor(color, for: UIControlState())
        self.setTitleColor(color, for: .selected)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .disabled)
    }
    
    //  Set title color for normal state
    public func colorOfTitleLabelForNormal(_ color : UIColor) {
        self.setTitleColor(color, for: UIControlState())
    }
    
    //  Set title color for selected state
    public func colorOfTitleLabelForSelected(_ color : UIColor) {
        self.setTitleColor(color, for: .selected)
    }
    
    //  Set title color for highkighted state
    public func colorForHighlighted(_ color : UIColor) {
        self.setTitleColor(color, for: .highlighted)
    }
    
    //  Set image behind the text in button
    public func setImageBehindTextWithCenterAlignment(_ imageWidth : CGFloat, buttonWidth : CGFloat, space : CGFloat) {
        let titleLabelWidth:CGFloat = 50.0
        let buttonMiddlePoint = buttonWidth/2
        let fullLenght = titleLabelWidth + space + imageWidth
        
        let imageInset = buttonMiddlePoint + fullLenght/2 - imageWidth + space
        let buttonInset = buttonMiddlePoint - fullLenght/2 - imageWidth
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, buttonInset, 0, 0)
    }
    
    //  Set image behind text in left alignment
    public func setImageBehindTextWithLeftAlignment(_ imageWidth : CGFloat, buttonWidth : CGFloat) {
        let titleLabelWidth:CGFloat = 40.0
        let fullLenght = titleLabelWidth + 5 + imageWidth
        
        let imageInset = fullLenght - imageWidth + 5
        let buttonInset = CGFloat(-10.0)
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, buttonInset, 0, 0)
    }
    
    //  Set image behind text in right alignment
    public func setImageOnRightAndTitleOnLeft(_ imageWidth : CGFloat, buttonWidth : CGFloat)  {
        let imageInset = CGFloat(buttonWidth - imageWidth - 10)
        
        let buttonInset = CGFloat(-10.0)
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, buttonInset, 0, 0)
    }
}

// MARK:  - Mirro Extension -

public extension Mirror
{
    public func proparty() -> [String]
    {
        var arrPropary : [String] = []
        
        for item in self.children
        {
            arrPropary.append(item.label!)
        }
        return arrPropary
    }
}


// MARK:  - Double Extension -

public extension Double
{
//    mutating func roundOf() -> Double
//    {
//        return Double(round(self))
//    }
//    
//    mutating func roundTo2f() -> Double
//    {
//        return Double(round(100*self)/100)
//    }
//    
//    func roundTo3f() -> Double
//    {
//        return Double(round(1000*self)/1000)
//    }
//    
//    func roundTo4f() -> Double
//    {
//        return Double(round(10000*self)/10000)
//    }
//    
    func roundToNf(_ n : Int) -> NSString
    {
        return NSString(format: "%.\(n)f" as NSString, self)
    }
}


// MARK: - Int Extension -

extension Int{
    var isEven:Bool     {return (self % 2 == 0)}
    var isOdd:Bool      {return (self % 2 != 0)}
    var isPositive:Bool {return (self >= 0)}
    var isNegative:Bool {return (self < 0)}
    var toDouble:Double {return Double(self)}
    var toFloat:Float   {return Float(self)}
    
    var digits:Int {//this only works in bound of LONG_MAX 2147483647, the maximum value of int
        if(self == 0)
        {
            return 1
        }
        else if(Int(fabs(Double(self))) <= LONG_MAX)
        {
            return Int(log10(fabs(Double(self)))) + 1
        }
        else
        {
            return -1; //out of bound
        }
    }
}




extension Data {
    var stringValue: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    var base64EncodedString: String? {
        return self.base64EncodedString(options: .lineLength64Characters)
    }
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
    
}


/**
 Description: the toppest view controller of presenting view controller
 How to use: UIApplication.topMostViewController
 Where to use: controllers are not complex
 */

extension UIApplication {
    
    var topMostViewController: UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    /// App has more than one window and just want to get topMostViewController of the AppDelegate window.
    var appDelegateWindowTopMostViewController: UIViewController? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        var topController = delegate?.window?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}


/**
 Description: the toppest view controller of presenting view controller
 How to use:  UIApplication.sharedApplication().keyWindow?.rootViewController?.topMostViewController
 Where to use: There are lots of kinds of controllers (UINavigationControllers, UITabbarControllers, UIViewController)
 */

extension UIViewController {
    var topMostViewController: UIViewController? {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController
        }
            // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController
                    }
                }
            }
            return self
        }
    }
}

extension UITabBarController {
    
    override var topMostViewController: UIViewController? {
        return self.selectedViewController?.topMostViewController
    }
    
    var topVisibleViewController: UIViewController? {
        var top = selectedViewController
        while top?.presentedViewController != nil {
            top = top?.presentedViewController
        }
        return top
    }
}

extension UINavigationController {
    override var topMostViewController: UIViewController? {
        return self.visibleViewController?.topMostViewController
    }
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

// MARK: - UIImage Extension -

extension UIImage {
    func croppedImage(_ bound : CGRect) -> UIImage
    {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * self.scale, y: bound.origin.y * self.scale, width: bound.size.width * self.scale, height: bound.size.height * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage : UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppedImage;
    }
    
    
    public func normalizeBitmapInfo(_ bI: CGBitmapInfo) -> UInt32 {
        var alphaInfo: UInt32 = bI.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        if alphaInfo == CGImageAlphaInfo.last.rawValue {
            alphaInfo =  CGImageAlphaInfo.premultipliedLast.rawValue
        }
        
        if alphaInfo == CGImageAlphaInfo.first.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        }
        
        var newBI: UInt32 = bI.rawValue & ~CGBitmapInfo.alphaInfoMask.rawValue;
        
        newBI |= alphaInfo;
        
        return newBI
    }
    
    func maskWithColor(_ color: UIColor) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        bitmapContext?.clip(to: bounds, mask: maskImage!)
        bitmapContext?.setFillColor(color.cgColor)
        bitmapContext?.fill(bounds)
        
        //is it nil?
        if let cImage = bitmapContext?.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            
            return coloredImage
            
        } else {
            return nil
        }
    }
}


