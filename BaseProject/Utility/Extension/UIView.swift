

import Foundation
import UIKit
extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var y: CGFloat{
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    

    public var height: CGFloat{
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    

    public var bottom: CGFloat{
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    

    public var right: CGFloat{
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }

    public var size: CGSize{
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }

    public var centerX: CGFloat{
        get {
            return self.center.x
        }
        
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    

    public var centerY: CGFloat{
        get {
            return self.center.y
        }
        
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
}

public extension UIView {
    
    func setOrigin(_ point:CGPoint)
    {
        self.frame.origin = point
    }
    
    func roundCorner(_ radius:CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func setTop(_ top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    func setLeft(_ left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    public func isTextControl() -> Bool{
        return (self.isTextFieldControl() || self.isTextViewControl())
    }
    
    public func isTextFieldControl() -> Bool{
        return self.isKind(of: UITextField.self)
    }
    
    public func isTextViewControl() -> Bool{
        return self.isKind(of: UITextView.self)
    }
    
    public func getRequestDictionaryFromView() -> [String: String]{
        
        var textControl : AnyObject?
        var textFromTextControl : String?
        var requestKey : String?
        
        var requestDictionary : [String: String] = Dictionary()
        
        for view in self.subviews {
            
            if(view.isTextControl()){
                
                if(view.isTextFieldControl()){
                    
                    textControl = view as? UITextField
                    textFromTextControl = textControl!.text
                    
                }else if(view.isTextViewControl()){
                    
                    textControl = view as? UITextView
                    textFromTextControl = textControl!.text
                    
                }
                
                requestKey = view.layer.value(forKey: APIConstant.controlRequestKey) as? String
                if(requestKey != nil && textFromTextControl != nil){
                    
                    requestDictionary[requestKey!] = textFromTextControl
                    
                }
                
            }
            
        }
        
        textControl = nil
        textFromTextControl = nil
        requestKey = nil
        
        return requestDictionary
        
    }
    
    func getDictionaryOfVariableBindings(superView : UIView , viewDic : NSDictionary) -> NSDictionary
    {
        var dicView : NSMutableDictionary = viewDic.mutableCopy() as! NSMutableDictionary
        
        if superView.subviews.count > 0
        {
            if let viewName = superView.layer .value(forKeyPath: ControlLayout.name) as? String
            {
                dicView .setValue(superView, forKey: viewName)
            }
            
            for view in superView.subviews
            {
                if view.subviews.count > 0
                {
                    dicView = self.getDictionaryOfVariableBindings(superView: view , viewDic: dicView) .mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    if let viewName = view.layer .value(forKeyPath: ControlLayout.name) as? String{
                        dicView .setValue(view, forKey: viewName)
                    }
                }
            }
        }
        else
        {
            if let viewName = superView.layer .value(forKeyPath: ControlLayout.name) as? String{
                dicView .setValue(superView, forKey: viewName)
            }
        }
        
        return dicView
    }
    
    
    func getDictionaryOfVariableBindings(viewArray : [UIView]) -> NSDictionary{
        
        let dicView : NSMutableDictionary = NSMutableDictionary()
        
        for view in viewArray{
            if let viewName = view.layer .value(forKey: ControlLayout.name) as? String{
                dicView .setValue(view, forKey: viewName)
            }
        }
        
        return dicView
    }
    
    public func setBorder(_ borderColor: UIColor, width: CGFloat, radius: CGFloat){
        
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        
    }
    
    public func setTopBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "upper_layer"
        var upperBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                upperBorder = layer
                break
            }
        }
        
        if(upperBorder == nil){
            upperBorder = CALayer()
        }
        
        upperBorder!.name = layerName
        upperBorder!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1.0)
        
        upperBorder!.borderWidth = width
        upperBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(upperBorder!)
    }
    
    public func setBottomBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "bottom_layer"
        var bottomBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                bottomBorder = layer
                break
            }
        }
        
        if(bottomBorder == nil){
            bottomBorder = CALayer()
        }
        
        bottomBorder!.name = layerName
        bottomBorder!.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        
        bottomBorder!.borderWidth = width
        bottomBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(bottomBorder!)
        
    }
    
//    container.addBorder(edges: [.all]) // All with default arguments
//    container.addBorder(edges: [.top], color: UIColor.greenColor()) // Just Top, green, default thickness
//    container.addBorder(edges: [.left, .right, .bottom], color: UIColor.redColor(), thickness: 3) // All except Top, red, thickness 3
    func addBorder(edges: UIRectEdge, color: UIColor = UIColor.white, thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
    
    public func setBottomBorder(_ borderColor: UIColor, width: CGFloat, leftRightSpace: CGFloat) {
        
        let layerName: String = "bottom_layer"
        var bottomBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                bottomBorder = layer
                break
            }
        }
        
        if(bottomBorder == nil){
            bottomBorder = CALayer()
        }
        
        bottomBorder!.name = layerName
        bottomBorder!.frame = CGRect(x: 0 + leftRightSpace, y: self.frame.height - width, width: self.bounds.width - (leftRightSpace*2), height: width)
        
        bottomBorder!.borderWidth = width
        bottomBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(bottomBorder!)
        
    }
    
    public func setLeftBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "left_layer"
        var leftBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                leftBorder = layer
                break
            }
        }
        
        if(leftBorder == nil){
            leftBorder = CALayer()
        }
        
        leftBorder!.name = layerName
        leftBorder!.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        
        leftBorder!.borderWidth = width
        leftBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(leftBorder!)
    }
    
    public func setRightBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "right_layer"
        var rightBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                rightBorder = layer
                break
            }
        }
        
        if(rightBorder == nil){
            rightBorder = CALayer()
        }
        
        rightBorder!.name = layerName
        rightBorder!.frame = CGRect(x: 0, y: self.frame.width, width: width, height: self.frame.height)
        
        rightBorder!.borderWidth = width
        rightBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(rightBorder!)
    }
    
    public func setCircleViewWith(_ borderColor: UIColor, width: CGFloat) {
        
        self.layer.cornerRadius = (self.frame.size.width / 2)
        self.layer.masksToBounds = (true)
        self.layer.borderWidth = (width)
        self.layer.borderColor = (borderColor.cgColor)
        
        let containerLayer: CALayer = CALayer()
        containerLayer.shadowColor = UIColor.black.cgColor
        
        containerLayer.shadowRadius = 10.0
        containerLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        containerLayer.shadowOpacity = 1.0
        self.superview?.layer.addSublayer(containerLayer)
        
    }
    
    public func removeIndicatorFromView() {
        
        let layerNamebox: String = "bottom_box_layer"
        let layerNamepoint: String = "bottom_point_layer"
        
        for layer in self.layer.sublayers! {
            if layer.name == layerNamebox {
                layer.removeFromSuperlayer()
                break
            }
        }
        
        for layer in self.layer.sublayers! {
            if layer.name == layerNamepoint {
                layer.removeFromSuperlayer()
                break
            }
        }
        
    }
    
    public func getViewControllerFromSubView() -> UIViewController? {
        
        var responder: UIResponder = self
        if responder.next == nil{
            return nil
        }
        responder = responder.next!
        
        while !(responder.isKind(of: NSNull.self)) {
            if responder.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
            if responder.next == nil{
                return nil
            }
            responder = responder.next!
        }
        
        return nil
    }
    //  Get End X point of view
    public var endX : CGFloat {
        return frame.origin.x + frame.width
    }
    
    //  Get End Y point of view
    public var endY : CGFloat {
        return frame.origin.y + frame.height
    }
    
    //  Get Origin.x
    public var startX : CGFloat {
        return frame.origin.x
    }
    
    //  Get Origin.y
    public var startY : CGFloat {
        return frame.origin.y
    }
    
    //  Get width of View
    public var getWidth : CGFloat {
        return frame.width
    }
    
    //  Get height of view
    public var getHeight : CGFloat {
        return frame.height
    }
    
    //  Set Origin.x
    public func setStartX(_ x : CGFloat) {
        self.frame.origin.x = x
    }
    
    //  Set Origin.y
    public func setStartY( _ y : CGFloat) {
        self.frame.origin.y = y
    }
    
    //  Set Center
    public func setCenter(_ x : CGFloat, y : CGFloat) {
        self.center = CGPoint(x : x,y: y)
    }
    
    //  Get center
    public func getCenter() -> CGPoint {
        return self.center
    }
    
    //  Get center.x
    public func getCenterX() -> CGFloat {
        return self.center.x
    }
    
    //  Get center.y
    public func getCenterY() -> CGFloat {
        return self.center.y
    }
    
    //  Get Parent View controller
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
    
    //  Apply plain shadow to view
    public func applyPlainShadow() {
        let layer = self.layer
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
    }
    
    //  Apply boarder to view
    public func applyBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    //  Apply corner radius
    public func applyCornerRadius(_ corenrRadius : CGFloat , mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = corenrRadius
    }
    
    //  Add only bottom border
    public func applyBottomBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    //  Add Top Border
    public func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.getWidth, height: width)
        self.layer.addSublayer(border)
    }
    
    //  Add Right Border
    public func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.getWidth - width, y: 0, width: width, height: self.getHeight)
        self.layer.addSublayer(border)
    }
    
    //  Add Bottom Border
    public func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.getHeight - width, width: self.getWidth, height: width)
        self.layer.addSublayer(border)
    }
    
    //  Add Left Border
    public func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.getHeight)
        self.layer.addSublayer(border)
    }
    
    
    // TODO: Autolayout Constraint
    public func topEqualTo(view : UIView) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    public func topSpaceToSuper(space : CGFloat) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func topSpaceTo(view : UIView,space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func bottomEqualTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    public func bottomSpaceToSuper(spcae : CGFloat) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1.0, constant: spcae))
    }
    
    public func bottomSpaceTo(view : UIView,space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func leftMarginTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0))
    }
    
    public func leftMarginTo(view : UIView,margin : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: margin))
    }
    
    public func rightMarginTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0))
    }
    
    public func rightMarginTo(view : UIView,margin : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: margin))
    }
    
    public func horizontalSpace(view : UIView, space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: space))
    }
    
    public func verticalSpace(view : UIView, space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func edgeEqualTo(view : UIView){
        self.leftMarginTo(view: view)
        self.rightMarginTo(view: view)
        self.topEqualTo(view: view)
        self.bottomEqualTo(view: view)
    }
    
    public func edgeToSuperView(top : CGFloat,left : CGFloat,bottom : CGFloat,right : CGFloat){
        self.topSpaceTo(view: self.superview!, space: top)
        self.bottomSpaceToSuper(spcae: bottom)
        self.leftMarginTo(view: self.superview!, margin: left)
        self.rightMarginTo(view: self.superview!, margin: right)
    }
    
    public func verticalSpace(Views : [UIView],space : CGFloat) -> Void{
        
        var verticalString : String = ""
        
        for (index,view) in Views.enumerated(){
            if index == 0{
                verticalString = "[\(view.layer .value(forKey: ControlLayout.name) as! String)]"
            }
            else{
                verticalString = verticalString + "\(space)" + "[\(view.layer .value(forKey: ControlLayout.name) as! String)]"
            }
        }
        
        var viewDic : NSDictionary! = self.getDictionaryOfVariableBindings(viewArray: Views)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:\(verticalString)", options: NSLayoutFormatOptions(rawValue : 0), metrics: nil, views: viewDic as! [String : Any]))
        viewDic = nil
    }
    
    public func horizontalSpace(Views : [UIView],space : CGFloat) -> Void{
        var horizontalSpace : String = ""
        
        for (index,view) in Views.enumerated(){
            if index == 0{
                horizontalSpace = "[\(view.layer .value(forKey: ControlLayout.name) as! String)]"
            }
            else{
                horizontalSpace = horizontalSpace + "\(space)" + "[\(view.layer .value(forKey: ControlLayout.name) as! String)]"
            }
        }
        
        var viewDic : NSDictionary! = self.getDictionaryOfVariableBindings(viewArray: Views)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:\(horizontalSpace)", options: NSLayoutFormatOptions(rawValue : 0), metrics: nil, views: viewDic as! [String : Any]))
        viewDic = nil
    }
}
