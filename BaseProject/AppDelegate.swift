//
//  AppDelegate.swift
//  BaseProjectSwift
//
//  Created by MacMini-2 on 14/11/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    var navigationController: BaseNavigationController?
   
    var menuNavigationController:BaseNavigationController!
    
    var slidemenuController : DLHamburguerViewController?
    var LeftMenu : LeftMenuController?
    
    // MARK: - Lifecycle -
    
    override init() {
        super.init()
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        //Fabrik For Twitter Login
        do{
            try DatabaseManager.sharedInstance.setUpDatabase(application)
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }

        SettingsData.sharedInstance.getSettingsData()
        
        AppUtility.clearImageData()
        
        self.loadUI()
        
        return true
        
    }
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        application.applicationIconBadgeNumber = 0;
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
    }
    
    //Use AppDelegate().sharedInstance()
    func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    fileprivate func loadUI(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        self.displayDashboardViewOnWindow()
        
        window?.makeKeyAndVisible()
        
    }
    
    func displayDashboardViewOnWindow() {
        
        self.loadDashboardView()
        self.window?.rootViewController = slidemenuController
    }
    
    func loadDashboardView() {
        
        self.menuNavigationController = BaseNavigationController(rootViewController: BaseViewController())
        self.LeftMenu = LeftMenuController()
        self.slidemenuController = DLHamburguerViewController.init()
        
        self.slidemenuController?.findHamburguerViewController()?.menuDirection = .left
        self.slidemenuController?.contentViewController = self.menuNavigationController
        self.slidemenuController?.menuViewController = LeftMenu
        
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TaskCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

