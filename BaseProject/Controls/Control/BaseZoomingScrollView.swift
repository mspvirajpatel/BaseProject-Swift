

import UIKit
import Kingfisher

class BaseZoomingScrollView: UIScrollView,UIScrollViewDelegate
{
    var progressIndicatorView : CircularLoaderView!
    var photoImageView : BaseImageView!
    var photo : UIImage!
    
    // MARK: Life Cycle
    init()
    {
        super.init(frame: CGRect.zero)
        
        photoImageView = BaseImageView(type: BaseImageViewType.profile, superView: self)
        photoImageView.contentMode = .scaleAspectFit
        //photoImageView.focusOnFaces = true
        photoImageView.backgroundColor = UIColor.black
        
        progressIndicatorView = CircularLoaderView(frame: CGRect.zero)
        progressIndicatorView.frame = bounds
        progressIndicatorView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.black
        self.delegate = self;
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        photoImageView.addSubview(self.progressIndicatorView)
    }
    
    // MARK: Public Method
    func setImageHidden(hidden : Bool)
    {
        photoImageView.isHidden = hidden
    }

    
    func prepareForReuse() {
        self.photo = nil
        self.photoImageView.isHidden = false
        self.photoImageView.image = nil
    }
    
    // Image Method
    func setImagePhoto(url : String)
    {
        photoImageView .kf.indicator?.view.tintColor = Color.activityLoader.value
        photoImageView.kf.setImage(with: URL(string: url), placeholder: nil, options: [KingfisherOptionsInfoItem.forceTransition], progressBlock: { [weak self] (receivedSize, totalSize) in
            
            if self == nil{
                return
            }
            self!.progressIndicatorView.progress = CGFloat(receivedSize)/CGFloat(totalSize)
            }, completionHandler: { [weak self] (image, error, cacheType, imageURL) in
                //print("Downloaded and set!")
                self!.progressIndicatorView.reveal()
                if(image !=  nil){
                    self!.photo = image
                    self!.photoImageView.image = image
                    self!.displayImage()
                }
        })
    }
    
    func displayImage()
    {
        if photo != nil && photoImageView.image != nil
        {
            self.maximumZoomScale = 1
            self.minimumZoomScale = 1
            self.zoomScale = 1
            self.contentSize = CGSize(width: 0, height: 0)
            if photo != nil
            {
                self.photoImageView.image = photo
                
                UIView .transition(with: photoImageView, duration: 0.5, options: [.transitionCrossDissolve], animations: { [weak self] in
                    if self == nil{
                        return
                    }
                        self!.photoImageView.isHidden = false
                    }, completion: { (completed) in
                        
                })
                
                var photoImageViewFrame: CGRect = CGRect.zero
                photoImageViewFrame.origin = CGPoint.zero
                photoImageViewFrame.size = photo.size
                self.photoImageView.frame = photoImageViewFrame
                self.contentSize = photoImageViewFrame.size
                self.setMaxMinZoomScalesForCurrentBounds()
            }
            else {
                
            }
            self.setNeedsLayout()
        }
    }
    
    // MARK: Layout
    func initialZoomScaleWithMinScale() -> CGFloat {
        var zoomScale: CGFloat = self.minimumZoomScale
        if photoImageView != nil
        {
            let boundsSize = self.bounds.size
            let imageSize = photoImageView.image!.size
            let boundsAR: CGFloat = boundsSize.width / boundsSize.height
            let imageAR: CGFloat = imageSize.width / imageSize.height
            let xScale: CGFloat = boundsSize.width / imageSize.width
            let yScale: CGFloat = boundsSize.height / imageSize.height
            if abs(boundsAR - imageAR) < 0.17 {
                zoomScale = max(xScale, yScale)
                zoomScale = min(max(self.minimumZoomScale, zoomScale), self.maximumZoomScale)
            }
        }
        return zoomScale
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        self.maximumZoomScale = 1
        self.minimumZoomScale = 1
        self.zoomScale = 1
        if photoImageView.image == nil {
            return
        }
        self.photoImageView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.size.width, height: photoImageView.frame.size.height)
        let boundsSize = self.bounds.size
        let imageSize = photoImageView.image!.size
        let xScale: CGFloat = boundsSize.width / imageSize.width
        let yScale: CGFloat = boundsSize.height / imageSize.height
        var minScale: CGFloat = min(xScale, yScale)
        let maxScale: CGFloat = 3
        if xScale >= 1 && yScale >= 1 {
            minScale = 1.0
        }
        
        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale
        self.zoomScale = self.initialZoomScaleWithMinScale()
        if self.zoomScale != minScale {
            self.contentOffset = CGPoint(x: (imageSize.width * self.zoomScale - boundsSize.width) / 2.0, y: (imageSize.height * self.zoomScale - boundsSize.height) / 2.0)
        }
        self.isScrollEnabled = false
        self.setNeedsLayout()
    }
    

    // MARK: Layout
    override func layoutSubviews()
    {
        super.layoutSubviews()
        let boundsSize = self.bounds.size
        var frameToCenter = photoImageView.frame
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = CGFloat(floorf((Float(boundsSize.width - frameToCenter.size.width)) / 2.0))
        }
        else {
            frameToCenter.origin.x = 0
        }
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = CGFloat(floorf((Float(boundsSize.height - frameToCenter.size.height)) / 2.0))
        }
        else {
            frameToCenter.origin.y = 0
        }
      
        if !photoImageView.frame.equalTo(frameToCenter) {
            self.photoImageView.frame = frameToCenter
        }
    }
    
    
    // MARK: Delegate Method
    private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.isScrollEnabled = true
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self .setNeedsDisplay()
        self .layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
