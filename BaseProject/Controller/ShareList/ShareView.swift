//
//  ShareView.swift
//  BaseProjectSwift
//
//  Created by MacMini-2 on 13/02/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import UIKit


class ShareView: BaseView , UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate
{
 
    // MARK: - Attributes -
    
    let cellIdentifier = "cellIdentifier"
    var shareListTableView : UITableView!
    
    var itemsToShare = [AnyObject]()
    
    var sampleString1 = "Evernote is awesome"
    var sampleString2 = "Scannable is easy and intuitive to use"
    var sampleString3 = "I use Viraj"
    var sampleURL1 = URL(string: "https://test1.com/")
    var sampleURL2 = URL(string: "https://test2.com/")
    var sampleURL3 = URL(string: "https://test.com/")
    var sampleImage1 = UIImage(named: "logo")
    var sampleImage2 = UIImage(named: "logo")
    var sampleImage3 = UIImage(named: "logo")
 
    var actionArray: [String] = ["Share text", "Share URL", "Share text + URL", "Share multiple texts", "Share multiple URLs", "Share image", "Share image + text", "Share image + URL", "Share image + text + URL", "Share multiple images"]
    // var person: Person!
   
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
        shareListTableView = nil
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
        shareListTableView = UITableView(frame: CGRect.zero, style: .plain)
        shareListTableView.translatesAutoresizingMaskIntoConstraints = false
        shareListTableView.layer.setValue("shareListTableView", forKey: ControlLayout.name)
        
        //shareListTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifire.defaultCell)
        
        shareListTableView.backgroundColor = UIColor.clear
        shareListTableView.separatorStyle = .singleLine

        shareListTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        shareListTableView.separatorColor = Color.buttonSecondaryBG.value
        
        shareListTableView.clipsToBounds = true
        
        shareListTableView.tableHeaderView = UIView(frame: CGRect.zero)
        shareListTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        shareListTableView.rowHeight = UITableViewAutomaticDimension
        self.addSubview(shareListTableView)
        
        shareListTableView.delegate = self
        shareListTableView.dataSource = self
        
        self.shareListTableView.reloadData()
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlLayout.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlLayout.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[shareListTableView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[shareListTableView]-|", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
    
        self.layoutSubviews()
        
        
        
        // baseLayout.expandView(personListTableView, insideView: self)
        
    }
    
    
    // MARK: - Public Interface -
    
    public func reloadList(){
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            self.shareListTableView.reloadData()
        }
    }
    
   
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
   
    // MARK: - Server Request -
    
    
    
    // MARK: - UITableView DataSource Methods -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = nil
        
        cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)! as UITableViewCell
        
        cell?.textLabel?.text = self.actionArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemsToShare = [AnyObject]()
        switch (indexPath.row) {
        case 0:
            self.itemsToShare.append(sampleString1 as AnyObject)
        case 1:
            self.itemsToShare.append(sampleURL3! as AnyObject)
        case 2:
            self.itemsToShare.append(sampleString2 as AnyObject)
            self.itemsToShare.append(sampleURL2! as AnyObject)
        case 3:
            self.itemsToShare.append(sampleString1 as AnyObject)
            self.itemsToShare.append(sampleString2 as AnyObject)
            self.itemsToShare.append(sampleString3 as AnyObject)
        case 4:
            self.itemsToShare.append(sampleURL1! as AnyObject)
            self.itemsToShare.append(sampleURL2! as AnyObject)
            self.itemsToShare.append(sampleURL3! as AnyObject)
        case 5:
            self.itemsToShare.append(sampleImage1!)
        case 6:
            self.itemsToShare.append(sampleImage2!)
            self.itemsToShare.append(sampleString1 as AnyObject)
        case 7:
            self.itemsToShare.append(sampleImage3!)
            self.itemsToShare.append(sampleURL2! as AnyObject)
        case 8:
            self.itemsToShare.append(sampleImage1!)
            self.itemsToShare.append(sampleString2 as AnyObject)
            self.itemsToShare.append(sampleURL3! as AnyObject)
        case 9:
            self.itemsToShare.append(sampleImage1!)
            self.itemsToShare.append(sampleImage2!)
            self.itemsToShare.append(sampleImage3!)
        
            
        default:
            assertionFailure("unexpected indexPath.row")
        }
        
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        if (activityViewController.popoverPresentationController != nil) {
            activityViewController.popoverPresentationController!.sourceView = self.shareListTableView.cellForRow(at: indexPath)
        }
      
        let UIViewControl: UIViewController = InterfaceUtility.getViewControllerForAlertController() as! UIViewController
        
        UIViewControl.present(activityViewController, animated: true, completion: nil)

    }
    
    // MARK: - UITableView Delegate Methods -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let cellHeight : CGFloat = 90.0
        
        return cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Delete the person
        
    }
    
}
