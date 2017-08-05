//
//  ShareListController.swift
//  BaseProjectSwift
//
//  Created by MacMini-2 on 13/02/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import UIKit

class ShareListController: BaseViewController {

    // MARK: - Attributes -
    
    var shareView: ShareView!
    
    // MARK: - Lifecycle -
    
    override init() {
        
        let subView : ShareView = ShareView(frame: CGRect.zero)
        super.init(iView: subView, andNavigationTitle: "Share Data List")
        
        shareView = subView
        
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
       
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        super.expandViewInsideViewWithTopSpace()
    }

}
