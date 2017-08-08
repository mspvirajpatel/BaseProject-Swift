//
//  ImageUploadView.swift
//  BaseProjectSwift
//
//  Created by Viraj Patel on 28/11/16.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import UIKit
import Toast_Swift

class ImageUploadView: BaseView
{
    // MARK: - Attribute -
    var btnUploadImage : BaseButton!
    var btnDisplayImage : BaseButton!
    var buttonContainerView : UIView!
    var progressContainerView : UIView!
    var seperatorView : UIView!
    var displayImageEvent : ControlTouchUpInsideEvent?
    var uploadImageEvent : ControlTouchUpInsideEvent?
    var lblProgress : BaseLabel!
    var progreeView : UIProgressView!
    
    
    // MARK: - Lifecycle -
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
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
    override func loadViewControls()
    {
        super.loadViewControls()
        
        buttonContainerView = UIView()
        buttonContainerView.layer .setValue("buttonContainerView", forKey: ControlLayout.name)
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonContainerView)
        
        btnUploadImage = BaseButton(ibuttonType: BaseButtonType.primary, iSuperView: buttonContainerView)
        btnUploadImage.layer.setValue("btnUploadImage", forKey: ControlLayout.name)
        btnUploadImage .setTitle("Upload Image", for: UIControlState.normal)
        
        btnDisplayImage = BaseButton(ibuttonType: BaseButtonType.primary, iSuperView: buttonContainerView)
        btnDisplayImage.layer.setValue("btnDisplayImage", forKey: ControlLayout.name)
        btnDisplayImage .setTitle("Display Image", for: UIControlState.normal)
        
        btnDisplayImage.setButtonTouchUpInsideEvent { (sender, object) in
            if self.displayImageEvent != nil{
                self.displayImageEvent!("Image" as AnyObject?, nil)
            }
        }
        
        btnUploadImage.setButtonTouchUpInsideEvent { (sender, object) in
            
            if ImageUploadManager.sharedInstance.isUploadOperationRunning() == true
            {
                self.makeToast("Uploading already running.Try after complete it.", duration: 2.0, position: ToastPosition.bottom, title: "", image: nil, style: nil, completion: { (finished) in
                    
                })
            }
            else
            {
                if self.uploadImageEvent != nil{
                    self.uploadImageEvent!(nil,nil)
                }
            }
        }
        
        
        seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.yellow
        seperatorView.layer.setValue("seperatorView", forKey: ControlLayout.name)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(seperatorView)
        
        progressContainerView = UIView()
        progressContainerView.translatesAutoresizingMaskIntoConstraints = false
        progressContainerView.layer.setValue("progressContainerView", forKey: ControlLayout.name)
        self.addSubview(progressContainerView)
        
        lblProgress = BaseLabel(labelType: BaseLabelType.large, superView: progressContainerView)
        lblProgress.layer.setValue("lblProgress", forKey: ControlLayout.name)
        lblProgress.text = "Uploading (0/0)"
        
        progreeView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progreeView.layer.setValue("progreeView", forKey: ControlLayout.name)
        progreeView.backgroundColor = UIColor.blue
        progreeView.translatesAutoresizingMaskIntoConstraints = false
        progressContainerView.addSubview(progreeView)
        progreeView.progress = 0.0
        progreeView.tintColor = UIColor.red
    }
    
    override func setViewlayout()
    {
        super.setViewlayout()
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        baseLayout.metrics = ["spacing" : 10]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[buttonContainerView]|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[buttonContainerView(==progressContainerView)][seperatorView(==5)][progressContainerView]|", options: [.alignAllLeading , .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnUploadImage]-spacing-[btnDisplayImage]-50-|", options: [.alignAllLeading , .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        buttonContainerView.addConstraints(baseLayout.control_V)
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: btnUploadImage, attribute: .centerX, relatedBy: .equal, toItem: buttonContainerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        buttonContainerView.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.size_Width = NSLayoutConstraint(item: btnUploadImage, attribute: .width, relatedBy: .equal, toItem: buttonContainerView, attribute: .width, multiplier: 0.5, constant: 1.0)
        buttonContainerView.addConstraint(baseLayout.size_Width)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-spacing-[lblProgress]-spacing-[progreeView]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        progressContainerView.addConstraints(baseLayout.control_V)
        
        baseLayout.position_Left = NSLayoutConstraint(item: lblProgress, attribute: .leading, relatedBy: .equal, toItem: progreeView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: progreeView, attribute: .centerX, relatedBy: .equal, toItem: progressContainerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        baseLayout.size_Width = NSLayoutConstraint(item: progreeView, attribute: .width, relatedBy: .equal, toItem: progressContainerView, attribute: .width, multiplier: 0.5, constant: 0.0)
        
        progressContainerView.addConstraints([baseLayout.position_Left,  baseLayout.position_CenterX ,  baseLayout.size_Width])
    }
    
    // MARK: - Public Interface -
    func setDisplayImageEvent(event : @escaping ControlTouchUpInsideEvent) -> Void {
        displayImageEvent = event
    }
    
    func setUploadImageEvent(event : @escaping ControlTouchUpInsideEvent) -> Void {
        uploadImageEvent = event
    }
    
    open func updateImageProgress(arrCount : NSArray) -> Void
    {
        lblProgress.text = "Uploading (\(arrCount[0])\\\(arrCount[1]))"
        
        let uploadedImg : Float = Float(arrCount[0] as! Int)
        let totalImg : Float = Float(arrCount[1] as! Int)
        
        progreeView.progress = uploadedImg / totalImg
        
        print("Completed : \(String(describing: arrCount.firstObject))" , "Total : \(arrCount[1])")
        print("Progress : \(uploadedImg / totalImg)")
        
        if arrCount[0] as! Int == arrCount[1] as! Int
        {
            AppUtility.executeTaskInMainQueueWithCompletion
            {
                self.makeToast("Upload is completed...", duration: 2.0, position: ToastPosition.bottom, title: "", image: nil, style: nil, completion: { (finished) in
                    self.lblProgress.text = "Uploading (0\\0)"
                    self.progreeView.progress = 0.0
                })
            }
        }
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Server Request -
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
