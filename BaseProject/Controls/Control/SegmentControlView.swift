//
//  SegmentControlView.swift
//  ViewControllerDemo
//
//  Created by Viraj Patel on 01/07/16.
//  Copyright @ 2017 Viraj Patel. All rights reserved.
//

import UIKit

struct SegmentControlViewConstants {
    
    static var KSegementSelectedTitleColor = Color.segmentSelectedTitle.value
    static var KSegementSelectedBackgroundColor = Color.segmentSelectedBG.value
    
    static var KSegementDeselectedTitleColor = Color.segmentTitle.value
    static var KSegementBackgroundColor = Color.segmentBG.value
    
    static var KSegmentBorderColor = Color.segmentBorder.value
    static var KSegmentBorderWidth : CGFloat = 2.0
    
    static var kSegmentButtonFont = UIFont(name: FontStyle.bold, size: 17.0)
    static var KSegmentViewHeight : CGFloat = 50.0
    
    static var KhighlightBackgroundColor = Color.segmentSelectedTitle.withAlpha(0.1)
    
}

typealias SegmentTabbedEvent = (_ index : Int) -> ()

class SegmentControlView: UIView {
    
    
    // MARK: - Attributes -
    
    var segmentViewHeight : CGFloat = SegmentControlViewConstants.KSegmentViewHeight
    var tabbedEventBlock : SegmentTabbedEvent?
    
    
    // MARK: - Lifecycle -
    
    init(titleArray : [String], iSuperView : UIView){
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        iSuperView.addSubview(self)
        
        self.loadViewWithTitleArray(titleArray)
        self.setViewLayout()
    }
    
    init(titleArray : [String], iSuperView : UIView, height : CGFloat){
        super.init(frame: CGRect.zero)
        
        segmentViewHeight = height
        
        self.translatesAutoresizingMaskIntoConstraints = false
        iSuperView.addSubview(self)
        
        self.loadViewWithTitleArray(titleArray)
        self.setViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        for button in self.subviews {
            if button.tag == 0 {
                button.setBottomBorder(SegmentControlViewConstants.KSegmentBorderColor, width: SegmentControlViewConstants.KSegmentBorderWidth)
            }
            
        }
        
        
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    
    func loadViewWithTitleArray(_ titleArray : [String]){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = false
        
        self.backgroundColor = UIColor.white
        var segementButtonTag : Int = 0
        
        for titleString in titleArray {
            
            let segementButton : UIButton = UIButton(type: .custom)
            segementButton.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(segementButton)
            segementButton.clipsToBounds = true
            
            segementButton.titleLabel?.lineBreakMode = .byWordWrapping
            segementButton.titleLabel?.textAlignment = .center
            
            segementButton.backgroundColor = UIColor.white
            segementButton.setTitle(titleString, for: UIControlState())
            
            segementButton.titleLabel?.font = SegmentControlViewConstants.kSegmentButtonFont
            segementButton.setTitleColor(SegmentControlViewConstants.KSegementDeselectedTitleColor, for: UIControlState())
            segementButton.tag = segementButtonTag
            segementButton.addTarget(self, action: #selector(segmentTabbed), for: .touchUpInside)
            
            segementButtonTag = segementButtonTag + 1
            
            segementButton.addTarget(self, action: #selector(buttonTouchUpInsideAction), for: .touchUpInside)
            segementButton.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchUpOutside)
            segementButton.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchCancel)
            segementButton.addTarget(self, action: #selector(buttonTouchDownAction), for: .touchDown)
            
            
        }
    }
    
    func setViewLayout(){
        
        var segementSubView, prevSegementSubView : UIView?
        var segementSubViewDictionary : [String : AnyObject]?
        var segementSubViewConstraints : Array<NSLayoutConstraint>?
        
        var control_H, control_V : Array<NSLayoutConstraint>?
        let viewDictionary = ["BBSegmentView" : self]
        let metrics = ["BBSegmentViewHeight" : segmentViewHeight]
        
        control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[BBSegmentView(>=0)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        
        control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[BBSegmentView(BBSegmentViewHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewDictionary)
        
        self.addConstraints(control_H!)
        self.addConstraints(control_V!)
        
        let segementSubViewCount = self.subviews.count
        prevSegementSubView = nil
        
        for i in 0...(segementSubViewCount - 1) {
            
            segementSubView = self.subviews[i]
            if(prevSegementSubView == nil){
                segementSubViewDictionary = ["segementSubView" : segementSubView!]
                
            }else{
                segementSubViewDictionary = ["segementSubView" : segementSubView!,
                                             "prevSegementSubView" : prevSegementSubView!]
            }
            
            segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[segementSubView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: segementSubViewDictionary!)
            self.addConstraints(segementSubViewConstraints!)
            
            segementSubViewConstraints = nil
            
            if(segementSubViewCount > 2){
                
                switch i {
                    
                case 0:
                    
                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[segementSubView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: segementSubViewDictionary!)
                    
                    break
                    
                case (segementSubViewCount - 1):
                    
                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevSegementSubView][segementSubView(==prevSegementSubView)]|", options:[.alignAllTop, .alignAllBottom], metrics: nil, views: segementSubViewDictionary!)
                    
                    break
                    
                default:
                    
                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevSegementSubView][segementSubView(==prevSegementSubView)]", options:[.alignAllTop, .alignAllBottom], metrics: nil, views: segementSubViewDictionary!)
                    
                    break
                }
                
                
            }else{
                
                switch i {
                    
                case 0:
                    
                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[segementSubView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: segementSubViewDictionary!)
                    
                    break
                    
                case (segementSubViewCount - 1):
                    
                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevSegementSubView][segementSubView(==prevSegementSubView)]|", options:[.alignAllTop, .alignAllBottom], metrics: nil, views: segementSubViewDictionary!)
                    
                    break
                    
                default:
                    break
                }
                
            }
            
            prevSegementSubView = segementSubView
            self.addConstraints(segementSubViewConstraints!)
            
            segementSubViewConstraints = nil
            segementSubViewDictionary = nil
            segementSubView = nil
            
        }
        
        self.layoutSubviews()
    }
    
    // MARK: - Public Interface -
    
    func setTitleOnSegment(_ titleArray : [String]){
        
        if(titleArray.count <= self.subviews.count && titleArray.count != 0){
            
            var i : Int = 0
            for titleString in titleArray {
                
                let button : UIButton = self.subviews[i] as! UIButton
                button.setTitle(titleString, for: UIControlState())
                
                i = i + 1
            }
            
        }
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        
    }
    
    func setSegmentTabbedEvent(_ iTabbedEventBlock : @escaping SegmentTabbedEvent){
        tabbedEventBlock = iTabbedEventBlock
    }
    
    func setSegementSelectedAtIndex(_ index : Int){
        AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
            if self == nil{
                return
            }
            
            self!.layoutSubviews()
            self!.layoutIfNeeded()
            
            let subViewCount = self!.subviews.count
            if(index < subViewCount){
                
                let currentButton : UIButton = self!.subviews[index] as! UIButton
                currentButton.setBottomBorder(SegmentControlViewConstants.KSegmentBorderColor, width: SegmentControlViewConstants.KSegmentBorderWidth)
                currentButton.setTitleColor(SegmentControlViewConstants.KSegementSelectedTitleColor, for: UIControlState())
                
                for view in self!.subviews {
                    
                    let button : UIButton = view as! UIButton
                    
                    if(button.tag != currentButton.tag){
                        button.setTitleColor(SegmentControlViewConstants.KSegementDeselectedTitleColor, for: UIControlState())
                        button.setBottomBorder(UIColor.clear, width: SegmentControlViewConstants.KSegmentBorderWidth)
                    }
                }
            }
        }
    }
    
    // MARK: - User Interaction -
    
    func segmentTabbed(_ sender : AnyObject){
        let currentButton : UIButton = (sender as? UIButton)!
        currentButton.setBottomBorder(SegmentControlViewConstants.KSegmentBorderColor, width: SegmentControlViewConstants.KSegmentBorderWidth)
        currentButton.setTitleColor(SegmentControlViewConstants.KSegementSelectedTitleColor, for: UIControlState())
        
        for view in self.subviews {
            
            let button : UIButton = view as! UIButton
            
            if(button.tag != currentButton.tag){
                
                button.setTitleColor(SegmentControlViewConstants.KSegementDeselectedTitleColor, for: UIControlState())
                button.setBottomBorder(UIColor.clear, width: SegmentControlViewConstants.KSegmentBorderWidth)
            }
        }
        
        if(tabbedEventBlock != nil){
            tabbedEventBlock!((currentButton.tag))
        }
    }
    
    // MARK: - Internal Helpers -
    //Only for button touch Effect
    
    @objc private func buttonTouchUpInsideAction(_ sender : UIButton) {
        sender.backgroundColor = SegmentControlViewConstants.KSegementBackgroundColor
    }
    @objc private func buttonTouchDownAction(_ sender : UIButton) {
        sender.backgroundColor = SegmentControlViewConstants.KhighlightBackgroundColor
    }
    
    @objc private func buttonTouchUpOutsideAction(_ sender : UIButton) {
        sender.backgroundColor = SegmentControlViewConstants.KSegementBackgroundColor
    }
    
    
}
