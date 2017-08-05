//
//  LeftMenuController.swift
//  troopool
//
//  Created by WebMobTech-1 on 10/13/16.
//  Copyright © 2016 WebMobTech. All rights reserved.
//

import UIKit

class LeftMenuController : BaseViewController{
    
    // Mark: - Attributes -
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    
    var leftMenuView : LeftMenuView!
    var dataBaseController : DataBaseController?
    var plistViewController : PlistViewController?
    var gestureController : GestureViewController?
    var myFoundationViewController : MyFoundationViewController?
    var imageUploadController : ImageUploadingController?
    var pageAnimationController : PageAnimationController?
    var autolayoutController : AutolayoutController?
    var shareListController : ShareListController?
    var fileManager : FileManagerController?
    var coreData : CoreDataController?
    var sliderView : SliderViewController?
    
    
    var selectedMenuType :  LeftMenu = .unknownType
    var lastSelectedMenu : Int = -1
    
    // MARK: - Lifecycle -
    
    override init() {
        
        let subView : LeftMenuView = LeftMenuView(frame: CGRect.zero)
        super.init(iView: subView, andNavigationTitle: "BasePeoject")
        
        leftMenuView = subView
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
    }
    
    // MARK: - Layout - 
    override func loadViewControls() {
        super.loadViewControls()
        lastSelectedMenu = LeftMenu.unknownType.rawValue
        
        leftMenuView.btnTapped { (sender, object) in
            if String(describing: sender as AnyObject) == "true" {
                self.displaySelectedMenuItem(object as! Int)
            }
        }
        
        var currentMenuViewType : Int = -1
        currentMenuViewType = LeftMenu.home.rawValue;
        self.displaySelectedMenuItem(currentMenuViewType)
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    open func displaySelectedMenuItem(_ selectedMenu : Int)
    {
 
        let containerViewController:DLHamburguerViewController? = AppUtility.getAppDelegate().slidemenuController
        if lastSelectedMenu != selectedMenu
        {
            let viewController = self.getMenuViewController(selectedMenu)
            
            if viewController != nil
            {
                let menuNavigationController:BaseNavigationController = AppUtility.getAppDelegate().menuNavigationController!
                
                menuNavigationController.viewControllers = [viewController!]
                
                containerViewController?.hideMenuViewControllerWithCompletion({ () -> Void in
                    containerViewController?.contentViewController = menuNavigationController
                })
                
                
                
                leftMenuView.setSelectedMenuViewType(selectedMenuType)
            }
            else
            {
                
            }
        }
        else
        {
            containerViewController?.hideMenuViewControllerWithCompletion({ () in
                
            })
        }
    }
    
    fileprivate func getMenuViewController(_ menuType :  Int) -> BaseViewController?
    {
        var controller : BaseViewController?
        
        switch(menuType)
        {
        case LeftMenu.home.rawValue :
            if(dataBaseController == nil){
                dataBaseController = DataBaseController()
            }
            selectedMenuType = LeftMenu.home
            controller = dataBaseController
            
            break
            
        case LeftMenu.setting.rawValue :
            if(plistViewController == nil){
                plistViewController = PlistViewController()
            }
            selectedMenuType = LeftMenu.setting
            controller = plistViewController
            
            break
            
        case LeftMenu.Gesture.rawValue :
            if(gestureController == nil){
                gestureController = GestureViewController()
            }
            selectedMenuType = LeftMenu.Gesture
            controller = gestureController
            break
            
        case LeftMenu.myFoundation.rawValue:
            if(myFoundationViewController == nil){
                myFoundationViewController = MyFoundationViewController()
            }
            selectedMenuType = LeftMenu.myFoundation
            controller = myFoundationViewController
            break
        case LeftMenu.UploadImage.rawValue:
            if imageUploadController == nil{
                imageUploadController = ImageUploadingController()
            }
            selectedMenuType = LeftMenu.UploadImage
            controller = imageUploadController
            break
        case LeftMenu.pageAnimation.rawValue:
            
            if pageAnimationController == nil{
                pageAnimationController = PageAnimationController()
            }
            selectedMenuType = LeftMenu.pageAnimation
            controller = pageAnimationController
            break
        case LeftMenu.autolayout.rawValue:
            
            if autolayoutController == nil{
                autolayoutController = AutolayoutController()
            }
            selectedMenuType = LeftMenu.autolayout
            controller = autolayoutController
            break
        case LeftMenu.shareData.rawValue:
            
            if shareListController == nil{
                shareListController = ShareListController()
            }
            
            selectedMenuType = LeftMenu.shareData
            controller = shareListController
            break
            
        case LeftMenu.fileManager.rawValue:
            
            if fileManager == nil{
                fileManager = FileManagerController()
            }
            
            selectedMenuType = LeftMenu.fileManager
            controller = fileManager
            break
            
        case LeftMenu.coreData.rawValue:
            
            if coreData == nil{
                coreData = CoreDataController()
            }
            
            selectedMenuType = LeftMenu.coreData
            controller = coreData
            break
            
        case LeftMenu.sliderView.rawValue:
            if sliderView == nil{
                sliderView = SliderViewController()
            }
            
            selectedMenuType = LeftMenu.sliderView
            controller = sliderView
            break
            
            
        default :
            if(dataBaseController == nil){
                dataBaseController = DataBaseController()
            }
            selectedMenuType = LeftMenu.home
            controller = dataBaseController
            break
        }
        
        lastSelectedMenu = menuType
        
        return controller!
    }
}

