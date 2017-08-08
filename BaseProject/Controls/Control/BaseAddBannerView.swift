
//
//import UIKit
//import GoogleMobileAds
//import FirebaseAnalytics
//
//
//class BaseAddBannerView: GADBannerView {
//    
//    // MARK: - Lifecycle -
//    var constrainBannerHeight : NSLayoutConstraint!
//    
//    
//    init(adSize: GADAdSize, bannerKey : String) {
//        super.init(adSize: adSize)
//        
//        self.backgroundColor = Color.appPrimaryBG.withAlpha(0.2)
//        self.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.adUnitID = bannerKey
//        self.delegate = self
//        
//        self.setViewlayout()
//        
//        SwiftEventBus.onMainThread(self, name: SwiftyNotification.SucessPayment) { [weak self] (notification) in
//            if self == nil{
//                return
//            }
//            self!.constrainBannerHeight.constant = 0
//            UIView.animate(withDuration: 0.5) { [weak self] in
//                if self == nil{
//                    return
//                }
//                self?.layoutIfNeeded()
//            }
//        }
//        
//        SwiftEventBus.onMainThread(self, name: SwiftyNotification.ReAddsDisplay) { [weak self] (notification) in
//            if self == nil{
//                return
//            }
//            
//            self!.constrainBannerHeight = NSLayoutConstraint(item: self!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1)
//            self!.addConstraint(self!.constrainBannerHeight)
//            UIView.animate(withDuration: 0.2) { [weak self] in
//                if self == nil{
//                    return
//                }
//                self?.layoutIfNeeded()
//            }
//        }
//       
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        print("BaseAdd Deinit")
//        SwiftEventBus.unregister(self)
//        
//    }
//    
//    // MARK: - Public Interface -
//    func setViewlayout() {
//        constrainBannerHeight = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1)
//        self.widthAnchor.constraint(equalToConstant: currentDevice.isIphone ? kGADAdSizeBanner.size.width : kGADAdSizeFullBanner.size.width).isActive = true
//        self.addConstraint(constrainBannerHeight)
//    }
//    
//    func requestBannerAd(rootController : UIViewController) {
//        
//        var isPremiumUser : Bool = false
//        
//        if let tmpCheck = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.premiumUser) as? Bool{
//            isPremiumUser = tmpCheck
//            if !isPremiumUser {
//                self.rootViewController = rootController
//                let request : GADRequest = GADRequest()
//                //request.testDevices = [kGADSimulatorID]
//                self.load(request)
//            }
//        }
//        else{
//            self.rootViewController = rootController
//            let request : GADRequest = GADRequest()
//            //request.testDevices = [kGADSimulatorID]
//            self.load(request)
//        }
//        
//    }
//    
//    // MARK: - User Interaction -
//    
//    // MARK: - Internal Helpers -
//    
//    // MARK: - Server Request -
//    
//}
//
//extension BaseAddBannerView : GADBannerViewDelegate {
//    /// Tells the delegate that a full screen view will be presented in response
//    /// to the user clicking on an ad.
//    
//    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
//        FIRAnalytics.logEvent(withName: "_click_home_add", parameters: [
//            "" :"" as NSObject
//            ])
//    }
//
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        self.constrainBannerHeight.constant = currentDevice.isIphone ? kGADAdSizeBanner.size.height : kGADAdSizeFullBanner.size.height
//        UIView.animate(withDuration: 0.5) { [weak self] in
//            if self == nil{
//                return
//            }
//            self?.layoutSubviews()
//        }
//    }
//    
//    /// Tells the delegate an ad request failed.
//    func adView(_ bannerView: GADBannerView,
//                didFailToReceiveAdWithError error: GADRequestError) {
//        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
//    }
//    
//    /// Tells the delegate that the full screen view will be dismissed.
//    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewWillDismissScreen")
//    }
//    
//    /// Tells the delegate that the full screen view has been dismissed.
//    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewDidDismissScreen")
//    }
//    
//    /// Tells the delegate that a user click will open another app (such as
//    /// the App Store), backgrounding the current app.
//    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
//        print("adViewWillLeaveApplication")
//    }
//}
