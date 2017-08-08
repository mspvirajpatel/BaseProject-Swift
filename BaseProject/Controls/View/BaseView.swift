//
//  BaseView.swift
//  ViewControllerDemo
//
//  Created by Viraj Patel on 24/08/15.
//  Copyright (c) 2015 Viraj Patel. All rights reserved.
//

import UIKit


typealias ControlTouchUpInsideEvent = (_ sender : AnyObject?, _ object : AnyObject?) -> ()
typealias TableCellSelectEvent = (_ sender : AnyObject?, _ object : AnyObject?) -> ()

typealias ScrollViewDidScrollEvent = (_ scrollView : UIScrollView?, _ object : AnyObject?) -> ()
typealias TaskFinishedEvent = (_ successFlag : Bool?, _ object : AnyObject?) -> ()
typealias SwitchStateChangedEvent = (_ sender : AnyObject?, _ state : Bool?) -> ()

/**
 This is Base Class of All View which are used in whole application. We need to use this class as superview.
*/
class BaseView: UIView {
    
    // MARK: - Attributes -
    /// Its object of BaseLayout Class for Mack the Constraint
    var baseLayout : AppBaseLayout!
    
    /// Its for set the Backgroudimage in whole application
    var backgroundImageView : BaseImageView!
    
    /// Its for show the Error on View
    var errorMessageLabel : UILabel!
    
    /// Its for shwo activity indicate view when Networking call running
    var progressHUDView : MBProgressHUD!
    
    /// Its matirial design Type Activity loader
    var baseMaterialLoadingIndicator : BaseMaterialLoadingIndicator?
    
    /// Its for Set the Footer of TableView
    var tableFooterView : UIView!
    
    /// Its for Show the Activity Indiacter at Footer of view
    var footerIndicatorView : UIActivityIndicatorView!
    
    /// Its for Trackt current request is running in view or not
    var isLoadedRequest : Bool = false
    
    var layoutSubViewEvent : TaskFinishedEvent!
    
    /// Its for maintaint the multipule API Call queue.
    var operationQueue : OperationQueue!
    
    /// Its for TableView Footer Height
    var tableFooterHeight : CGFloat = 0.0
    
    
    // MARK: - Lifecycle -
    /// Its will set corder radius of Whole Application View's
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = Color.shadow.value {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateShadowPath()
    }
    
    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit{
        print("BaseView Deinit Called")
        self.releaseObject()
    }
    
    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object. This method is need to over ride in every chiled view for memory managment.
     */
    func releaseObject(){
        
        NotificationCenter.default.removeObserver(self)
        
        if baseLayout != nil{
            baseLayout.releaseObject()
            baseLayout.metrics = nil
            baseLayout.viewDictionary = nil
            baseLayout = nil
        }
        
        if backgroundImageView != nil && backgroundImageView.superview != nil{
            backgroundImageView.removeFromSuperview()
            backgroundImageView = nil
        }
        else{
            backgroundImageView = nil
        }
        
        if errorMessageLabel != nil && errorMessageLabel.superview != nil{
            errorMessageLabel.removeFromSuperview()
            errorMessageLabel = nil
        }
        else{
            errorMessageLabel = nil
        }
        
        if progressHUDView != nil && progressHUDView.superview != nil{
            progressHUDView.removeFromSuperview()
            progressHUDView = nil
        }
        else{
            progressHUDView = nil
        }
        
        if tableFooterView != nil && tableFooterView.superview != nil{
            tableFooterView.removeFromSuperview()
            tableFooterView = nil
        }
        else{
            tableFooterView = nil
        }
        
        if footerIndicatorView != nil && footerIndicatorView.superview != nil{
            footerIndicatorView.removeFromSuperview()
            footerIndicatorView = nil
        }else{
            footerIndicatorView = nil
        }
        
        if(operationQueue != nil){
            operationQueue.cancelAllOperations()
        }
        operationQueue = nil
    }
    
    // MARK: - Layout -
    /// This method is used for the Load the Control when initialized.
    func loadViewControls(){
        
        operationQueue = OperationQueue()
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.backgroundColor = Color.appSecondaryBG.value
        self.isExclusiveTouch = true
        self.isMultipleTouchEnabled = true
        self.loadErrorMessageLabel()
        self.layer.masksToBounds = false
        
        self.updateProperties()
        self.updateShadowPath()
        
    }
    
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }
    
    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    /// This method is used called after View iniit, For set the Layout constraint of subView's
    func setViewlayout(){
        
        if(baseLayout == nil){
            baseLayout = AppBaseLayout()
            baseLayout.viewDictionary = ["errorMessageLabel" : errorMessageLabel ]
            
            /*     errorLabel Layout     */
            
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[errorMessageLabel]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            
            self.addConstraints(baseLayout.control_H)
            
            baseLayout.position_Top = NSLayoutConstraint(item: errorMessageLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
            baseLayout.position_Bottom = NSLayoutConstraint(item: errorMessageLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            
            self.addConstraints([baseLayout.position_Top, baseLayout.position_Bottom])
            
            baseLayout.releaseObject()
        }
    }
    
    /// This is method is need to called in chiled view's loadViewControl , if want to show error label. This method will initilize the Error Label
    func loadErrorMessageLabel(){
        
        errorMessageLabel = UILabel(frame: CGRect.zero)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessageLabel.font = UIFont(name: FontStyle.medium, size: 15.0)
        errorMessageLabel.numberOfLines = 0
        
        errorMessageLabel.preferredMaxLayoutWidth = 200
        errorMessageLabel.textAlignment = .center
        
        errorMessageLabel.backgroundColor = UIColor.clear
        errorMessageLabel.textColor = Color.labelErrorText.withAlpha(0.8)
        
        errorMessageLabel.tag = -1
        self.addSubview(errorMessageLabel)
        
        self.displayErrorMessageLabel(nil)
        
    }
    
    /// This method is used to check internet is on or not.
    func handleNetworkCheck(isAvailable : Bool){
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            if isAvailable == true{
                self!.showProgressHUD(viewController: AppUtility.getAppDelegate().window!, title: nil, subtitle: nil)
            }
            else{
                self?.displayBottomToast(message: ErrorMessage.noInternet)
            }
        }
    }
    
    /// This method is used to show the ProgressHud and Activity Indicater.
    func showProgressHUD(viewController from: UIView,title: String?,subtitle: String?)
    {
        progressHUDView = MBProgressHUD(view: from)
        if progressHUDView != nil {
            from.addSubview(self.progressHUDView!)
            
            progressHUDView.labelFont = UIFont(name: FontStyle.medium, size: 15.0)
            progressHUDView.detailsLabelFont = UIFont(name: FontStyle.medium, size: 15.0)
            progressHUDView.margin = 19.0
            progressHUDView.opacity = 0.8
            progressHUDView.isSquare = false
            
            
            progressHUDView.dimBackground = true
            progressHUDView.animationType = MBProgressHUDAnimation.fade;
            
            progressHUDView.color = Color.activityLoaderBG.withAlpha(0.98)
            progressHUDView.activityIndicatorColor = Color.activityLoader.withAlpha(0.6)
            progressHUDView.labelColor = Color.activityText.withAlpha(0.9)
            progressHUDView.detailsLabelColor = Color.activityText.withAlpha(0.9)
        }
        
        
        if let titleSet = title {
            progressHUDView?.labelText = titleSet
        }
        else
        {
            progressHUDView?.labelText = "Loading..."
        }
        progressHUDView?.detailsLabelText = subtitle == nil ? "" : subtitle
        self.progressHUDView?.show(true)
    }
    
    /// This method is Used For Hide The Progress HUD.
    func hideProgressHUD() {
        
        AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
            
            if self == nil{
                return
            }
            
            if(self!.progressHUDView != nil){
                self!.progressHUDView.hide(true)
            }
        }
    }
    
    /**
     This method is used to shpw the matirial design type Progress.
    - parameter viewController progress will show on this controller / View
     */
    func showMetrialProgress(viewController from: UIView)
    {
        if baseMaterialLoadingIndicator == nil {
            baseMaterialLoadingIndicator = BaseMaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            baseMaterialLoadingIndicator?.center = from.center
            from.addSubview(baseMaterialLoadingIndicator!)
            baseMaterialLoadingIndicator?.startAnimating()
        }
    }
    
    /// Its will hide the Metrial Progress
    func hideMetrialProgress() {
        
        if(self.baseMaterialLoadingIndicator != nil){
            self.baseMaterialLoadingIndicator?.stopAnimating()
            super.willRemoveSubview(self.baseMaterialLoadingIndicator!)
            self.baseMaterialLoadingIndicator = nil
        }
    }
    
    /// This method is initialize the Background ImageView in Whole Application
    func loadBackgroundImageViewWithImage(_ image : UIImage?){
        
        if(backgroundImageView == nil){
            
            backgroundImageView = BaseImageView(frame: CGRect.zero)
            
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            backgroundImageView.contentMode = .scaleToFill
            
            self.addSubview(backgroundImageView)
            
            if(baseLayout == nil){
                baseLayout = AppBaseLayout()
            }
            
            baseLayout.expandView(backgroundImageView, insideView: self)
            baseLayout = nil
        }
        
        if(image != nil){
            backgroundImageView.image = image
        }
        
    }
    
    /// It will Show the Footerview at bottom of View with indiacateView
    func loadTableFooterView(){
        
        let screenSize : CGSize = InterfaceUtility.getDeviceScreenSize()
        
        footerIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        tableFooterHeight = footerIndicatorView.frame.size.height + 20.0
        
        tableFooterView = UIView()
        tableFooterView.backgroundColor = UIColor.clear
        
        tableFooterView.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: tableFooterHeight)
        
        let tableHeaderSize : CGSize = tableFooterView.frame.size
        footerIndicatorView.center = CGPoint(x: tableHeaderSize.width/2.0, y: tableHeaderSize.height/2.0)
        
        footerIndicatorView.startAnimating()
        footerIndicatorView.hidesWhenStopped = true
        
        tableFooterView.addSubview(footerIndicatorView)
    }
    
    // MARK: - Public Interface -
    func setTitleLabelWithText(_ title: String, borderColor: UIColor){
        
    }
    
    /**
     This will Display Error message Label on View.
        - parameter errorMessage : if Message Passed Blank than errorLabel Will Hide else if message not blank than error label will show.
    */
    func displayErrorMessageLabel(_ errorMessage : String?){
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            if(self!.errorMessageLabel != nil){
                
                self!.errorMessageLabel.isHidden = true
                self!.errorMessageLabel.text = ""
                
                if(self!.errorMessageLabel.tag == -1){
                    self!.sendSubview(toBack: self!.errorMessageLabel)
                }
                
                if(errorMessage != nil){
                    
                    if(self!.errorMessageLabel.tag == -1){
                        self!.bringSubview(toFront: self!.errorMessageLabel)
                    }
                    
                    self!.errorMessageLabel.isHidden = false
                    self!.errorMessageLabel.text = errorMessage
                    
                }
                self!.errorMessageLabel.layoutSubviews()
            }
        }
    }
    
    /**
     This is will check the TextControl is first in its SuperView
    */
    class func isFirstTextControlInSuperview(_ superview: UIView?, textControl: UIView) -> Bool{
        
        var isFirstTextControl : Bool = true
        
        var textControlIndex : Int = -1
        var viewControlIndex : Int = -1
        
        if(superview != nil){
            
            if((superview?.subviews.contains(textControl))!){
                textControlIndex = superview!.subviews.index(of: textControl)!
            }
            
            for view in (superview?.subviews)! {
                
                if(view.isTextControl() && textControl != view){
                    
                    viewControlIndex = superview!.subviews.index(of: view)!
                    
                    if(viewControlIndex < textControlIndex){
                        isFirstTextControl = false
                        break
                    }
                }
            }
        }
        
        return isFirstTextControl
        
    }
    
    /**
     This is will check the TextControl is last in its SuperView
     */
    class func isLastTextControlInSuperview(_ superview: UIView?, textControl: UIView) -> Bool{
        
        var isLastTextControl : Bool = true
        
        var textControlIndex : Int = -1
        var viewControlIndex : Int = -1
        
        if(superview != nil){
            
            if((superview?.subviews.contains(textControl))!){
                textControlIndex = superview!.subviews.index(of: textControl)!
            }
            
            for view in (superview?.subviews)! {
                
                if(view.isTextControl() && textControl != view){
                    
                    viewControlIndex = superview!.subviews.index(of: view)!
                    
                    if(viewControlIndex > textControlIndex){
                        isLastTextControl = false
                        break
                    }
                }
            }
        }
        return isLastTextControl
    }
    
    
    // MARK: - User Interaction -
    
    func displayCenterToast(message : String){
        self.makeToast(message, duration: 2.0, position: .center)
    }
    
    func displayTopToast(message : String){
        self.makeToast(message, duration: 2.0, position: .top)
    }
    
    func displayBottomToast(message : String){
        self.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Server Request -
    
    func loadOperationServerRequest(){
        
        if(!isLoadedRequest)
        {
            AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in

                if self == nil{
                    return
                }
                
                if(self!.progressHUDView != nil){
                    self!.progressHUDView.hide(true)
                }
            }
        }
    }
    
    func beginServerRequest(){
        isLoadedRequest = true
    }
    
    // MARK: InAppPurchase Methods
//    internal func fatchProduct(openFor : InAppViewType)
//    {
//        AppUtility.isNetworkAvailableWithBlock { [weak self] (isAvailable) in
//            if self == nil{
//                return
//            }
//            if isAvailable == true
//            {
//                if let result = AppUtility.getAppDelegate().retrievedProducts
//                {
//                    if result.error == nil
//                    {
//                        if result.retrievedProducts.count == 3
//                        {
//                            if let controller : BaseViewController = self?.getViewControllerFromSubView() as? BaseViewController
//                            {
//                                let inAppView : InAppPurchaseController = InAppPurchaseController.init(products: result, defaultView: openFor)
//                                controller.present(inAppView, animated: true, completion: nil)
//                                
//                            }
//                        }
//                    }
//                }
//                else{
//                    self!.showProgressHUD(viewController: self!, title: "retriveProduct".localize(), subtitle: "")
//                    
//                    AppUtility.getAppDelegate().fetchStoreProducts({ (complete) in
//                        self?.hideProgressHUD()
//                        if complete == true{
//                            if let result = AppUtility.getAppDelegate().retrievedProducts
//                            {
//                                if result.error == nil
//                                {
//                                    if result.retrievedProducts.count == 3
//                                    {
//                                        if let controller : BaseViewController = self?.getViewControllerFromSubView() as? BaseViewController
//                                        {
//                                            let inAppView : InAppPurchaseController = InAppPurchaseController.init(products: result, defaultView: openFor)
//                                            controller.present(inAppView, animated: true, completion: nil)
//                                            
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    })
//                }
//            }
//            else
//            {
//                self?.displayCenterToast(message: ErrorMessage.noInternet)
//            }
//        }
//    }
//    
//    internal func purchaseProduct(pruductId : String){
//        AppUtility.isNetworkAvailableWithBlock { [weak self] (isAvailable) in
//            if self == nil{
//                return
//            }
//            if isAvailable == true{
//                self?.showProgressHUD(viewController: self!, title: "loadingPurchase".localize(), subtitle: nil)
//                SwiftyStoreKit.purchaseProduct(pruductId, completion: { [weak self] (purchaseResult) in
//                    if self == nil{
//                        return
//                    }
//                    
//                    self?.hideProgressHUD()
//                    
//                    switch purchaseResult
//                    {
//                    case .success(let purchaseDetail):
//                        if purchaseDetail.needsFinishTransaction{
//                            SwiftyStoreKit.finishTransaction(purchaseDetail.transaction)
//                        }
//                        AppUtility.setUserDefaultsObject(true as AnyObject, forKey: UserDefaultKey.premiumUser)
//                        SwiftEventBus.post(SwiftyNotification.SucessPayment, userInfo: nil)
//                        return
//                        
//                    default:
//                        break
//                    }
//                    
//                    if let alert : UIAlertController = self?.alertForPurchaseResult(purchaseResult)
//                    {
//                        if let controller : BaseViewController = self?.getViewControllerFromSubView() as? BaseViewController{
//                            alert.addAction(UIAlertAction.init(title: "ok".localize(), style: .default, handler: { [weak self] (action) in
//                                if self == nil{
//                                    return
//                                }
//                                
//                            }))
//                            controller.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                    
//                })
//            }
//            else
//            {
//                self?.displayCenterToast(message: ErrorMessage.noInternet)
//            }
//        }
//    }
//    
//    internal func restorePurchase()
//    {
//        AppUtility.isNetworkAvailableWithBlock { [weak self] (isAvailable) in
//            if self == nil{
//                return
//            }
//            
//            if isAvailable == true
//            {
//                self?.showProgressHUD(viewController: self!, title: "restorePurchase".localize(), subtitle: nil)
//                SwiftyStoreKit.restorePurchases(completion: { [weak self] (restoreResult) in
//                    if self == nil{
//                        return
//                    }
//                    self?.hideProgressHUD()
//                    var title : String = ""
//                    
//                    if restoreResult.restoreFailedPurchases.count > 0
//                    {
//                        title = "restoreFailed".localize()
//                        
//                    }
//                    else if restoreResult.restoredPurchases.count > 0
//                    {
//                        title = "restoreSuccess".localize()
//                    }
//                    else
//                    {
//                        title = "nothingToRestore".localize()
//                    }
//                    
//                    if let controller : BaseViewController = self?.getViewControllerFromSubView() as? BaseViewController
//                    {
//                        let alertView : UIAlertController = UIAlertController.init(title: title, message: "", preferredStyle: .alert)
//                        alertView.addAction(UIAlertAction.init(title: "ok".localize(), style: .destructive, handler: { [weak self] (action) in
//                            if self == nil{
//                                return
//                            }
//                            if restoreResult.restoredPurchases.count > 0{
//                                AppUtility.setUserDefaultsObject(true as AnyObject, forKey: UserDefaultKey.premiumUser)
//                                SwiftEventBus.post(SwiftyNotification.SucessPayment, userInfo: nil)
//                            }
//                        }))
//                        
//                        
//                        controller.present(alertView, animated: true, completion: nil)
//                    }
//                })
//            }
//            else
//            {
//                self?.displayCenterToast(message: ErrorMessage.noInternet)
//            }
//        }
//    }
//    
//    internal func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController?
//    {
//        var title : String = ""
//        var message : String = ""
//        
//        switch result
//        {
//        case .success(_):
//            AppUtility.setUserDefaultsObject(true as AnyObject, forKey: UserDefaultKey.premiumUser)
//            title = "thankYou".localize()
//            message = "purchaseCompleted".localize()
//            break
//        case .error(let error):
//            
//            switch error.code
//            {
//            case .unknown:
//                title = "purchaseFailed".localize()
//                message = "unknownError".localize()
//                break
//            case .clientInvalid: // client is not allowed to issue the request, etc.
//                title = "purchaseFailed".localize()
//                message = "notAllowedPayment".localize()
//                break
//            case .paymentCancelled: // user cancelled the request, etc.
//                break
//            case .paymentInvalid: // purchase identifier was invalid, etc.
//                title = "purchaseFailed".localize()
//                message = "purchasIdentifireInvalid".localize()
//                break
//            case .paymentNotAllowed: // this device is not allowed to make the payment
//                title = "purchaseFailed".localize()
//                message = "notAllowedPayment".localize()
//                break
//            case .storeProductNotAvailable: // Product is not available in the current storefront
//                title = "purchaseFailed".localize()
//                message = "productNotAvailableStore".localize()
//                break
//            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
//                title = "purchaseFailed".localize()
//                message = "clouseAccessNotAllowed".localize()
//                break
//            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
//                title = "purchaseFailed".localize()
//                message = "notConnectNetwork".localize()
//                break
//            default:
//                break
//            }
//        }
//        if title != "" && message != ""{
//            return UIAlertController.init(title: title, message: message, preferredStyle: .alert)
//        }
//        return nil
//    }

    
}
