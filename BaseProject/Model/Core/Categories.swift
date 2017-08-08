

import Foundation
import UIKit
import CoreData

class Categories {
    
    static let sharedInstance = Categories()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    func addCategory(categoryTitle: String, color: UIColor) {
        
        let category = Category(context: context)
        
        category.category = categoryTitle
        category.color = color
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

    }
    
    func categoryAtIndex(category: Category) -> Int {
        
        let i = categories.index{$0 === category}
        return i!
    }
    
    func editCategory(atIndex: Int, categoryTitle: String, color: UIColor) {
        
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            let searchResults = try context.fetch(request)
            
            searchResults[atIndex].category = categoryTitle
            searchResults[atIndex].color = color
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func getCategories() -> [Category] {
        
        do {
            categories = try context.fetch(Category.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        
        defaultCategories()

        return categories
    }
    
    func defaultCategories() {
        
        if categories.count == 0 {
        let category1 = Category(context: context)
        category1.category = "Home"
        category1.color = UIColor(red: 234/255.0, green: 108/255.0, blue: 98/255.0, alpha: 1.0)
        
        let category2 = Category(context: context)
        category2.category = "Work"
        category2.color = UIColor(red: 0/255.0, green: 147/255.0, blue: 255/255.0, alpha: 1.0)
        
        let category3 = Category(context: context)
        category3.category = "Fitness"
        category3.color = UIColor(red: 102/255.0, green: 255/255.0, blue: 102/255.0, alpha: 1.0)
        
        let category4 = Category(context: context)
        category4.category = "Health"
        category4.color = UIColor(red: 41/255.0, green: 179/255.0, blue: 173/255.0, alpha: 1.0)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }

    }
}







