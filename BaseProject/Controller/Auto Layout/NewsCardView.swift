//
//  NewsCardView.swift
//  BaseProjectSwift
//
//  Created by WebMob on 02/02/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCardView: UIView {

    // MARK: - Attribute -
    var imgNews : BaseImageView!
    var lblNews : UILabel!
    var arrPortraint : [NSLayoutConstraint] = []
    var arrLandscape : [NSLayoutConstraint] = []
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    func loadViewControls()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.gray
        imgNews = BaseImageView(type: BaseImageViewType.defaultImg, superView: self)
        imgNews.displayImageFromURL("http://www.planwallpaper.com/static/images/Fall-wallpaper-1366x768-HD-wallpaper.jpg")
        
        lblNews = UILabel()
        lblNews.translatesAutoresizingMaskIntoConstraints = false
        lblNews.numberOfLines = 0
        lblNews.textColor = UIColor.black
        lblNews.text = "We understand you don’t have time to go through long news articles everyday. So we cut the clutter and deliver them, in 60-word shorts. Short news for the mobile generation."
        self.addSubview(lblNews)
    }
    
    func setViewlayout() {
        
        let layout : AppBaseLayout = AppBaseLayout()
        
        
        // General Constraint
        layout.position_Top = NSLayoutConstraint(item: imgNews, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
        layout.position_Left = NSLayoutConstraint(item: imgNews, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        self .addConstraints([layout.position_Top , layout.position_Left])
        
        layout.position_Bottom = NSLayoutConstraint(item: lblNews, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        layout.position_Right = NSLayoutConstraint(item: lblNews, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -10.0)
        self .addConstraints([layout.position_Bottom , layout.position_Right])
        
        // Portraint Constraint
        layout.position_Right = NSLayoutConstraint(item: imgNews, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        layout.position_Right.isActive = false
        arrPortraint.append(layout.position_Right)
        
        layout.size_Height = NSLayoutConstraint(item: imgNews, attribute: .height, relatedBy: .equal, toItem: imgNews, attribute: .width, multiplier: 0.5, constant: 0.0)
        layout.size_Height.isActive = false
        arrPortraint.append(layout.size_Height)
        
        layout.position_Top = NSLayoutConstraint(item: lblNews, attribute: .top, relatedBy: .equal, toItem: imgNews, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        layout.position_Top.isActive = false
        arrPortraint.append(layout.position_Top)
        
        layout.position_Left = NSLayoutConstraint(item: lblNews, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        layout.position_Left.isActive = false
        arrPortraint.append(layout.position_Left)
        
        self.addConstraints(arrPortraint)
        
        // Landscape Constraint
        layout.position_Bottom = NSLayoutConstraint(item: imgNews, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        layout.position_Bottom.isActive = false
        arrLandscape.append(layout.position_Bottom)
        
        layout.size_Width = NSLayoutConstraint(item: imgNews, attribute: .width, relatedBy: .equal, toItem: imgNews, attribute: .height, multiplier: 0.4, constant: 0.0)
        layout.size_Width.isActive = false
        arrLandscape.append(layout.size_Width)
        
        layout.position_Left = NSLayoutConstraint(item: lblNews, attribute: .leading, relatedBy: .equal, toItem: imgNews, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        layout.position_Left.isActive = false
        arrLandscape.append(layout.position_Left)
        
        layout.position_Top = NSLayoutConstraint(item: lblNews, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
        layout.position_Top.isActive = false
        arrLandscape.append(layout.position_Top)
        
        self.addConstraints(arrLandscape)
        
        if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            self.activePortraintView()
        }
        else{
            self.activeLanscapeView()
        }
    }
    
    // MARK: - Public Interface -
    public func viewRotateEvent(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            self.activePortraintView()
        }
        else{
            self.activeLanscapeView()
        }
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    private func activePortraintView(){
        
        for constraint in arrPortraint{
            constraint.isActive = true
        }
        
        for constraint in arrLandscape{
            constraint.isActive = false
        }
    }
    
    private func activeLanscapeView(){
        
        for constraint in arrPortraint{
            constraint.isActive = false
        }
        
        for constraint in arrLandscape{
            constraint.isActive = true
        }
    }
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -

}
