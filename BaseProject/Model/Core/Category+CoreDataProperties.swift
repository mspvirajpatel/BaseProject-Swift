//
//  Category+CoreDataProperties.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/21/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var category: String?
    @NSManaged public var color: NSObject?

}
