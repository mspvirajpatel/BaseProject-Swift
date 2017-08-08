//
//  Settings.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/25/16.
//  Copyright @ 2017 MichalSverak. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SettingsData {
    
    static let sharedInstance = SettingsData()
    var settings = [Settings]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getSettingsData() {
        
            do {
                settings = try context.fetch(Settings.fetchRequest())
                addSettings()
            }catch {
                print("Error fetching data from CoreData")
        }
    }
    
    func addSettings() {
        
        if settings.count == 0 {
            
            let settings = Settings(context: context)
            settings.notifcationsEnabled = true
            settings.sortedBy = "name"
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func editSettings(SortedBy: String) {
        
        let request = NSFetchRequest<Settings>(entityName: "Settings")
        
        do {
            let searchResults = try context.fetch(request)
            
            searchResults[0].sortedBy = SortedBy
           
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func editSettings(NotificationsEnabled: Bool) {
        
        let request = NSFetchRequest<Settings>(entityName: "Settings")
        
        do {
            let searchResults = try context.fetch(request)
            
            searchResults[0].notifcationsEnabled = NotificationsEnabled
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    
}
