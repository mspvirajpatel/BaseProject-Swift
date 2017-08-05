//
//  DriverPhotoViewerView.swift
//  GasdropDriver
//
//  Created by MacMini-2 on 14/10/16.
//  Copyright © 2016 WebMobTech. All rights reserved.
//

import UIKit
import Kingfisher

class DriverPhotoViewerView: BaseView ,UIScrollViewDelegate,
    PagingScrollViewDelegate, PagingScrollViewDataSource

{
    private var mainScrollView:PagingScrollView!
    private var btnClose : BaseButton!
    private var lblTitle : BaseLabel!
    private var lblCount : BaseLabel!
    
    var vehicleDetail : ReservationScheduleModel!
    
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
        
        //self.backgroundImageView.removeFromSuperview()
        self.backgroundColor = UIColor.black
        
        //Main ScrollView Allocation
        mainScrollView = PagingScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        mainScrollView.delegate   = self
        mainScrollView.dataSource = self
        
        self.addSubview(mainScrollView)
        
        //4 Close Button Allocation
        btnClose = BaseButton(ibuttonType: BaseButtonType.close, iSuperView: self)
        
        // Title Label Allocaiton
        lblTitle = BaseLabel(labelType: BaseLabelType.small, superView: self)
        lblTitle .textAlignment = .left
        lblTitle.font = UIFont(name: FontStyle.bold, size: 12.0)
        lblTitle.numberOfLines = 0
        lblTitle.textColor = UIColor.white
        lblTitle.text = " "
        
        // Count Label Allocation
        lblCount = BaseLabel(labelType: BaseLabelType.small, superView: self)
        lblCount .textAlignment = .right
        lblCount .textColor = UIColor.white
        lblCount .text = " "
        lblCount.font = UIFont(name: FontStyle.bold, size: 12.0)
        
    }
    
    override func setViewlayout()
    {
        super.setViewlayout()
        
        let leftPadding : CGFloat = 10.0
        let rightPadding : CGFloat = 20.0
        let topPadding : CGFloat = 10.0
        let bottomPadding : CGFloat = 20.0
        
        baseLayout.metrics = ["rightPadding" : rightPadding, "leftPadding" : leftPadding,"topPadding" : topPadding, "bottomPadding" : bottomPadding]
        
        baseLayout.viewDictionary = [ "mainScrollView" : mainScrollView , "btnClose" : btnClose , "lblTitle" : lblTitle , "lblCount" : lblCount]
        
        //Constraint
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-bottomPadding-[btnClose]-topPadding-[mainScrollView]-topPadding-[lblTitle]-bottomPadding-|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainScrollView]|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftPadding-[lblTitle]-leftPadding-[lblCount(==150)]-leftPadding-|", options: [.alignAllBottom], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[btnClose]-rightPadding-|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
    }
    
    // MARK: - Public Interface -
    
    func setImages(showIndex : Int)
    {
        
        // Define string attributes
        let font = UIFont(name: FontStyle.bold, size: 13.0) ?? UIFont.systemFont(ofSize: 14.0)
        let textFont = [NSFontAttributeName:font]
        
        let fontItal = UIFont(name: FontStyle.bold, size: 13.0) ?? UIFont.systemFont(ofSize: 10.0)
        let italFont = [NSFontAttributeName:fontItal]
        
        // Create a string that will be our paragraph
        let para = NSMutableAttributedString()
        
        // Create locally formatted strings
        let attrString1 = NSAttributedString(string: (String(vehicleDetail.userVehicleName)?.uppercased())!, attributes:italFont)
        let n1 = NSAttributedString(string: "\n", attributes:textFont)
        let attrString2 = NSAttributedString(string: "PLATE # \(String(vehicleDetail.licensePlateNo).uppercased())", attributes:textFont)
        
        // Add locally formatted strings to paragraph
        para.append(attrString1)
        para.append(n1)
        para.append(attrString2)
        
        // Define paragraph styling
        let paraStyle = NSMutableParagraphStyle()
        //paraStyle.firstLineHeadIndent = 15.0
        paraStyle.alignment = .left
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.lineSpacing = 3.0
        
        // Apply paragraph styles to paragraph
        para.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: NSRange(location: 0,length: para.length))
        
        lblTitle.attributedText = para
        
        lblCount.text = "\(showIndex + 1) / \(vehicleDetail.vehicleImage.count)"
        mainScrollView.reloadData()
    }
    
    func setCloseButtonEvent(event :  @escaping ControlTouchUpInsideEvent)
    {
        self.btnClose.setButtonTouchUpInsideEvent(event)
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, willChangedCurrentPage currentPageIndex:NSInteger) {
        print("current page will be changed to \(currentPageIndex).")
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, didChangedCurrentPage currentPageIndex:NSInteger) {
       
        lblCount.text = "\(Int(currentPageIndex) + 1) / \(vehicleDetail.vehicleImage.count)"
        
        print("current page did changed to \(currentPageIndex).")
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, layoutSubview view:UIView) {
        print("paging control call layoutsubviews.")
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, recycledView view:UIView?, viewForIndex index:NSInteger) -> UIView {
        guard view == nil else { return view! }
        
        let zoomingView = ZoomingScrollView(frame: mainScrollView.bounds)
        //zoomingView.backgroundColor = UIColor.blue
        zoomingView.singleTapEvent = {
            print("single tapped...")
        }
        
        zoomingView.doubleTapEvent = {
            print("double tapped...")
        }
        
        zoomingView.pinchTapEvent = {
            print("pinched...")
        }
        
        return zoomingView
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, prepareShowPageView view:UIView, viewForIndex index:NSInteger) {
        guard let zoomingView = view as? ZoomingScrollView else { return }
        guard let zoomContentView = zoomingView.targetView as? ZoomContentView else { return }
        let vehicleImage : VehicleImage = vehicleDetail.vehicleImage[index]
        
        //let Url : URL = URL.init(string: vehicleImage.imagePath)!
        //zoomContentView.setImageWith(Url)
        
        zoomContentView.kf.indicator?.view.tintColor = UIColor.red
        let imageURL : URL? = URL(string: vehicleImage.imagePath)!
        
        zoomContentView.kf.setImage(with: imageURL, placeholder: nil, options: [KingfisherOptionsInfoItem.forceTransition], progressBlock: { (receivedSize, totalSize) in
            print("Download Progress: \(receivedSize)/\(totalSize)")
            
        }, completionHandler: { (image, error, cacheType, imageURL) in
            //print("Downloaded and set!")
            
            if(image ==  nil)
            {
                
            }
            else
            {
                zoomContentView.image = image
            }
            
        })
        
        // just call this methods after set image for resizing.
        zoomingView.prepareAfterCompleted()
        zoomingView.setMaxMinZoomScalesForCurrentBounds()
    }
    
    func startIndexOfPageWith(pagingScrollView:PagingScrollView) -> NSInteger {
        return 0
    }
    
    func numberOfPageWith(pagingScrollView:PagingScrollView) -> NSInteger {
        return vehicleDetail.vehicleImage.count
    }

    
    // MARK: - Server Request -
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
