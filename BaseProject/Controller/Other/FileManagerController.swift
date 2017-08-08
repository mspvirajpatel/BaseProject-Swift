//
//  FileManagerController.swift
//  BaseProjectSwift
//
//  Created by Viraj Patel on 05/04/17.
//  Copyright © 2017 Viraj Patel All rights reserved.
//

import UIKit

class FileManagerController: BaseViewController {

    // MARK: - Attributes -
    var fileManager : FileManagerView!
    
    // MARK: - Lifecycle -
    override init()
    {
        fileManager = FileManagerView(frame: CGRect.zero)
        super.init(iView: fileManager, andNavigationTitle: "File Manager")
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    deinit{
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideViewWithTopSpace()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
