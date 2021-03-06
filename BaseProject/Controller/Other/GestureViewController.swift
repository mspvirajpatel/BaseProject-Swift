//
//  GestureViewController.swift
//  BaseProjectSwift
//
//  Created by Viraj Patel on 21/11/16.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import UIKit


class GestureViewController: BaseViewController {
  
    var gestureView : GestureView!
    
    var pagename :String! = ""
    
    
    // MARK: - Lifecycle -
    
    override init()
    {
        let subView : GestureView = GestureView(frame: CGRect.zero)
        
        super.init(iView: subView, andNavigationTitle: "Gesture View")
        gestureView = subView
        
        self.loadViewControls()
        self.setViewControlsLayout()
        self.displayMenuButton()
       
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout -
    internal override func loadViewControls() -> Void
    {
        super.loadViewControls()
        self.gestureView.setButtonSelectEvent({ (sender, object) in
            
            if(sender as? String == "Home")
            {
               
            }
            else
            {
                NotificationManager.sharedInstance.setSelectedMenuViewType(LeftMenu.home.rawValue)
            }
           
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = self.pagename
        self.aView.endEditing(true)
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

