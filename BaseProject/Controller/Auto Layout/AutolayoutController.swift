

import UIKit

class AutolayoutController: BaseViewController {

    // MARK: - Attributes -
    var autolayoutView : AutolayoutView!
    
    // MARK: - Lifecycle -
    override init()
    {
        autolayoutView = AutolayoutView(frame: CGRect.zero)
        
        super.init(iView: autolayoutView!, andNavigationTitle: "Auto Layout")
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        autolayoutView.viewRotateEvent(to: size, with: coordinator)
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
