//
//  MyFoundationView.swift
//  BaseProjectSwift
//
//  Created by Viraj Patel on 23/11/16.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import UIKit

class MyFoundationView: BaseView, UIAlertViewDelegate {
    
    var controlContainerView:UIView!
    var scrollView : BaseScrollView!
    var lbllongPressText:BaseLabel!
    var containerView:UIView!
    
    var appInformationButton:BaseButton!
    var systemSoundButton:BaseButton!
    var deviceInfoButton: BaseButton!
    var touchmeButton: BaseButton!
    var authonticationButton : BaseButton!
    
    var btnSelect: ControlTouchUpInsideEvent?
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
        
        self.setButtonText()
        
    }
    
    func setButtonText(){
        appInformationButton.setTitle("App Information", for: UIControlState.normal)
        systemSoundButton.setTitle("System Sound Button", for: UIControlState.normal)
        deviceInfoButton.setTitle("Device Info Button", for: UIControlState.normal)
        touchmeButton.setTitle("Touch me! to Get Path Of Files", for: UIControlState.normal)
        authonticationButton.setTitle("Authontication via Touch ID", for: UIControlState.normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    deinit{
        print("BaseView Controller Deinit called")
        
        
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        
        super.loadViewControls()
        if SystemConstants.IS_DEBUG {
            self.backgroundColor = UIColor.gray
        }
        
        /*  controlContainerView Allocation   */
        controlContainerView = UIView()
        controlContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(controlContainerView)
        
        /*  scrollView Allocation   */
        self.scrollView = BaseScrollView(superView: self)
        containerView = scrollView.container
        containerView.backgroundColor = UIColor.clear
        
        /*  userNameTextField Allocation   */
        lbllongPressText = BaseLabel(labelType: .large, superView: containerView)
        lbllongPressText.numberOfLines = 0
        
        /*  appInformationButton Allocation   */
        appInformationButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        appInformationButton.setButtonTouchUpInsideEvent { (sender, object) in
            
            BFLogClear()
            
            BFLog(message:"App name: \(BSApp.name)")
            BFLog(message:"App build: \(BSApp.build)")
            BFLog(message:"App version: \(BSApp.version)")
            
            BSApp.onFirstStart(block: { (isFirstStart) -> () in
                if isFirstStart {
                    BFLog(message: "Is first start!")
                } else {
                    BFLog(message: "Is not first start!")
                }
            })
            
            
            self.lbllongPressText.text = BFLogString
            
        }
        
        systemSoundButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        systemSoundButton.setButtonTouchUpInsideEvent { (sender, object) in
            BFLogClear()
            
            BFSystemSound.playSystemSoundVibrate()
            BFLog(message: "Vibrate")
            BFSystemSound.playSystemSound(audioID: .ReceivedMessage)
            BFLog(message: "Play sound")
            
            self.lbllongPressText.text = BFLogString
            
        }
        
        deviceInfoButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        deviceInfoButton.setButtonTouchUpInsideEvent { (sender, object) in
            BFLogClear()
            
           // BFLog(message:"iOS Version: \(UIDevice.iOSVersionName())")
            
            BFLog(message:"RAM Size: \(UIDevice.ramSize() / 1024 / 1024) MB")
            
            BFLog(message:"Unique Identifier: \(UIDevice.uniqueIdentifier())")
           
            if UIScreen.isRetina() {
                 BFLog(message:"Retina: Yes")
            } else {
                BFLog(message:"Retina: No")
            }
            
            if UIScreen.isRetinaHD() {
                BFLog(message:"Retina HD: Yes")
            } else {
                BFLog(message:"Retina HD: No")
            }
            
            switch Device.version() {
                /*** iPhone ***/
            case .iPhone4:       BFLog(message: "It's an iPhone 4")
            case .iPhone4S:      BFLog(message: "It's an iPhone 4S")
            case .iPhone5:       BFLog(message: "It's an iPhone 5")
            case .iPhone5C:      BFLog(message: "It's an iPhone 5C")
            case .iPhone5S:      BFLog(message: "It's an iPhone 5S")
            case .iPhone6:       BFLog(message: "It's an iPhone 6")
            case .iPhone6S:      BFLog(message: "It's an iPhone 6S")
            case .iPhone6Plus:   BFLog(message: "It's an iPhone 6 Plus")
            case .iPhone6SPlus:  BFLog(message: "It's an iPhone 6 S Plus")
                
                /*** iPad ***/
            case .iPad1:         BFLog(message: "It's an iPad 1")
            case .iPad2:         BFLog(message: "It's an iPad 2")
            case .iPad3:         BFLog(message: "It's an iPad 3")
            case .iPad4:         BFLog(message: "It's an iPad 4")
            case .iPadAir:       BFLog(message: "It's an iPad Air")
            case .iPadAir2:      BFLog(message: "It's an iPad Air 2")
            case .iPadMini:      BFLog(message: "It's an iPad Mini")
            case .iPadMini2:     BFLog(message: "It's an iPad Mini 2")
            case .iPadMini3:     BFLog(message: "It's an iPad Mini 3")
            case .iPadMini4:     BFLog(message: "It's an iPad Mini 4")
            case .iPadPro:       BFLog(message: "It's an iPad Pro")
                
                /*** iPod ***/
            case .iPodTouch1Gen: BFLog(message: "It's a iPod touch generation 1")
            case .iPodTouch2Gen: BFLog(message: "It's a iPod touch generation 2")
            case .iPodTouch3Gen: BFLog(message: "It's a iPod touch generation 3")
            case .iPodTouch4Gen: BFLog(message: "It's a iPod touch generation 4")
            case .iPodTouch5Gen: BFLog(message: "It's a iPod touch generation 5")
            case .iPodTouch6Gen: BFLog(message: "It's a iPod touch generation 6")
                
                /*** Simulator ***/
            case .Simulator:   BFLog(message: "It's a Simulator")
                
                /*** Unknown ***/
            default:           BFLog(message: "It's an unknown device")
            }
            
            switch Device.size() {
            case Size.screen3_5Inch:  BFLog(message:"It's a 3.5 inch screen")
            case Size.screen4Inch:    BFLog(message:"It's a 4 inch screen")
            case Size.screen4_7Inch:  BFLog(message:"It's a 4.7 inch screen")
            case Size.screen5_5Inch:  BFLog(message:"It's a 5.5 inch screen")
            case Size.screen7_9Inch:  BFLog(message:"It's a 7.9 inch screen")
            case Size.screen9_7Inch:  BFLog(message:"It's a 9.7 inch screen")
            case Size.screen12_9Inch: BFLog(message:"It's a 12.9 inch screen")
            default:              BFLog(message:"Unknown size")
            }
            
            if (Device.isPad()){
                BFLog(message:"It's an iPad")
            }
            else if (Device.isPhone()){
                BFLog(message:"It's an iPhone")
            }
            else if (Device.isPod()){
                BFLog(message:"It's an iPod")
            }
            else if (Device.isSimulator()){
                BFLog(message:"It's a Simulated device")
            }
            
            if Device.isEqualToScreenSize(Size.screen4Inch) {
                BFLog(message:"It's a 4 inch screen")
            }
            
            if Device.isLargerThanScreenSize(Size.screen4_7Inch) {
                BFLog(message:"Your device screen is larger than 4.7 inch")
            }
            
            if Device.isSmallerThanScreenSize(Size.screen4_7Inch) {
                BFLog(message:"Your device screen is smaller than 4.7 inch")
            }

            
            self.lbllongPressText.text = BFLogString
            
        }
        
                
        touchmeButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        touchmeButton.setButtonTouchUpInsideEvent { (sender, object) in
           
            BFLogClear()
            
            let array: Array<Int> = [1, 2, 3, 4, 5]
            
            let saving: String = FileManager.saveArrayToPath(directory: .Documents, filename: "temp", array: array as Array<AnyObject>) ? "Save array: Yes" : "Save array: No"
            let directory: String = FileManager.getDocumentsDirectoryForFile(file: "temp.plist")
            let deleting: String = try! FileManager.deleteFile(file: "temp.plist", fromDirectory: .Documents) ? "Delete file: Yes" : "Delete file: No"
            
            BFLog(message: "\(saving)")
            BFLog(message: "Directory: \(directory)")
            BFLog(message: "\(deleting)")
 
           self.lbllongPressText.text = BFLogString
        }
        
        
        authonticationButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        authonticationButton.isHidden = true
        authonticationButton.setButtonTouchUpInsideEvent { (sender, object) in
            
            BFLogClear()
            
        }
        
    }
    
    
    override func setViewlayout(){
        super.setViewlayout()
       
        baseLayout.viewDictionary = ["controlContainerView" : controlContainerView,
                                            "scrollView" : scrollView,
                                            "containerView" : containerView,
                                            "lbllongPressText" : lbllongPressText,
                                            "appInformationButton" : appInformationButton,
                                            "systemSoundButton" : systemSoundButton,
                                            "deviceInfoButton" : deviceInfoButton,
                                            "touchmeButton" : touchmeButton,
                                            "authonticationButton" : authonticationButton
            
        ]
        
        let leftRightPadding: CGFloat = 20.0
        let topBottomPadding: CGFloat = 10.0
        let scrollViewHeight: CGFloat = SCREEN_HEIGHT
        
        baseLayout.metrics = ["leftRightPadding": leftRightPadding, "topBottomPadding": topBottomPadding, "scrollViewHeight": scrollViewHeight]
        
        /*  controlContainerView Layout    */
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[controlContainerView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top =  NSLayoutConstraint(item: controlContainerView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints([baseLayout.position_Top])
        
        /*  scrollView Layout    */
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[scrollView]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V =  NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollView(scrollViewHeight)]", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Bottom =  NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        baseLayout.position_Top =  NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: leftRightPadding)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        self.addConstraints([baseLayout.position_Top])
        
        
        /*  containerView Layout    */
        
        baseLayout.size_Width = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)
        
        baseLayout.size_Height = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1.0, constant: 0.0)
        baseLayout.size_Height.priority = 250
        
        scrollView.addConstraints([baseLayout.size_Width,baseLayout.size_Height])
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[lbllongPressText]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item: lbllongPressText, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top])
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[appInformationButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:appInformationButton , attribute: .top, relatedBy: .equal, toItem: lbllongPressText, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[systemSoundButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:systemSoundButton , attribute: .top, relatedBy: .equal, toItem: appInformationButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[deviceInfoButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:deviceInfoButton , attribute: .top, relatedBy: .equal, toItem: systemSoundButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
   
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[touchmeButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:touchmeButton , attribute: .top, relatedBy: .equal, toItem: deviceInfoButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[authonticationButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:authonticationButton , attribute: .top, relatedBy: .equal, toItem: touchmeButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        self.layoutIfNeeded()
        
    }
    
    
    // MARK: - Public Interface -
    
    func setButtonSelectEvent(_ event: @escaping ControlTouchUpInsideEvent) {
        btnSelect = event
    }
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Server Request -
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    func showPasswordAlert() {
        
        var checkdata : Bool = true
        
        AlertBuilder(title: "AUTHORIZED with Password", message: "Please type your password", preferredStyle: .alert)
            .addAction(title: "NO", style: .cancel) { _ in
                self.loadData(string: "Not Success with Password")
            }
            
            .addAction(title: "Okay", style: .default) { _ in
                if checkdata
                {
                    self.loadData(string: "Success with Password")
                }
                else
                {
                    self.loadData(string: "Not Success with Password")
                }
            }
            .addTextFieldHandler({ (textField) in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
                if !(textField.text?.isEmpty)! {
                    if textField.text == "appcoda" {
                        checkdata = true
                    }
                    else{
                        checkdata = false

                    }
                }
                else{
                    checkdata = false
                }
            })
            .build()
            .kam_show(animated: true)
       
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
    }
   
    func loadData(string:String){
        self.lbllongPressText.text = string
    }
    
}
