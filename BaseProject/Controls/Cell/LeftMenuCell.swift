//
//  LeftMenuCell.swift
//  Base Project
//
//  Created by Viraj Patel on 10/14/16.
//  Copyright @ 2017 Viraj Patel. All rights reserved.
//

import UIKit

class LeftMenuCell : UITableViewCell {
    
    // MARK: - Attributes -
    
    var baseLayout : AppBaseLayout!
    
    var innerView : UIView!
    var imgIcon : BaseImageView!
    var lblMenuText : BaseLabel!
    
    fileprivate var selectedView : UIView!
    
    fileprivate var gradientLayer : CAGradientLayer!
    fileprivate var selectedGradientLayer : CAGradientLayer!
    
    fileprivate var emitterLayer : CAEmitterLayer!
    fileprivate var emitterCell : CAEmitterCell!
    
    
    // MARK: - Lifecycle -
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        selectedGradientLayer.frame = self.contentView.bounds
        gradientLayer.frame = self.contentView.bounds
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted){
            self.contentView.backgroundColor = Color.appPrimaryBG.value
            
        }else{
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    
    // MARK: - Layout - 
    
    func loadViewControls(){
        
        baseLayout = AppBaseLayout()
        
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = false
        
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false
        
        
        //Selected Gradiant Layer Allocation
        selectedGradientLayer = CAGradientLayer()
        selectedGradientLayer.frame = self.contentView.bounds
        selectedGradientLayer.colors = [UIColor(rgbValue: 0xffffff, alpha: 0.05).cgColor, UIColor(rgbValue: 0xffffff, alpha: 0.05).cgColor, UIColor(rgbValue: 0xffffff, alpha: 0.05).cgColor]
        
        // Gradient Layer Allocation
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.contentView.bounds
        gradientLayer.colors = [UIColor(rgbValue: 0xffffff, alpha: 0.20).cgColor, UIColor(rgbValue: 0xffffff, alpha: 0.08).cgColor, UIColor(rgbValue: 0xffffff, alpha: 0.20).cgColor]
        
        
        innerView = UIView(frame: CGRect.zero)
        innerView.backgroundColor = UIColor.clear
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(innerView)
        
        imgIcon = BaseImageView(type: .unknown, superView: innerView)
        imgIcon.contentMode = .scaleAspectFit
        
        
        lblMenuText = BaseLabel(labelType: .large, superView: innerView)
        lblMenuText.textColor = UIColor.white
        lblMenuText.numberOfLines = 1
        
        
        // Selected View Allocation
        selectedView = UIView()
        selectedView.backgroundColor = UIColor(rgbValue: 0x111111, alpha: 0.4)
        self.selectedBackgroundView = selectedView
        selectedView.layer.insertSublayer(selectedGradientLayer, at: 0)
        
    }
    
    func setViewlayout(){
        
        baseLayout.viewDictionary = ["innerView" : innerView,
                                 "imgIcon" : imgIcon,
                                 "lblMenuText" : lblMenuText]
        
        let controlTopBottomPadding : CGFloat = ControlLayout.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlLayout.horizontalPadding
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                          "controlLeftRightPadding" : controlLeftRightPadding]
        
        
        
        //InnerView...
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[innerView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.contentView.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[innerView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.contentView.addConstraints(baseLayout.control_V)
        
        
        // ImageView...
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 30))
        
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30))
        
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .leading, relatedBy: .equal, toItem: innerView, attribute: .leading, multiplier: 1.0, constant: 10))
        
        innerView.addConstraint(NSLayoutConstraint(item: imgIcon, attribute: .centerY, relatedBy: .equal, toItem: innerView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        
        //Place Lable
        innerView.addConstraint(NSLayoutConstraint(item: lblMenuText, attribute: .leading, relatedBy: .equal, toItem: imgIcon, attribute: .trailing, multiplier: 1.0, constant: controlLeftRightPadding))
        
        innerView.addConstraint(NSLayoutConstraint(item: lblMenuText, attribute: .centerY, relatedBy: .equal, toItem: imgIcon, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        self.layoutIfNeeded()
        
    }
    
    func setViewContentDetail(_ dicDetail : NSDictionary) -> Void
    {
        self.tag = Int(dicDetail["type"] as! String)!
        lblMenuText.text = dicDetail["title"] as? String
   
        imgIcon.image = UIImage(named: "menu_home")
        
        let image = imgIcon.image?.withRenderingMode(.alwaysTemplate)
        imgIcon.image = image
        imgIcon.tintColor = UIColor.init(rgbValue: 0xffffff)
        
        // Your tint color
        imgIcon.tintColorDidChange()
//        lblMenuText.textColor = UIColor.init(rgbValue: 0xffffff)
        
        self .layoutSubviews()
    }
    
    
    func setSelectedCell(_ isSelected : Bool) -> Void
    {
        if isSelected
        {
            self.innerView.layer.insertSublayer(gradientLayer, at: 0)
            if emitterLayer != nil {
                self.contentView.layer.addSublayer(emitterLayer)
            }
        }
        else
        {
            self.contentView.backgroundColor = UIColor.clear
            gradientLayer.removeFromSuperlayer()
            
            if emitterLayer != nil {
                emitterLayer.removeFromSuperlayer()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
