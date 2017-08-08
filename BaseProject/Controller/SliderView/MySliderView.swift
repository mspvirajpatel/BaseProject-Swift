//
//  ShareView.swift
//  BaseProjectSwift
//
//  Created by Viraj Patel on 13/02/17.
//  Copyright © 2017 Viraj Patel All rights reserved.
//

import UIKit

class MySliderView: BaseView
{
 
    // MARK: - Attributes -
    
    var itemsToShare = [AnyObject]()
    var sliderView: SliderView!
   
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
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
    
    override func loadViewControls(){
        super.loadViewControls()
        
       
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
    
        self.layoutSubviews()
        
        
        
        // baseLayout.expandView(personListTableView, insideView: self)
        
    }
    
    
    // MARK: - Public Interface -
    
   
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
   
    // MARK: - Server Request -
    
    
    
    
}
