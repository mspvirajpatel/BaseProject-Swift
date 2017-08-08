//
//  UltravisualLayout.swift
//  InHeadLine
//
//  Created by Amrit on 3/31/16.
//  Copyright @ 2017 Esig. All rights reserved.
//

import UIKit
class UltravisualLayout: UICollectionViewLayout {
    
    fileprivate var contentWidth:CGFloat!
    fileprivate var contentHeight:CGFloat!
    fileprivate var yOffset:CGFloat = 0
    
    var maxAlpha:CGFloat = 1
    var minAlpha:CGFloat = 0
    
    var widthOffset:CGFloat = 35
    var heightOffset:CGFloat = 35
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var itemWidth:CGFloat{
        return (collectionView?.bounds.width)!
    }
    fileprivate var itemHeight:CGFloat{
        return (collectionView?.bounds.height)!
    }
    fileprivate var collectionViewHeight:CGFloat{
        return (collectionView?.bounds.height)!
    }

    
    fileprivate var numberOfItems:Int{
        return (collectionView?.numberOfItems(inSection: 0))!
    }
    
    
    fileprivate var dragOffset:CGFloat{
        return (collectionView?.bounds.height)!
    }
    fileprivate var currentItemIndex:Int{
        return max(0, Int(collectionView!.contentOffset.y / collectionViewHeight))
    }
    
    var nextItemBecomeCurrentPercentage:CGFloat{
        return (collectionView!.contentOffset.y / (collectionViewHeight)) - CGFloat(currentItemIndex)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        yOffset = 0
        
        for item in 0 ..< numberOfItems{
            
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.zIndex = -(indexPath as NSIndexPath).row
            
            if ((indexPath as NSIndexPath).item == currentItemIndex+1) && ((indexPath as NSIndexPath).item < numberOfItems){
                
                attribute.alpha = minAlpha + max((maxAlpha-minAlpha) * nextItemBecomeCurrentPercentage, 0)
                let width = itemWidth - widthOffset + (widthOffset * nextItemBecomeCurrentPercentage)
                let height = itemHeight - heightOffset + (heightOffset * nextItemBecomeCurrentPercentage)
                
                let deltaWidth =  width/itemWidth
                let deltaHeight = height/itemHeight
                
                attribute.frame = CGRect(x: 0, y: yOffset, width: itemWidth, height: itemHeight)
                attribute.transform = CGAffineTransform(scaleX: deltaWidth, y: deltaHeight)
                
                attribute.center.y = (collectionView?.center.y)! +  (collectionView?.contentOffset.y)!
                attribute.center.x = (collectionView?.center.x)! + (collectionView?.contentOffset.x)!
                yOffset += collectionViewHeight
                
            }else{
                attribute.frame = CGRect(x: 0, y: yOffset, width: itemWidth, height: itemHeight)
                attribute.center.y = (collectionView?.center.y)! + yOffset
                attribute.center.x = (collectionView?.center.x)!
                yOffset += collectionViewHeight
            }
            cache.append(attribute)
        }
    }
    
    //Return the size of ContentView
    override var collectionViewContentSize : CGSize {
        contentWidth = (collectionView?.bounds.width)!
        contentHeight = CGFloat(numberOfItems) * (collectionView?.bounds.height)!
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //Return Attributes  whose frame lies in the Visible Rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache{
            if attribute.frame.intersects(rect){
                layoutAttributes.append(attribute)
            }
        }
        return layoutAttributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / (dragOffset))
        let yOffset = itemIndex * (collectionView?.bounds.height)!
        return CGPoint(x: 0, y: yOffset)
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        // Logic that calculates the UICollectionViewLayoutAttributes of the item
        // and returns the UICollectionViewLayoutAttributes
        return UICollectionViewLayoutAttributes(forCellWith: indexPath)
    }
    
}
