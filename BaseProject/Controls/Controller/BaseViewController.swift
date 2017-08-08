
import UIKit

class BaseViewController: UIViewController, UINavigationControllerDelegate {

    var baseLayout : AppBaseLayout!
    var aView : BaseView!
    
    private var btnName: UIButton!
    var navigationTitleString : String!
    
    // MARK: - Lifecycle -
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(iView: BaseView){
        super.init(nibName: nil, bundle: nil)
        aView = iView
    }
    
    init(iView: BaseView, andNavigationTitle titleString: String){
        
        super.init(nibName: nil, bundle: nil)
        aView = iView
        
        navigationTitleString = titleString
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil{
                return
            }
            self!.navigationItem.title = self!.navigationTitleString
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //self.edgesForExtendedLayout = UIRectEdge()
        
//        if self.aView != nil && self.aView.bannerAd != nil
//        {
//            self.aView.bannerAd.requestBannerAd(rootController: self)
//        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil{
                return
            }
            self!.navigationItem.title = self!.navigationTitleString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil{
                return
            }
            self!.navigationItem.title = self!.navigationTitleString
        }
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil{
                return
            }
            
            self!.navigationItem.title = self!.navigationTitleString
            self!.aView.endEditing(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit{

        print("BaseView Controller Deinit Called")
        NotificationCenter.default.removeObserver(self)
        
        if aView != nil && aView.superview != nil{
            aView.releaseObject()
            aView.removeFromSuperview()
            aView = nil
        }
        
        if baseLayout != nil{
            baseLayout.releaseObject()
            baseLayout = nil
        }
        
        navigationTitleString = nil
    }
    
    // MARK: - Layout - 
    
    func loadViewControls(){
        
        self.view.backgroundColor = Color.appPrimaryBG.value
        self.view.addSubview(aView)
        self.view.isExclusiveTouch = true
        self.view.isMultipleTouchEnabled = true
    }
    
    func setViewlayout(){
        
        if SystemConstants.hideLayoutArea {
            self.view.backgroundColor = UIColor.yellow
        }
        
        /*  baseLayout Allocation   */
        baseLayout = AppBaseLayout()
    }
    
    func expandViewInsideView(){
        baseLayout.expandView(aView, insideView: self.view)
    }
    
    func expandViewInsideViewWithTopSpace(){
        baseLayout.expandView(aView, insideView: self.view, topSpace: 64)
    }
    
    
    
    
    // MARK: - Public Interface -
    func displayMenuButton(){
        
        var origImage : UIImage? = UIImage(named: "menuicon");
        var tintedImage : UIImage? = origImage!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        btnName = UIButton()
        btnName.setImage(tintedImage!, for: UIControlState())
        btnName.tintColor = UIColor.white
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(openslider), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnName)
        
        origImage = nil
        tintedImage = nil
    }

    func openslider() {
        self.view.endEditing(true)
        AppUtility.getAppDelegate().slidemenuController!.showMenuViewController()
    }
    
    func HideMenuButton(){
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    // Mark - UINavigationControllerDelegate 
    
}


