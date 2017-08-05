//
//  UIImageView+ImageViewer.swift
//  ImageViewer
//
//  Created by MacMini-2 on 25/03/17.
//  Copyright (c) 2017 WMT All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    public func setupForImageViewer(_ backgroundColor: UIColor = UIColor.white) {
        isUserInteractionEnabled = true
        let gestureRecognizer = ImageViewerTapGestureRecognizer(target: self, action: #selector(UIImageView.didTap(_:)), backgroundColor: backgroundColor)
        addGestureRecognizer(gestureRecognizer)
    }
    
    internal func didTap(_ recognizer: ImageViewerTapGestureRecognizer) {        
        let imageViewer = ImageViewer(senderView: self, backgroundColor: recognizer.backgroundColor)
        imageViewer.presentFromRootViewController()
    }
}

class ImageViewerTapGestureRecognizer: UITapGestureRecognizer {
    let backgroundColor: UIColor
    
    init(target: AnyObject, action: Selector, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        
        super.init(target: target, action: action)
    }
}
