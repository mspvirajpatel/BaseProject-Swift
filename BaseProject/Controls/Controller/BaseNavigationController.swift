

import UIKit

class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    // MARK: - Interface
    @IBInspectable open var clearBackTitle: Bool = true
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultParameters()
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Layout - 
    
    
    // MARK: - Public Interface -
    func setDefaultParameters(){
        
       // self.edgesForExtendedLayout = UIRectEdge.none
        
        if(self.responds(to: (#selector(getter: UINavigationController.interactivePopGestureRecognizer)))){
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        var navigationBarFont: UIFont? = UIFont(name: FontStyle.medium, size: 17.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Color.navigationTitle.value,
                                                                NSFontAttributeName: navigationBarFont!] as [String : Any]
        
        self.navigationBar.tintColor = Color.navigationTitle.value
        self.navigationBar.barTintColor = Color.navigationBG.value
       
        self.view.backgroundColor = UIColor.clear
      
        
        //transperant Navigation Bar
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        
        defer{
            navigationBarFont = nil
        }
    }
    
    
    func setPopOverParameters(){
        
    }
    
    // MARK: - User Interaction -
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        controlClearBackTitle()
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func show(_ vc: UIViewController, sender: Any?) {
        controlClearBackTitle()
        super.show(vc, sender: sender)
    }
    
    // MARK: - Internal Helpers -
}

extension BaseNavigationController {
    
    func controlClearBackTitle() {
        if self.clearBackTitle {
            topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
}
