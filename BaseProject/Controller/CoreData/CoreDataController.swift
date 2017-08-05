//
//  SpeakerListController.swift
//  WMTSwiftDemo
//
//  Created by SamSol on 12/08/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit

class CoreDataController: BaseViewController {
    
    // MARK: - Attributes -
    
    var coreDataView: CoreDataView!

    // MARK: - Lifecycle -
    
    override init() {
        
        coreDataView = CoreDataView(frame: CGRect.zero)
        super.init(iView: coreDataView, andNavigationTitle: "Core Data")
      
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
     
        let customView = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(110.0), height: CGFloat(40.0)))
        let btn1 = UIButton(type: .roundedRect)
        btn1.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
        let buttonImage = UIImage(named: "refresh")!
        btn1.setImage(buttonImage, for: .normal)
        btn1.addTarget(coreDataView, action: #selector(coreDataView.reloadList), for: .touchUpInside)
        customView.addSubview(btn1)
        btn1.imageEdgeInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)
        
        
        let btn2 = UIButton(type: .roundedRect)
        btn2.frame = CGRect(x: CGFloat(40.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
        let buttonImage2 = UIImage(named: "add")!
        btn2.setImage(buttonImage2, for: .normal)
        btn2.addTarget(coreDataView, action: #selector(coreDataView.addNewtask), for: .touchUpInside)
        customView.addSubview(btn2)
        btn2.imageEdgeInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)
        
        
        let btn3 = UIButton(type: .roundedRect)
        btn3.frame = CGRect(x: CGFloat(80.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
        let buttonImage3 = UIImage(named: "add")!
        btn3.setImage(buttonImage3, for: .normal)
        btn3.addTarget(coreDataView, action: #selector(coreDataView.searchtask), for: .touchUpInside)
        customView.addSubview(btn3)
        btn3.imageEdgeInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)
        
        
        let rightBtn = UIBarButtonItem(customView: customView)
        rightBtn.tintColor = UIColor(rgbValue: 0xffffff, alpha: 0.7)
        self.navigationItem.rightBarButtonItem = rightBtn

    }
    
    override func setViewlayout(){
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    
    
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
   
    
    
}
