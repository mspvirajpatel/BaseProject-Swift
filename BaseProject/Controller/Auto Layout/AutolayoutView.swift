//
//  AutolayoutView.swift
//  BaseProjectSwift
//
//  Created by WebMob on 02/02/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import UIKit

class AutolayoutView: BaseView {

    // MARK: - Attribute -
    var newsCard : NewsCardView!
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.loadViewControls()
        self.setViewlayout()
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
        newsCard = NewsCardView(frame: CGRect.zero)
        self.addSubview(newsCard)
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.expandView(newsCard, insideView: self)
    }
    
    // MARK: - Public Interface -
    public func viewRotateEvent(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        newsCard.viewRotateEvent(to: size, with: coordinator)
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -

}
