//
//  DisplayAllImageController.swift
//  BaseProjectSwift
//
//  Created by WebMob on 28/11/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit

class DisplayAllImageController: BaseViewController {

    var displayImageView : DisplayAllImageView?
  
    // MARK: - Lifecycle -
    override init()
    {
        displayImageView = DisplayAllImageView(frame: CGRect.zero)
        
        super.init(iView: displayImageView!, andNavigationTitle: "Display All Image")
        
        self.loadViewControls()
        self.setViewControlsLayout()
       
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Layout -
    internal override func loadViewControls() -> Void
    {
        super.loadViewControls()
        
        let customView = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(70.0), height: CGFloat(40.0)))
        let btn1 = UIButton(type: .roundedRect)
        btn1.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
        let buttonImage = UIImage(named: "refresh")!
        btn1.setImage(buttonImage, for: .normal)
        btn1.addTarget(displayImageView, action: #selector(displayImageView?.getAllImagesRequest), for: .touchUpInside)
        customView.addSubview(btn1)
        btn1.imageEdgeInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)
        let btn2 = UIButton(type: .roundedRect)
        btn2.frame = CGRect(x: CGFloat(40.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
        let buttonImage2 = UIImage(named: "delete")!
        btn2.setImage(buttonImage2, for: .normal)
        btn2.addTarget(displayImageView, action: #selector(displayImageView?.deleteAllImagesRequest), for: .touchUpInside)
        customView.addSubview(btn2)
        btn2.imageEdgeInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)
        
        let rightBtn = UIBarButtonItem(customView: customView)
        rightBtn.tintColor = UIColor(rgbValue: 0xffffff, alpha: 0.7)
        self.navigationItem.rightBarButtonItem = rightBtn

    }
    
    private func setViewControlsLayout() -> Void
    {
        super.setViewlayout()
        super.expandViewInsideViewWithTopSpace()
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Server Request -
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
