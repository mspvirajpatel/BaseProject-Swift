//
//  Settings+CoreDataProperties.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/25/16.
//  Copyright @ 2017 MichalSverak. All rights reserved.
//

import Foundation
import CoreData

extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings");
    }

    @NSManaged public var sortedBy: String?
    @NSManaged public var notifcationsEnabled: Bool

}
