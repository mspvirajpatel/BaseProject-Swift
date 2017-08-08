//
//  PlistView.swift
//  WMTSwiftDemo
//
//  Created by Viraj Patel on 14/09/16.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import UIKit
import GRDB

class PlistView: BaseView,BaseRadioButtonDelegate ,XMSegmentedControlDelegate
{

    // MARK: - Attributes -
    
    var scrollView : BaseScrollView!
    
    var containerView : UIView!
    
    var nameTextField : BaseTextField!
    
    var emailIDTextField : BaseTextField!
    
    private var btnTermCheckBox : BaseButton!
    
    var addressTextView : BaseTextView!
   
    //for radiobutton
    var radioButtonController: BaseRadioButton?
    
    fileprivate var radioButton1 : BaseButton!
    fileprivate var radioButton2 : BaseButton!
    fileprivate var radioButton3 : BaseButton!
    
    var segmentControl: SegmentedControl!
   
    fileprivate var dropdown : BaseButton!
    
    var lbllongPressText:BaseLabel!
    
    var stateSwitch:BaseSwitch!
    
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
        
        segmentControl = nil
        
        scrollView = nil
        containerView = nil
        
        nameTextField = nil
      
        emailIDTextField = nil
        
        addressTextView = nil

    }
    
    // MARK: - Layout - 
    
    override func loadViewControls(){
        super.loadViewControls()
        
        segmentControl = SegmentedControl()
        segmentControl.segmentTitle = ["Hello", "World", "Three", "World", "Three", "World", "Three"]
        segmentControl.selectedItemHighlightStyle = XMSelectedItemHighlightStyle.bottomEdge
        
        segmentControl.backgroundColor = Color.buttonSecondaryBG.value
        segmentControl.highlightColor = Color.buttonPrimaryBG.value
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.pressTabWithIndex(1)
        segmentControl.delegate = self
        
        segmentControl.tint = UIColor.white
        segmentControl.highlightTint = UIColor.black
        self.addSubview(segmentControl)
        segmentControl.layer.setValue("segmentControl", forKey: ControlLayout.name)
        
        scrollView = BaseScrollView.init(superView: self)
        scrollView.layer.setValue("scrollView", forKey: ControlLayout.name)
        
        containerView = scrollView.container
        containerView.layer.setValue("containerView", forKey: ControlLayout.name)
        
        nameTextField = BaseTextField(iSuperView: containerView)
        nameTextField.placeholder = "Name"
        nameTextField.layer.setValue("name", forKey: APIConstant.controlRequestKey)
        nameTextField.layer.setValue("nameTextField", forKey: ControlLayout.name)
        
        emailIDTextField = BaseTextField(iSuperView: containerView)
        emailIDTextField.placeholder = "Email ID"
        emailIDTextField.layer.setValue("emailid", forKey: APIConstant.controlRequestKey)
        emailIDTextField.layer.setValue("emailIDTextField", forKey: ControlLayout.name)
        
        addressTextView = BaseTextView(iSuperView: containerView)
        addressTextView.placeholder = "Local Address"
        addressTextView.layer.setValue("address", forKey: APIConstant.controlRequestKey)
        addressTextView.layer.setValue("addressTextView", forKey: ControlLayout.name)
        addressTextView.isMultiLinesSupported = true
        
        btnTermCheckBox = BaseButton(ibuttonType: BaseButtonType.checkbox, iSuperView: containerView)
        btnTermCheckBox.layer.setValue("btnTermCheckBox", forKey: ControlLayout.name)
        btnTermCheckBox .setButtonTouchUpInsideEvent { (sender, object) in
           // self.btnCreateAccount.enabled = self.btnTermCheckBox.selected
        }
        
        
        radioButton1 = BaseButton(ibuttonType:.radio,iSuperView: containerView)
        radioButton1.setTitle("Home", for: UIControlState())
        radioButton1.tag = 1
        radioButton1.layer.setValue("radioButton1", forKey: ControlLayout.name)
        
        radioButton2 = BaseButton(ibuttonType:.radio,iSuperView: containerView)
        radioButton2.setTitle("Work", for: UIControlState())
        radioButton2.tag = 2
        radioButtonController?.addButton(radioButton2)
        radioButton2.layer.setValue("radioButton2", forKey: ControlLayout.name)
        
        radioButton3 = BaseButton(ibuttonType:.radio,iSuperView: containerView)
        radioButton3.setTitle("Other", for: UIControlState())
        radioButton3.tag = 3
        radioButtonController?.addButton(radioButton3)
        radioButton3.layer.setValue("radioButton3", forKey: ControlLayout.name)
        
        radioButtonController = BaseRadioButton(buttons: radioButton1,radioButton2,radioButton3)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        radioButtonController?.pressed(radioButton2)
      
        
        lbllongPressText = BaseLabel(labelType: .large, superView: containerView)
        lbllongPressText.textColor = UIColor.black
        lbllongPressText.numberOfLines = 1
        lbllongPressText.text = "Switch off"
        lbllongPressText.textAlignment = .left
        lbllongPressText.layer.setValue("lbllongPressText", forKey: ControlLayout.name)
        
        stateSwitch = BaseSwitch.init(frame: CGRect.zero)
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        stateSwitch.setSwitchStateChangedEvent { (AnyObject, Bool) in
           
            if Bool!
            {
                self.lbllongPressText.text = "Switch on"
            }
            else
            {
                self.lbllongPressText.text = "Switch off"
            }
            
        }
        stateSwitch.layer.setValue("stateSwitch", forKey: ControlLayout.name)
        containerView.addSubview(stateSwitch)
        
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
   
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        
        let controlTopBottomPadding : CGFloat = ControlLayout.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlLayout.horizontalPadding
        let segmentControlHeight : CGFloat = 40.0
        let bigViewHeight : CGFloat = 100.0
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                          "controlLeftRightPadding" : controlLeftRightPadding,
                          "bigViewHeight" : bigViewHeight,
                          "segmentControlHeight" : segmentControlHeight
            
                          ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[segmentControl(segmentControlHeight)]-[scrollView]", options:[.alignAllLeft, .alignAllRight], metrics: baseLayout.metrics , views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollView(==containerView)]", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_V)
       
       
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[nameTextField]-controlLeftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameTextField]-controlTopBottomPadding-[emailIDTextField]-controlTopBottomPadding-[addressTextView(bigViewHeight)]", options:[.alignAllLeft, .alignAllRight], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints(baseLayout.control_V)
        
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[btnTermCheckBox]", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[addressTextView(bigViewHeight)]-[btnTermCheckBox]-[radioButton1]-[radioButton2]-[radioButton3]", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints(baseLayout.control_V)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[radioButton1]-controlLeftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        containerView.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[radioButton2]-controlLeftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        containerView.addConstraints(baseLayout.control_H)
     
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[radioButton3]-controlLeftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        containerView.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[lbllongPressText(>=1)]-controlLeftRightPadding-[stateSwitch]-controlLeftRightPadding-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.position_Top = NSLayoutConstraint(item: lbllongPressText, attribute: .top, relatedBy: .equal, toItem: radioButton3, attribute: .bottom, multiplier: 1.0, constant: controlTopBottomPadding)
        
        containerView.addConstraints(baseLayout.control_H)
        containerView.addConstraints([baseLayout.position_Top])
        
        baseLayout.position_CenterY = NSLayoutConstraint(item: stateSwitch, attribute: .centerY, relatedBy: .equal, toItem: lbllongPressText, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        containerView.addConstraints([baseLayout.position_CenterY])
        
        self.layoutSubviews()
        scrollView.layoutSubviews()
        scrollView.setScrollViewContentSize()
       
    }
    
    // MARK: - Public Interface -
  
    func didSelectButton(_ aButton: BaseButton?) {
        let currentButton = radioButtonController!.selectedButton()!
        print("\(currentButton.tag)")
       
        if currentButton.tag == 1 {
            let controller : DriverPhotoViewerViewController = DriverPhotoViewerViewController()
            let data:ReservationScheduleModel = ReservationScheduleModel()
            data.userVehicleName = "Demo"
            data.licensePlateNo = "FHJK#hufhj"
            let dataimage1:VehicleImage = VehicleImage()
            dataimage1.imagePath = "http://www.anglospanishcollections.com/images/vehicle.png"
            
            let dataimage2:VehicleImage = VehicleImage()
            dataimage2.imagePath = "http://cdn.bmwblog.com/wp-content/uploads/bmw-emergency-vehicles-02-750x500.jpg"
            
            let dataimage3:VehicleImage = VehicleImage()
            dataimage3.imagePath = "https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FOCU_2012-1.png"
            
            data.vehicleImage = [dataimage1,dataimage2,dataimage3]
            
            controller.driverPhotoViewerView.vehicleDetail = data
            
            self.getViewControllerFromSubView()?.present(controller, animated: true, completion: {
                controller.driverPhotoViewerView.setImages(showIndex: 0)
                }
            )
        }
        
        if currentButton.tag == 2 {
            
        }
        
        if currentButton.tag == 3
        {
            
        }
        
    }
    
    func xmSegmentedControl(_ xmSegmentedControl: SegmentedControl, selectedSegment: Int) {
        if xmSegmentedControl == segmentControl {
            print("SegmentedControl1 Selected Segment: \(selectedSegment)")
           
//          if selectedSegment == 0
//          {
//            
//            }
        }
    }
    
    // MARK: - User Interaction -

  
    
    // MARK: - Internal Helpers -
    
    
    
    // MARK: - Server Request -
    
    
    
    
    

}

