//
//  DriverPhotoViewerViewController.swift
//  GasdropDriver
//
//  Created by Viraj Patel on 14/10/16.
//  Copyright @ 2017 Viraj Patel. All rights reserved.
//

import UIKit

class DriverPhotoViewerViewController: BaseViewController {

    var driverPhotoViewerView : DriverPhotoViewerView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override init()
    {
        driverPhotoViewerView = DriverPhotoViewerView(frame: CGRect.zero)
        super.init(iView: driverPhotoViewerView)
        
        self.loadViewControls()
        self.setViewControlsLayout()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Layout -
    internal override func loadViewControls() -> Void
    {
        super.loadViewControls()
    }
    
    private func setViewControlsLayout() -> Void
    {
        super.setViewlayout()
        super.expandViewInsideView()
        
        driverPhotoViewerView.setCloseButtonEvent { (sender, object) in
            self .dismiss(animated: true, completion: nil)
        }
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
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
