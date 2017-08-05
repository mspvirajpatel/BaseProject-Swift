//
//  DisplayAllImageView.swift
//  BaseProjectSwift
//
//  Created by WebMob on 28/11/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit

class DisplayAllImageView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    
    // MARK: - Attribute -
    
    var photoCollectionView:UICollectionView!
    var flowLayout:UICollectionViewFlowLayout!
    
    var photoListArray:NSMutableArray!
    var photoListCount:NSInteger!
    
    var previousPhotoListCount:NSInteger!
    var nextPhotoListCount:NSInteger!
    
    var collectionCellSize:CGSize! = InterfaceUtility.getAppropriateSizeFromSize(UIScreen.main.bounds.size, withDivision: 3.0, andInterSpacing: 5.0)
    
    // MARK: - Lifecycle -
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
        self.getAllImagesRequest()
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
        
        
        photoListArray = NSMutableArray.init()
        photoListCount = photoListArray.count
        
        /*  photoCollectionView Allocation   */
        
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        
        
        photoCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.allowsMultipleSelection = false
        photoCollectionView.backgroundColor = UIColor.clear
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView .register(PhotoCollectionCell.self, forCellWithReuseIdentifier: CellIdentifire.photo)
        
        self.addSubview(photoCollectionView)
        
        
    }
    
    override func setViewlayout()
    {
        super.setViewlayout()
        
        baseLayout.expandView(photoCollectionView, insideView: self)
        
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - UICollectionView DataSource Methods -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoListCount == 0  {
            self.displayErrorMessageLabel("No Record Found")
        }
        else
        {
            self.displayErrorMessageLabel(nil)
        }
        
        return photoListCount ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : PhotoCollectionCell!
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifire.photo, for: indexPath) as? PhotoCollectionCell
        
        if cell == nil
        {
            cell = PhotoCollectionCell(frame: CGRect.zero)
        }
        if(indexPath.row < photoListArray.count){
            var imageString:NSString? = photoListArray[indexPath.row] as? NSString
            cell.displayImage(image: imageString!)
            imageString = nil;
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
    
    
    // MARK: - Server Request -

    open class var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
        
    }
    
    open class var baseURL: String {
        return "https://api.example.com"
    }
    
    open class func validate(json: JSON) -> JSONValidationResult {
        if let error = json["error"] as? String {
            return .failure(error: error)
        }
        
        if json["data"] != nil {
            return .success
        }
        
        return .failure(error: "No data nor error returned.")
    }
        
    public func getAllImagesRequest()
    {
        
        operationQueue.addOperation { [weak self] in
            if self == nil{
                return
            }
            APIManager.shared.postRequest(URL: APIConstant.userPhotoList, Parameter: NSDictionary(), Type: APITask.GetAllImages, completionHandler:{ [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(let object,let error):
                    
                    self!.hideProgressHUD()
                    
                    var imageArray: NSMutableArray! = object as! NSMutableArray
                    self!.previousPhotoListCount = self!.photoListArray.count
                    self!.nextPhotoListCount = imageArray.count
                    self!.photoListArray = imageArray
                    self!.photoListCount = self!.photoListArray.count
                    
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil{
                            return
                        }
                        self!.photoCollectionView.reloadData()
                    }
                    
                    defer{
                        imageArray = nil
                    }
                    
                    break
                case .Error(let error):
                    
                    self!.hideProgressHUD()
                    AppUtility.executeTaskInMainQueueWithCompletion {
                        self?.displayBottomToast(message: error!.serverMessage)
                    }
                    
                    break
                case .Internet(let isOn):
                    self!.handleNetworkCheck(isAvailable: isOn)
                    break
                }
            })
            

        
//            BaseAPICall.shared.postReques(URL: APIConstant.userPhotoList, Parameter: NSDictionary(), Type: APITask.GetAllImages) { [weak self] (result) in
//                if self == nil{
//                    return
//                }
//                
//                switch result{
//                case .Success(let object,let error):
//                    
//                    self!.hideProgressHUD()
//                    
//                    var imageArray: NSMutableArray! = object as! NSMutableArray
//                    self!.previousPhotoListCount = self!.photoListArray.count
//                    self!.nextPhotoListCount = imageArray.count
//                    self!.photoListArray = imageArray
//                    self!.photoListCount = self!.photoListArray.count
//                    
//                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
//                        if self == nil{
//                            return
//                        }
//                        self!.photoCollectionView.reloadData()
//                    }
//                    
//                    defer{
//                        imageArray = nil
//                    }
//                    
//                    break
//                case .Error(let error):
//                    
//                    self!.hideProgressHUD()
//                    AppUtility.executeTaskInMainQueueWithCompletion {
//                        AppUtility.showWhisperAlert(message: error!.serverMessage, duration: 1.0)
//                    }
//                    
//                    break
//                case .Internet(let isOn):
//                    self!.handleNetworkCheck(isAvailable: isOn)
//                    break
//                }
//            }
        }
    }
 
    public func deleteAllImagesRequest()
    {
        operationQueue.addOperation { [weak self] in
            if self == nil{
                return
            }
            
            BaseAPICall.shared.postReques(URL: APIConstant.deletePhoto, Parameter: NSDictionary(), Type: APITask.DeleteAllImages) { [weak self] (result) in
                
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(let object,let error):
                    
                    self!.hideProgressHUD()
                    
                    var imageArray : NSMutableArray! = object as! NSMutableArray
                    self!.previousPhotoListCount = self!.photoListArray.count
                    self!.nextPhotoListCount = imageArray.count
                    self!.photoListArray = imageArray
                    self!.photoListCount = self!.photoListArray.count
                    
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil{
                            return
                        }
                        self!.photoCollectionView.reloadData()
                    }
                    
                    defer{
                        imageArray = nil
                    }
                    
                    break
                case .Error(let error):
                    
                    self!.hideProgressHUD()
                    
                    AppUtility.executeTaskInMainQueueWithCompletion {
                        
                        self?.displayBottomToast(message: error!.serverMessage)
                      
                    }
                    
                    break
                case .Internet(let isOn):
                    self!.handleNetworkCheck(isAvailable: isOn)
                    break
                }
            }
        }
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
