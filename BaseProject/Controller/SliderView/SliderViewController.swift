//
//  ShareListController.swift
//  BaseProjectSwift
//
//  Created by Viraj Patel on 13/02/17.
//  Copyright © 2017 Viraj Patel All rights reserved.
//

import UIKit

class SliderViewController: BaseViewController {

    // MARK: - Attributes -
    
    var sliderView: MySliderView!
    
    // MARK: - Lifecycle -
    
    override init() {
        
        sliderView = MySliderView(frame: CGRect.zero)
        super.init(iView: sliderView, andNavigationTitle: "Database")
        
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let one = DataBaseController()
        let two = CoreDataController()
        addChildViewController(one)
        addChildViewController(two)

        sliderView.sliderView = SliderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64), titles: ["GRDB Database", "Core Database"], contentViews: [one.view, two.view])
        sliderView.sliderView.selectedIndex = 1
        sliderView.addSubview(sliderView.sliderView)
        NotificationCenter.default.addObserver(self, selector: #selector(changeSliderView), name: NSNotification.Name(rawValue: "change"), object: nil)
    }
   
    func changeSliderView() {
        
        sliderView.sliderView.selectedIndex = 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
       
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        super.expandViewInsideViewWithTopSpace()
    }

}
