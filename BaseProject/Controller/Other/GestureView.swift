//
//  GestureView.swift
//  BaseProjectSwift
//
//  Created by MacMini-2 on 21/11/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit
import Alamofire

class GestureView: BaseView {
    
    var controlContainerView:UIView!
   
    var scrollView : BaseScrollView!
    
    var lbllongPressText:BaseLabel!
    var lblPanGestureText:BaseLabel!
    
    var containerView:UIView!
    
    var tapGestureButton:BaseButton!
    var metrialProgressShowButton:BaseButton!
    var panGestureButton:BaseButton!
    var navigationButton: BaseButton!
    var alertViewButton: BaseButton!
    var alertBuilderButton: BaseButton!
    var rectShadowWithOffsetButton: BaseButton!
    
    var btnSelect: ControlTouchUpInsideEvent?

    var logoImageFixedHeightConstraint:NSLayoutConstraint!
    
    /// A constant to baseLayout the textFields.
    private let constant: CGFloat = 32

    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
        self.setButtonText()
    }
    
    func setButtonText(){
        tapGestureButton.setTitle("Tap to Navigation two Second Tab bar", for: UIControlState.normal)
        metrialProgressShowButton.setTitle("Loading View Start Button", for: UIControlState.normal)
        panGestureButton.setTitle("Loading View Stop Button", for: UIControlState.normal)
       
        navigationButton.setTitle("Navigation two New Page Button", for: UIControlState.normal)
        
        alertBuilderButton.setTitle("Alert Builder Button", for: UIControlState.normal)
        
        alertViewButton.setTitle("Alert View Button", for: UIControlState.normal)
        
        rectShadowWithOffsetButton.setTitle("Rect Shadow With Offset", for: UIControlState.normal)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    deinit{
        
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
        self.scrollView                = BaseScrollView.init(superView: self)
        containerView                  = scrollView.container
        containerView.backgroundColor  = UIColor.clear

        /*  userNameTextField Allocation   */
        lbllongPressText               = BaseLabel(labelType: .large, superView: containerView)
        lbllongPressText.textColor     = UIColor.white
        lbllongPressText.numberOfLines = 1
        lbllongPressText.text = "Long Press"
   
        
        lblPanGestureText = BaseLabel(labelType: .large, superView: containerView)
        lblPanGestureText.textColor = UIColor.white
        lblPanGestureText.numberOfLines = 1
        lblPanGestureText.text = "Pan Gesture"
       
        /*  tapGestureButton Allocation   */
        tapGestureButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        tapGestureButton.setButtonTouchUpInsideEvent { (sender, object) in
           
        }
        
        
        metrialProgressShowButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        metrialProgressShowButton.setButtonTouchUpInsideEvent { (sender, object) in

        }
        
        panGestureButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        panGestureButton.setButtonTouchUpInsideEvent { (sender, object) in
            self.hideMetrialProgress()
        }
     
        navigationButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        navigationButton.setButtonTouchUpInsideEvent { (sender, object) in
             self.btnSelect!("Left" as AnyObject?, nil)
        }
        
        alertViewButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        alertViewButton.setButtonTouchUpInsideEvent { (sender, object) in
            AlertBuilder(title: "Question", message: "Are you sure?", preferredStyle: .alert)
                .addAction(title: "NO", style: .cancel) { _ in
                    print("hello")
                self.lblPanGestureText.text = "Click on NO"
                }
                
                .addAction(title: "YES", style: .default) { _ in
                    print("hello yes")
                self.lblPanGestureText.text = "Click on YES"
                    self.btnSelect!("Home" as AnyObject?, nil)
                }
                .build()
                .kam_show(animated: true)
        }
        
        
        alertBuilderButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        alertBuilderButton.setButtonTouchUpInsideEvent { (sender, object) in
            if UIDevice.current.userInterfaceIdiom != .pad {
                // Sample to show on iPad
                AlertBuilder(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
                    .addAction(title: "NO", style: .cancel) {_ in
                        print("hello")
                        self.lblPanGestureText.text = "Click on NO"
                    }
                    .addAction(title: "YES", style: .default) { _ in
                        print("hello yes")
                        self.lblPanGestureText.text = "Click on YES"
                    }
                    .build()
                    .kam_show(animated: true)
            } else {
                // Sample to show on iPad
                AlertBuilder(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
                    .addAction(title: "YES", style: .default) { _ in
                    self.lblPanGestureText.text = "Click on YES"
                    }
                    .addAction(title: "Not Sure", style: .default) {
                        _ in
                    self.lblPanGestureText.text = "Click on NO"
                    }
                    .setPopoverPresentationProperties(sourceView: self, sourceRect: CGRect.init(x: 0, y: 0, width: 100, height: 100), barButtonItem: nil, permittedArrowDirections: .any)
                    .build()
                    .kam_show(animated: true)
            }

        }
        
        rectShadowWithOffsetButton = BaseButton(ibuttonType:.primary,iSuperView: containerView)
        
        rectShadowWithOffsetButton.setButtonTouchUpInsideEvent { (sender, object) in
           try! PreferencesExplorer.open(PreferenceType.wallpaper)
        }
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        baseLayout.viewDictionary = ["controlContainerView" : controlContainerView,
                                            "scrollView" : scrollView,
                                            "containerView" : containerView,
                                            "lbllongPressText" : lbllongPressText,
                                            "lblPanGestureText" : lblPanGestureText,
                                            "tapGestureButton" : tapGestureButton,
                                            "panGestureButton" : panGestureButton,
                                            "metrialProgressShowButton" : metrialProgressShowButton,
                                            "navigationButton" : navigationButton,
                                            "alertViewButton" : alertViewButton,
                                            "alertBuilderButton" : alertBuilderButton, "rectShadowWithOffsetButton" : rectShadowWithOffsetButton,
            
        ]
        

        let leftRightPadding: CGFloat = 20.0
        let topBottomPadding: CGFloat = 10.0
        let scrollViewHeight: CGFloat = SCREEN_HEIGHT
        
        baseLayout.metrics = ["leftRightPadding": leftRightPadding, "topBottomPadding": topBottomPadding,  "scrollViewHeight": scrollViewHeight]
        
        
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
        
        /*  userNameTextField Layout    */
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[lbllongPressText]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item: lbllongPressText, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top])
        
        /*  passwordTextField Layout    */
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[lblPanGestureText]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        baseLayout.position_Top = NSLayoutConstraint(item: lblPanGestureText, attribute: .top, relatedBy: .equal, toItem: lbllongPressText, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top])
        
        /*  loginButton Layout    */
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[tapGestureButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:tapGestureButton , attribute: .top, relatedBy: .equal, toItem: lblPanGestureText, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[metrialProgressShowButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:metrialProgressShowButton , attribute: .top, relatedBy: .equal, toItem: tapGestureButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[panGestureButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:panGestureButton , attribute: .top, relatedBy: .equal, toItem: metrialProgressShowButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[navigationButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:navigationButton , attribute: .top, relatedBy: .equal, toItem: panGestureButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[alertViewButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:alertViewButton , attribute: .top, relatedBy: .equal, toItem: navigationButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[alertBuilderButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:alertBuilderButton , attribute: .top, relatedBy: .equal, toItem: alertViewButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top ])
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftRightPadding-[rectShadowWithOffsetButton]-leftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item:rectShadowWithOffsetButton , attribute: .top, relatedBy: .equal, toItem: alertViewButton, attribute: .bottom, multiplier: 1.0, constant: topBottomPadding)
        
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
   
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
    }
    
    
    
}
