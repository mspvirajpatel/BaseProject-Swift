//
//  SpeakerListController.swift
//  WMTSwiftDemo
//
//  Created by SamSol on 12/08/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit

class DataBaseController: BaseViewController {
    
    // MARK: - Attributes -
    
    var databaseView: DatabaseView!

    // MARK: - Lifecycle -
    
    override init() {
        
        databaseView = DatabaseView(frame: CGRect.zero)
        super.init(iView: databaseView, andNavigationTitle: "GRDB Database List")
      
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
     
        let customView = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(70.0), height: CGFloat(40.0)))
        
        
        let btn1 = UIButton(type: .roundedRect)
        btn1.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
        let buttonImage = UIImage(named: "refresh")!
        btn1.setImage(buttonImage, for: .normal)
        btn1.addTarget(databaseView, action: #selector(databaseView.reloadList), for: .touchUpInside)
        customView.addSubview(btn1)
        btn1.imageEdgeInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)
        
        
        let btn2 = UIButton(type: .roundedRect)
        btn2.frame = CGRect(x: CGFloat(40.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
        let buttonImage2 = UIImage(named: "add")!
        btn2.setImage(buttonImage2, for: .normal)
        btn2.addTarget(databaseView, action: #selector(databaseView.addNewPerson), for: .touchUpInside)
        customView.addSubview(btn2)
        btn2.imageEdgeInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)
        
        
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
