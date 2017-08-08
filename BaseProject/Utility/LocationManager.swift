//
//  LocationManager.swift
//  GasdropDriver
//
//  Created by Viraj Patel on 14/10/16.
//  Copyright @ 2017 Viraj Patel. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

        enum Result {
            case success(LocationManager)
            case failure(Error)
        }
        
        static let shared: LocationManager = LocationManager()
        
        typealias Callback = (Result) -> Void
        
        var requests: Array <Callback> = Array <Callback>()
        
        var location: CLLocation? { return sharedLocationManager.location  }
        
        lazy var sharedLocationManager: CLLocationManager = {
            let newLocationmanager = CLLocationManager()
            newLocationmanager.delegate = self
            // ...
            return newLocationmanager
        }()
        
        // MARK: - Authorization
        
        class func authorize() { shared.authorize() }
        func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }
        
        // MARK: - Helpers
        
        func locate(_ callback: @escaping Callback) {
            self.requests.append(callback)
            sharedLocationManager.startUpdatingLocation()
        }
        
        func reset() {
            self.requests = Array <Callback>()
            sharedLocationManager.stopUpdatingLocation()
        }
        
        // MARK: - Delegate
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            for request in self.requests
            {
                request(.failure(error))
            }
            
            AppUtility.getAppDelegate().window!.makeToast(ErrorMessage.noCurrentLocation, duration: 3.0, position: .top)
            self.reset()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
            for request in self.requests { request(.success(self)) }
            self.reset()
        }
    
    
}
