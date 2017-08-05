//
//  PlistViewController.swift
//  WMTSwiftDemo
//
//  Created by SamSol on 14/09/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit

class PlistViewController: BaseViewController {

    // MARK: - Attributes -
    
    var plistView: PlistView!
    
    // MARK: - Lifecycle -
    
    override init() {
        
        plistView = PlistView(frame: CGRect.zero)
        super.init(iView: plistView, andNavigationTitle: "PList View")
        
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
    
    // MARK: - Public Interface -
    
    
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
    
}
