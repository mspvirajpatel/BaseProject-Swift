//
//  MainResponse.swift
//
//
//  Created by Viraj Patel on 28/09/16.
//
//

import UIKit

class MainResponse: NSObject
{
    
    // MARK: - Attributes -
    
    var contactListArray:NSMutableArray!
    
    // MARK: - Lifecycle -
    required override init() {
        super.init()
    }
    
    // MARK: - Public Interface -
    func getModelFromResponse(response : AnyObject , task : APITask) -> AnyObject
    {
        var returnModel : AnyObject = response
        
        switch task
        {
            
        case .Login:
            
            var arrSchedule : [Speaker] = []
            
            if let dataSchedule = response["holidays"] as? NSDictionary
            {
                for dic in dataSchedule
                {
                    arrSchedule.append(Speaker(responseDictionary: dic as AnyObject))
                }
                
            }
            returnModel = arrSchedule as AnyObject
            
            break
        case .GetAllImages:
            
            var dicResponse : NSMutableArray? = self.getImageDictionary(response: (response as! NSDictionary))
            returnModel = dicResponse!
            dicResponse = nil
            
            break
            
            
        case .DeleteAllImages:
            
            let dicResponse : NSMutableArray? = NSMutableArray()
            returnModel = dicResponse!
            
            
        default:
            break
        }
        
        return returnModel
    }
    
    // MARK: - Internal Helpers -
    
    func getImageDictionary(response : AnyObject) -> NSMutableArray
    {
       
        let arrType : NSMutableArray = NSMutableArray()
        
        if let vehicleType = (response as! NSDictionary).object(forKey: "image_list") as? NSArray
        {
           
            for type in vehicleType
            {
                let vehicleType : NSString = ((type as! NSDictionary).object(forKey: "image_path") as? NSString)!
                arrType .add(vehicleType)
            }
        }
        
        
        return arrType
    }
    
    
}
