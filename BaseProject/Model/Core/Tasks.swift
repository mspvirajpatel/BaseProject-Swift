//
//  Tasks.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/6/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class Tasks {
    
    static let sharedInstance = Tasks()
    
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addTask(description: String, date: Date, finished: Bool, category: Int, uuid: String) {
        
        let task = Task(context:context)
        task.category = Int32(category)
        task.date = date
        task.finished = finished
        task.taskDescription = description
        task.uuid = uuid
        task.notificationEnabled = false
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func removeTask(withUUID: String) {
        
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let searchResults = try context.fetch(request)
            
            for task in searchResults {
                
                if task.uuid == withUUID {
                    
                    // unschedule notification
                    if task.notificationEnabled == true {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.uuid!])
                    }
                    // delete task
                    context.delete(task)
                }
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

    }
    
    func searchTask(withTask: String) -> [Task]? {
       
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.predicate = NSPredicate(format: "taskDescription CONTAINS[cd] %@", withTask)
        do {
            let searchResults = try context.fetch(request)
            var taks : [Task] = [Task]()
            
            for task in searchResults {
                taks.append(task)
            }
            return taks
            
        } catch {
            print("Error with request: \(error)")
            return nil
            
        }
        
    }
    
    
    func taskNotification(isEnabled: Bool, uuid: String) {
        
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let searchResults = try context.fetch(request)
            
            for task in searchResults {
                
                if task.uuid == uuid {
                    task.notificationEnabled = isEnabled
                }
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func updateTask(uuid: String, isFinished: Bool) {
        
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let searchResults = try context.fetch(request)
            
            for task in searchResults {
                
                if task.uuid == uuid {
                    task.finished = isFinished
                }
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func updateTask(uuid: String, desc: String) {
        
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let searchResults = try context.fetch(request)
            
            for task in searchResults {
                
                if task.uuid == uuid {
                    task.taskDescription = desc
                }
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    
    func editTask(withUUID: String, description: String, date: Date, finished: Bool, category: Int) {
        
        
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let searchResults = try context.fetch(request)
            
            for task in searchResults {
                if task.uuid == withUUID {
                    
            task.taskDescription = description
            task.date = date
            task.finished = finished
            task.category = Int32(category)
                    
                    }
                }
    } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func tasksData() -> [Task] {
        
        do {
        tasks = try context.fetch(Task.fetchRequest())
        }catch {
        print("Error fetching data from CoreData")
        }
        
        return tasks
    }
}
