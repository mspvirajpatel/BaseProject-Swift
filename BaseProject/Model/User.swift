
import CoreData
import Foundation

//class Person: NSManagedObject {
//    
//    // Insert code here to add functionality to your managed object subclass
//    
//}
//
//extension Person {
//    
//    @NSManaged var id: String!
//    @NSManaged var name: String!
//    @NSManaged var score: String!
//    @NSManaged var email: String!
//    
//}

class UserModel {
    
    var inputDictionary = Dictionary<String, AnyObject>()
    
    convenience init(inputDictionary: Dictionary<String, AnyObject>) {
        self.init()
        self.inputDictionary = inputDictionary
    }
    
    var username: String {
        set(newName) {
            inputDictionary["name"] = newName as AnyObject
        }
        get {
            return (inputDictionary["name"] as? String)!
        }
    }
    
    var email: String {
        set(email) {
            inputDictionary["email"] = email as AnyObject
        }
        get {
            return (inputDictionary["email"] as? String)!
        }
    }
    
    
}
