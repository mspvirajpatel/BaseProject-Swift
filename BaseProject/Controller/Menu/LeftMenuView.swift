//
//  LeftMenuView.swift
//  troopool
//
//  Created by WebMobTech-1 on 10/13/16.
//  Copyright © 2016 WebMobTech. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case unknownType = -1
    case home = 0
    case setting = 1
    case fileManager = 2
    case Gesture = 3
    case myFoundation = 4
    case UploadImage = 5
    case pageAnimation = 6
    case autolayout = 7
    case shareData = 8
    case coreData = 9
    case sliderView = 10
}

class LeftMenuView : BaseView , UITableViewDelegate, UITableViewDataSource{
    
    // Mark: - Attributes -
    
    var headerView : UIView!
    var imgHeaderbackgroung : BaseImageView!
    var imgCircle : BaseImageView!
    var lblUserName : BaseLabel!
    var lblUserEmailId : BaseLabel!
    
    var tableView : UITableView!
    var menus : NSMutableArray = NSMutableArray()
    
    var btnTouchUpInside:ControlTouchUpInsideEvent!
    
    fileprivate var selectedMenuItem : Int = 0
    
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgCircle.layer.borderWidth = 0.0
        imgCircle.layer.masksToBounds = true
        imgCircle.layer.borderColor = UIColor.black.cgColor
        imgCircle.layer.cornerRadius = imgCircle.bounds.width / 2
        imgCircle.clipsToBounds = true
    }
    
    deinit {
        
    }
    
    // MARK: - Layout -
    
    override func loadViewControls() {
        super.loadViewControls()
        self.backgroundColor = Color.appPrimaryBG.value
        
        
        menus = PListManager().readFromPlist("MainMenuList") as! NSMutableArray
        
        headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = UIColor.white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerView)
        headerView.layer.setValue("headerView", forKey: ControlLayout.name)
        
        imgHeaderbackgroung = BaseImageView(type: .profile, superView: headerView)
        imgHeaderbackgroung.backgroundColor = UIColor.clear
        imgHeaderbackgroung.layer.setValue("imgHeaderbackgroung", forKey: ControlLayout.name)
        
        imgCircle = BaseImageView(type: .profile, superView: headerView)
        imgCircle.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(LeftMenuView.profileImageTapped))
        imgCircle.addGestureRecognizer(tap)
        imgCircle.isUserInteractionEnabled = true
        imgCircle.layer.setValue("imgCircle", forKey: ControlLayout.name)
        
        lblUserName = BaseLabel(labelType: .medium, superView: headerView)
        lblUserName.textColor = Color.labelText.value
        lblUserName.layer.setValue("lblUserName", forKey: ControlLayout.name)
        
        lblUserEmailId = BaseLabel(labelType: .small, superView: headerView)
        lblUserEmailId.textColor = Color.labelText.value
        lblUserEmailId.layer.setValue("lblUserEmailId", forKey: ControlLayout.name)
        
        tableView = UITableView(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = Color.appPrimaryBG.value
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.addSubview(tableView)
        tableView.layer.setValue("tableView", forKey: ControlLayout.name)
        
        
        tableView.register(LeftMenuCell.self, forCellReuseIdentifier: CellIdentifire.leftMenu)
        
        imgHeaderbackgroung.contentMode = .scaleAspectFill
        imgHeaderbackgroung.clipsToBounds = true
        imgHeaderbackgroung.alpha = 0.5
        imgHeaderbackgroung.layer.setValue("imgHeaderbackgroung", forKey: ControlLayout.name)
        
        lblUserName.text = "Base Project"
        lblUserEmailId.text = "base@test.com"
        imgCircle.displayImageFromURL("usericon")
        imgHeaderbackgroung.displayImageFromURL("usericon")
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        
        let controlTopBottomPadding : CGFloat = ControlLayout.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlLayout.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V =  NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView(200)][tableView]|", options: [.alignAllRight, .alignAllLeft], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        //BackGround Image
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgHeaderbackgroung]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        headerView.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V =  NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgHeaderbackgroung]|", options: [.alignAllRight, .alignAllLeft], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        headerView.addConstraints(baseLayout.control_V)
        
        
        //Circle Image
        baseLayout.size_Height = NSLayoutConstraint(item: imgCircle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50.0)
        headerView.addConstraint(baseLayout.size_Height)
        
        baseLayout.size_Width = NSLayoutConstraint(item: imgCircle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 50.0)
        headerView.addConstraint(baseLayout.size_Width)
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: imgCircle, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        headerView.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.position_CenterY = NSLayoutConstraint(item: imgCircle, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        headerView.addConstraint(baseLayout.position_CenterY)
        
        
        //User Name Lable
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lblUserName]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        headerView.addConstraints(baseLayout.control_H)
        
        headerView.addConstraint(NSLayoutConstraint(item: lblUserName, attribute: .top, relatedBy: .equal, toItem: imgCircle, attribute: .bottom, multiplier: 1.0, constant: controlTopBottomPadding))
        
        
        //User email Id
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lblUserEmailId]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        headerView.addConstraints(baseLayout.control_H)
        
        headerView.addConstraint(NSLayoutConstraint(item: lblUserEmailId, attribute: .top, relatedBy: .equal, toItem: lblUserName, attribute: .bottom, multiplier: 1.0, constant: controlTopBottomPadding))
        
        
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    func btnTapped(closure: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = closure
    }
    
    
    // Mark: - Server request -
    
    
    // MARK: - Internal Helpers -
    
    func profileImageTapped()
    {
        //        btnTapped { (viewProfile, nil) in
        //
        //        }
    }
    
    
    
    //tableview Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : LeftMenuCell!
        cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.leftMenu) as? LeftMenuCell
        
        if cell == nil
        {
            cell = LeftMenuCell(style: UITableViewCellStyle.default, reuseIdentifier: CellIdentifire.leftMenu)
        }
        
        let dicDetail : NSDictionary = menus[(indexPath as NSIndexPath).row] as! NSDictionary
        
        cell.setViewContentDetail(dicDetail)
        
        if selectedMenuItem == (indexPath as NSIndexPath).row
        {
            cell.setSelectedCell(true)
        }
        else{
            cell.setSelectedCell(false)
        }
        
        let menuDictionary : NSDictionary = menus[(indexPath as NSIndexPath).row] as! NSDictionary
        let menuType : Int = Int(menuDictionary["type"] as! String)!
        
        if selectedMenuItem == menuType
        {
            cell.setSelectedCell(true)
        }
        else{
            cell.setSelectedCell(false)
        }
        
        
        return cell
    }
    
    
    func setSelectedMenuViewType(_ selectedMenuViewType: LeftMenu) {
        
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.none)
        selectedMenuItem = selectedMenuViewType.rawValue
        tableView.reloadData()
    
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView .deselectRow(at: indexPath, animated: true)
        self .endEditing(true)
        
        let menuDictionary : NSDictionary = menus[(indexPath as NSIndexPath).row] as! NSDictionary
        let menuType : Int = Int(menuDictionary["type"] as! String)!
        
        selectedMenuItem = (indexPath as NSIndexPath).row
        
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.none)
        
        
        if let _ = LeftMenu(rawValue: menuType) {
            
            let index33 = (indexPath as NSIndexPath).row
            btnTouchUpInside("true" as AnyObject, index33 as AnyObject )
            
        }
    }
    
}




