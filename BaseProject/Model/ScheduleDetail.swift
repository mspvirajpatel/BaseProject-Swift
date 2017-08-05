//
//  ScheduleDetail.swift
//  GasdropUser
//
//  Created by WebMob on 13/10/16.
//  Copyright © 2016 WebMobTech. All rights reserved.
//

import UIKit

class ScheduleDetail: NSObject
{
    // MARK: - Attributes -
    var observed : String = ""
    var name : String = ""
    var date : String = ""
   
    
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
    
    
   
}
