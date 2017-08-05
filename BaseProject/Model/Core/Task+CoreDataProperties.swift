//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/21/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }
    
    @NSManaged public var uuid: String?
    @NSManaged public var category: Int32
    @NSManaged public var date: Date
    @NSManaged public var finished: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var notificationEnabled: Bool
}
