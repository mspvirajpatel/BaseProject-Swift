//
//  PageAnimationView.swift
//  BaseProjectSwift
//
//  Created by WebMob on 02/02/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import UIKit

class PageAnimationView: BaseView {

    // MARK: - Attribute -
    var collectionView : UICollectionView!
    
    // MARK: - Lifecycle -
    override init(frame: CGRect)
    {
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
        
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UltravisualLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView .register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        self.addSubview(collectionView)
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.expandView(collectionView, insideView: self)
    }
    
    // MARK: - Public Interface -
    public func viewRotateEvent(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        collectionView.reloadData()
    }
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -

}

extension PageAnimationView: UICollectionViewDataSource{
    //MARK:-CollectionView DataSource and Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor(red: CGFloat((arc4random()%255))/255.0, green: CGFloat((arc4random()%255))/255.0, blue: CGFloat((arc4random()%255))/255.0, alpha: 1)
        cell.layer.cornerRadius = 0
        return cell
    }
    
}
