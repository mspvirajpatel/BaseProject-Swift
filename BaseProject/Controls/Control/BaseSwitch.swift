

import UIKit

class BaseSwitch: UIView {

    // MARK: - Attribute-
    var stateChangedEvent:SwitchStateChangedEvent!
    var sevenSwitch: SevenSwitch!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.loadViewControls()
        self.setViewControlsLayout()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit{
        stateChangedEvent = nil
        sevenSwitch = nil
    }
    
    // MARK: - Layout - 
    func loadViewControls(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = false
        
        self.backgroundColor = UIColor.clear
        
        sevenSwitch = SevenSwitch.init(frame: CGRect.zero)
        sevenSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sevenSwitch)
        sevenSwitch.addTarget(self, action:  #selector(self.switchChanged(sender:)), for: UIControlEvents.valueChanged)
                
        /*  sevenSwitch Allocation   */
        sevenSwitch.thumbView.layer.borderColor = UIColor.red.cgColor
        sevenSwitch.thumbView.layer.borderWidth = 1.2
        sevenSwitch.thumbView.layer.cornerRadius = 15.0
        sevenSwitch.thumbImageView.contentMode = UIViewContentMode.center
        
        sevenSwitch.thumbImage = UIImage(named: "switch_off")!
        
        sevenSwitch.thumbImageView.backgroundColor = UIColor.black
        
        sevenSwitch.thumbImageView.isUserInteractionEnabled = false
        
        sevenSwitch.activeColor = UIColor(rgbValue: 0x393C40, alpha: 1.0)
        
        sevenSwitch.inactiveColor = UIColor(rgbValue: 0x393C40, alpha: 1.0)
        
        sevenSwitch.onThumbTintColor = UIColor.clear
        
        sevenSwitch.onTintColor = UIColor(rgbValue: 0x393C40, alpha: 1.0)
        
        sevenSwitch.onThumbTintColor = UIColor.clear
        
        sevenSwitch.thumbBorderColor = UIColor(rgbValue: 0x393C40, alpha: 1.0)
        
        sevenSwitch.isRounded = true;
        
        self.layoutSubviews()
    }

    func setViewControlsLayout()
    {
        var baseLayout : AppBaseLayout!
        baseLayout = AppBaseLayout()
        
        baseLayout.expandView(sevenSwitch, insideView: self)
        
        let currentView:UIView = self;
        
        baseLayout.viewDictionary = ["currentView" : currentView]
        
        let viewWidth:CGFloat = 60.0
        let viewHeight:CGFloat = 30.0
        
        baseLayout.metrics = ["viewWidth" : viewWidth,
                                   "viewHeight" : viewHeight]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[currentView(viewWidth)]", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[currentView(viewHeight)]", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.releaseObject()
        baseLayout = nil
    }
    
    func setstate(state : Bool)
    {
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            self!.sevenSwitch.setOn(state, animated: true)
            if(self!.sevenSwitch.on)
            {
                self!.sevenSwitch.thumbImage = UIImage(named: "switch_on")!
                self!.sevenSwitch.thumbImageView.backgroundColor = Color.buttonPrimaryBG.value
            }
            else
            {
                self!.sevenSwitch.thumbImage = UIImage(named: "switch_off")!
                self!.sevenSwitch.thumbImageView.backgroundColor = UIColor(rgbValue: 0x00000, alpha: 1.0)
            }
        }
    }
    
    func getstate() -> Bool {
        return self.sevenSwitch.on
    }
   
    func setSwitchStateChangedEvent(_ event : @escaping SwitchStateChangedEvent) {
        stateChangedEvent = event
    }
    
    // MARK: - User Interaction
    func switchChanged(sender:SevenSwitch)  {
       
        if sender.on {
            self.sevenSwitch.thumbImage = UIImage(named: "switch_on")!
            self.sevenSwitch.thumbImageView.backgroundColor = Color.buttonPrimaryBG.value
            self.sevenSwitch.isRounded = true
        }
        else
        {
            self.sevenSwitch.thumbImage = UIImage(named: "switch_off")!
            self.sevenSwitch.thumbImageView.backgroundColor = UIColor(rgbValue: 0x00000, alpha: 1.0)
            self.sevenSwitch.isRounded = true
        }
        
        if(stateChangedEvent != nil){
            self.stateChangedEvent!(sender as AnyObject?, sender.on)
        }

    }

}
