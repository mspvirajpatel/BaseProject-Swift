//
//  Speaker.swift
//  ViewControllerDemo
//
//  Created by SamSol on 01/07/16.
//  Copyright © 2016 SamSol. All rights reserved.
//

class Speaker: NSObject {

    // MARK: - Attributes -

    var scheduleDetail : [ScheduleDetail] = []
    
    
    // MARK: - Lifecycle -
    
    required override init(){
        
        super.init()
        
    }
    
    convenience init(responseDictionary : AnyObject)
    {
        self.init()
        self.getValuefromDictionary(responseDictionary: responseDictionary as! NSDictionary)
    }
    
    // MARK: - Public Interface -
    private func getValuefromDictionary(responseDictionary : NSDictionary)
    {
        let mirror = Mirror(reflecting: self)
        let allKey : [String] = mirror.proparty()
        
        
        for key in allKey
        {
            if let value = responseDictionary.value(forKey: key)
            {
                if value is Int
                {
                    self.setValue(String(value as! Int), forKey: key)
                }
                else if value is String
                {
                    self.setValue(value, forKey: key)
                }
                else if value is NSArray
                {
                    for image in value as! NSArray
                    {
                        scheduleDetail .append(ScheduleDetail(responseDictionary : image as AnyObject))
                    }
                }
                else if value is NSDictionary
                {
                    self.setValue(value, forKey: key)
                }
            }
        }
    }
    
}


