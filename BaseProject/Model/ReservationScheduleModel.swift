//
//  ReservationScheduleModel.swift
//  GasdropDriver
//
//  Created by MacMini-2 on 13/10/16.
//  Copyright © 2016 WebMobTech. All rights reserved.
//

import UIKit

class ReservationScheduleModel: NSObject {
    // MARK: - Attributes -
    
    var truckScheduleId: String = ""
    
    var truckSlotId: String = ""
    var userVehicleId: String = ""
    
    var vehicleImage : [VehicleImage] = []
   
    var userAddressId : String = ""
    
    var fualTypeId : String = ""
    var orderAmount : String = ""
    
    var fuelPrice: String = ""
    var paymentStatus: String = ""
    
    var fillMeUpStatus: String = ""
    var fuelTypeName : String = ""
    
    var userVehicleName : String = ""
    var licensePlateNo : String = ""
    
    var address1 : String = ""
    
    var address2: String = ""
    var latitude: String = ""
    
    var longitude: String = ""
    var scheduleDate : String = ""
    
    var distance : String = ""
    var notes : String = ""
    
    var discount : String = ""
    var serviceFee : String = ""
    
    var orderId : String = ""
    
    var gallons : String = ""
    
    // MARK: - Lifecycle -
    
    required override init() {
        super.init()
    }
    
    convenience init(responseDictionary : AnyObject)
    {
        self.init()
        self.getValueFromDictionary(response: responseDictionary as! NSDictionary)
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - Internal Helpers -
    private func getValueFromDictionary(response : NSDictionary)
    {
        let mirror = Mirror(reflecting: self)
        let allKey : [String] = mirror.proparty()
        
        
        for key in allKey
        {
            if let value = response.value(forKey: key)
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
                        vehicleImage .append(VehicleImage(responseDictionary : image as AnyObject))
                    }
                }
            }
        }
        
    }
    
    // MARK: - NSCopying Delegate Method -
//    func copyWithZone(zone: NSZone) -> AnyObject {
//        
//        return self.dynamicType.init()
//        
//    }
    
    
}
