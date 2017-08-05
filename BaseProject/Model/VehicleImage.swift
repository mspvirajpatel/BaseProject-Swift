//
//  VehicleImage.swift
//  GasdropUser
//
//  Created by WebMob on 03/10/16.
//  Copyright © 2016 WebMobTech. All rights reserved.
//

import UIKit

class VehicleImage: NSObject
{
    // MARK: - Attributes -
    var userVehicleId : String = ""
    var vehicleImageId : String = ""
    var imageName : String = ""
    var imagePath : String = ""
    var priority : String = ""
    
    // MARK: - Lifecycle -
    required override init() {
        super.init()
    }
    
    convenience init(responseDictionary : AnyObject)
    {
        self.init()
        self.setValueFromDictionary(responseDictionary as! NSDictionary)
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - Internal Helpers -
    
    
    
    // MARK: - NSCopying Delegate Method -
//    func copyWithZone(zone: NSZone) -> AnyObject {
//        
//        return self.dynamicType.init()
//        
//    }
}
