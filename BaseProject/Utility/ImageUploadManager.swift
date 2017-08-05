//
//  ImageUploadManager.swift
//  BaseProjectSwift
//
//  Created by WebMob on 28/11/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit

class ImageUploadManager: NSObject
{
    // MARK: - Attributes -
    fileprivate var isUploadingRunning : Bool = false
    fileprivate var documentPath : String? = ""
    fileprivate var uploadImageDirectoryPath : String? = ""
    fileprivate var fileManager : FileManager?
    fileprivate var updateUploadStatus : TaskFinishedEvent?
    fileprivate var totalUploadedImage : Int = 0
    fileprivate var totalImages : Int = 0
    
    
    // MARK: - Lifecycle -
    static let sharedInstance : ImageUploadManager = {
        
        let instance = ImageUploadManager()
        return instance
    }()
    
    deinit{
        
    }
    
    override init() {
        super.init()
        self.setupOnInit()
    }
    
    // MARK: - Public Interface -
    open func addImageForUpload(arrImage : [UIImage]) -> Bool
    {
        if isUploadingRunning == false{
            totalImages = totalImages + arrImage.count
            self.saveImagesInCatch(arrImage: arrImage)
            if self.updateUploadStatus != nil
            {
                self.updateUploadStatus!(true,NSArray(array: [totalUploadedImage , totalImages]))
            }
            self.prepareImageForUpload(imagePath: self.getImageForUploadOnServer())
        }
        return isUploadingRunning
    }
    
    open func setUpdateProgressStatusEven(event : @escaping TaskFinishedEvent){
        updateUploadStatus = event
    }
    
    open func getTotalImageCount() -> Int
    {
        do
        {
            return try fileManager!.contentsOfDirectory(atPath: uploadImageDirectoryPath! as String).count
        }
        catch let error as NSError
        {
            print("Error while Getting Total Image Count:- \(error.localizedDescription)")
            return 0
        }
    }
    
    open func isUploadOperationRunning() -> Bool{
        return isUploadingRunning
    }
    
    // MARK: - Internal Helpers -
    fileprivate func setupOnInit()
    {
        documentPath = AppUtility.getDocumentDirectoryPath()
        fileManager = FileManager()
        uploadImageDirectoryPath = AppUtility.stringByPathComponet(fileName: "uploadImage", Path: documentPath!)
    }
    
    fileprivate func saveImagesInCatch(arrImage : [UIImage])
    {
        if !(fileManager?.fileExists(atPath: uploadImageDirectoryPath!))!
        {
            do
            {
                try fileManager?.createDirectory(atPath: uploadImageDirectoryPath!, withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as NSError{
                print("Error While Create Directory :- \(error.localizedDescription)")
                return
            }
        }
        var currentIndex : Int = totalUploadedImage
        for image in arrImage
        {
            var imagePath : String? = AppUtility.stringByPathComponet(fileName: "\(currentIndex).jpg", Path: uploadImageDirectoryPath!)
            print("imagePath:- \(imagePath)")
            var img : UIImage? = UIImage .compressImage(image, compressRatio: 0.2, maxCompressRatio: 0.5)
            var imageData : Data? = UIImageJPEGRepresentation(img!, 0.0)!
            
            do{
                
                try imageData! .write(to: URL(fileURLWithPath : imagePath!), options: Data.WritingOptions.atomic)
                
            }
            catch let error as NSError{
                print("Error while saveing image : \(error.localizedDescription)")
            }
            
            currentIndex = currentIndex + 1
            
            imagePath = nil
            imageData = nil
            img = nil
            
        }
        print("finish Save")
    }
    
    fileprivate func getImageForUploadOnServer() -> String
    {
        do
        {
            let tmpFileList : [String] = try fileManager!.contentsOfDirectory(atPath: uploadImageDirectoryPath! as String)
            if tmpFileList.count > 0
            {
                return AppUtility.stringByPathComponet(fileName: tmpFileList.first!, Path: uploadImageDirectoryPath!)
            }
        }
        catch let error as NSError
        {
            print("Error while Feting Image:- \(error.localizedDescription)")
        }
        
        return ""
    }
    
    
    fileprivate func prepareImageForUpload(imagePath : String)
    {
        if (fileManager?.fileExists(atPath: imagePath))!
        {
            var dicImgData : NSMutableDictionary? = NSMutableDictionary()
            var imageData : NSData! = NSData(contentsOfFile: imagePath)!
            
            dicImgData! .setObject(imageData, forKey: "data" as NSCopying)
            dicImgData! .setObject("imagefile", forKey: "name" as NSCopying)
            dicImgData! .setObject("imagefile", forKey: "fileName" as NSCopying)
            dicImgData! .setObject("image/jpeg", forKey: "type" as NSCopying)
            
            
            isUploadingRunning = true
           
            self.uploadImageRequest(dicImage: dicImgData! , uploadFilePath: imagePath)
            dicImgData = nil
            imageData = nil
            
        }
    }
    
    // MARK: - Server Helpers -
    func uploadImageRequest(dicImage : NSDictionary , uploadFilePath : String)
    {
        
        var dicParameter : NSMutableDictionary! = NSMutableDictionary()
        dicParameter .setValue("1", forKey: "status")
        
        APIManager.shared.uploadImage(url: APIConstant.uploadPhoto, Parameter: dicParameter, Images: [dicImage], Type: APITask.UploadAllImages) { [weak self] (result) in
            
            if self == nil{
                return
            }
            
            switch result{
            case .Success( _, _):
                
                self!.totalUploadedImage = self!.totalUploadedImage + 1
                
                do
                {
                    try self!.fileManager?.removeItem(atPath: uploadFilePath)
                    if self!.getTotalImageCount() > 0
                    {
                        if self!.updateUploadStatus != nil
                        {
                            self!.updateUploadStatus!(true,NSArray(array: [self!.totalUploadedImage , self!.totalImages]))
                        }
                        
                        self!.prepareImageForUpload(imagePath: self!.getImageForUploadOnServer())
                    }
                    else
                    {
                        if self!.updateUploadStatus != nil
                        {
                            self!.updateUploadStatus!(true,NSArray(array: [self!.totalUploadedImage , self!.totalImages]))
                        }
                        self!.totalUploadedImage = 0
                        self!.totalImages = 0
                        self!.isUploadingRunning = false
                    }
                }
                catch let error as NSError{
                    print("Error While Remove image :- \(error.localizedDescription)")
                }
                
                break
            case .Error(let error):
                
                AppUtility.executeTaskInMainQueueWithCompletion {
                    AppUtility.getAppDelegate().window?.makeToast(error!.serverMessage, duration: 2.0, position: .bottom)
                }
                
                break
            case .Internet( _):
                break
            }
        }
        
        
//        BaseAPICall.shared.uploadImage(url: APIConstant.uploadPhoto, Parameter: dicParameter, Images: [dicImage], Type: APITask.UploadAllImages) { [weak self] (result) in
//            
//            if self == nil{
//                return
//            }
//            
//            switch result{
//            case .Success( _, _):
//                
//                self!.totalUploadedImage = self!.totalUploadedImage + 1
//                
//                do
//                {
//                    try self!.fileManager?.removeItem(atPath: uploadFilePath)
//                    if self!.getTotalImageCount() > 0
//                    {
//                        if self!.updateUploadStatus != nil
//                        {
//                            self!.updateUploadStatus!(true,NSArray(array: [self!.totalUploadedImage , self!.totalImages]))
//                        }
//                        
//                        self!.prepareImageForUpload(imagePath: self!.getImageForUploadOnServer())
//                    }
//                    else
//                    {
//                        if self!.updateUploadStatus != nil
//                        {
//                            self!.updateUploadStatus!(true,NSArray(array: [self!.totalUploadedImage , self!.totalImages]))
//                        }
//                        self!.totalUploadedImage = 0
//                        self!.totalImages = 0
//                        self!.isUploadingRunning = false
//                    }
//                }
//                catch let error as NSError{
//                    print("Error While Remove image :- \(error.localizedDescription)")
//                }
//                
//                break
//            case .Error(let error):
//                
//                AppUtility.executeTaskInMainQueueWithCompletion {
//                    AppUtility.showWhisperAlert(message: error!.serverMessage, duration: 1.0)
//                }
//                
//                break
//            case .Internet( _):
//                break
//            }
//        }
        dicParameter = nil
    }
}
