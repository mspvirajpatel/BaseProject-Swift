//
//  ImageUploadingController.swift
//  BaseProjectSwift
//
//  Created by Viraj Patel on 28/11/16.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import UIKit
import DKImagePickerController
import Toast_Swift

class ImageUploadingController: BaseViewController {

    var imageView : ImageUploadView?
    
    // MARK: - Lifecycle -
    override init()
    {
        imageView = ImageUploadView(frame: CGRect.zero)
        
        super.init(iView: imageView!, andNavigationTitle: "Upload Image")
        
        self.loadViewControls()
        self.setViewControlsLayout()
        self.displayMenuButton()
 
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Layout -
    internal override func loadViewControls() -> Void
    {
        super.loadViewControls()
        
        self.imageView?.setDisplayImageEvent(event: { (sender, object) in
            var displayAllImageController : DisplayAllImageController? = DisplayAllImageController()
            self.navigationController?.pushViewController(displayAllImageController!, animated: true)
            displayAllImageController = nil
        })
        
        self.imageView?.setUploadImageEvent(event: { (sendor, object) in
            
            AppUtility.executeTaskInMainQueueWithCompletion
            {
                var pickerController : DKImagePickerController? = DKImagePickerController()
                pickerController!.assetType = DKImagePickerControllerAssetType.allPhotos
                pickerController!.allowsLandscape = false
                pickerController!.allowMultipleTypes = true
                pickerController!.sourceType = DKImagePickerControllerSourceType.photo
                pickerController!.singleSelect = false
                pickerController!.showsCancelButton = true
                pickerController!.maxSelectableCount = 10
                
                pickerController!.didSelectAssets =
                    {  (assets: [DKAsset]) in
                        
                        var arrImage : [UIImage]? = []
                        for asset in assets
                        {
                            asset.fetchOriginalImage(true, completeBlock: { (image, info) in
                                arrImage!.append(image!)
                            })
                        }
                        
                        AppUtility.executeTaskInMainQueueWithCompletion {
                            self.imageView?.makeToast("⏳ Preparing to upload photos ...", duration: 2.0, position: ToastPosition.bottom, title: "", image: nil, style: nil, completion: { (finished) in
                                let isUploadAdded : Bool = ImageUploadManager.sharedInstance.addImageForUpload(arrImage: arrImage!)
                                if isUploadAdded
                                {
                                    print("new Image Added")
                                }
                                pickerController = nil
                                arrImage = nil
                            })
                        }
                }
                self.present(pickerController!, animated: true, completion: nil)
            }
        })
        
        
        ImageUploadManager.sharedInstance.setUpdateProgressStatusEven { (wasSuccessfull, object) in
            self.imageView?.updateImageProgress(arrCount: object as! NSArray)
        }
    }
    
    private func setViewControlsLayout() -> Void
    {
        super.setViewlayout()
        super.expandViewInsideViewWithTopSpace()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - Server Request -
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
