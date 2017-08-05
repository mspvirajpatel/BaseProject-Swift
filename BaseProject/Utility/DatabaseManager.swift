import GRDB
import UIKit

var dbQueue: DatabaseQueue!

class DatabaseManager: NSObject
{
    static let sharedInstance : DatabaseManager = DatabaseManager.init()
    var oprationQueue : OperationQueue!
    
    var migration : DatabaseMigrator!
    
    
    private override init(){
        super.init()
    }
    
    // MARK: Initial SetUp method
    func setUpDatabase(_ application : UIApplication) throws -> Void
    {
        // Connect to Database
        let documentPath : NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let databasePath : NSString = documentPath.appendingPathComponent("MyData.sqlite") as NSString
        
        dbQueue = try DatabaseQueue(path: databasePath as String)
        print("Database Path:-" + (databasePath as String))
        // Memoery management
        dbQueue.setupMemoryManagement(in: application)
        migration = DatabaseMigrator()
        oprationQueue = OperationQueue()
        try self.createTableForIntialSetup()
    }
    
    // MARK: Table Create metohds
    private func createTableForIntialSetup() throws{
        
        // Migration Version1 is For Build Version 1.0
        
        migration.registerMigration("version1") { (db) in
           
            try db.create(table: "Person") { table in
                // An integer primary key auto-generates unique IDs
                table.column("id", .integer).primaryKey()
                
                // Sort person names in a localized case insensitive fashion by default
                // See https://github.com/groue/GRDB.swift/#unicode
                table.column("name", .text).notNull().collate(.localizedCaseInsensitiveCompare)
                
                table.column("score", .text).notNull()
                table.column("email", .text).notNull()
                
            }
            
            self.insertPersonData(db: db)
        }
        
        try migration.migrate(dbQueue)
    }
    
    // MARK: Migration Methods
    /// Version 1
    private func insertPersonData(db : Database)
    {
        do
        {
            try db.execute("INSERT OR REPLACE INTO Person (name,score,email) VALUES(:name,:score,:email,:title)", arguments: ["name" : "Viraj","score" : "120","email" : "patel@gmail.com","title" : "New"])
            try db.execute("INSERT OR REPLACE INTO Person (name,score,email) VALUES(:name,:score,:email,:title)", arguments: ["name" : "Hiren","score" : "120","email" : "patel1@gmail.com"])
            
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: Data Retriaval Methods
    /// This is for Retrive the File Search List as per Type
    public func getPersonList(completion : @escaping (_ fileTypes : Array<Person>) -> Void) -> Void
    {
        oprationQueue.addOperation {
            do
            {
                try dbQueue.inDatabase({ (db) throws in
                    
                    let rows = try Row.fetchAll(db, "SELECT * from Person")
                    var arrType : Array<Person> = []
                    for row in rows{
                        arrType.append(Person.init(row: row))
                    }
                    completion(arrType)
                })
            }
            catch let error as NSError{
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    /// Its for perform search on Sync cloud Files in database
    public func searchPerson(keyword : String, completion : @escaping (_ files : Array<Person>) -> Void) -> Void
    {
        oprationQueue.addOperation {
            do
            {
                try dbQueue.inDatabase({ (db) throws in
                    let rows = try Row.fetchCursor(db, "SELECT * from Person WHERE name LIKE '%\(keyword)%' ORDER BY name ASC")
                    var arrFiles : Array<Person> = []
                    while let row = try rows.next(){
                        arrFiles.append(Person.init(row: row))
                    }
                    completion(arrFiles)
                })
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    
    /// Its will Check that File is favourite or not while showing All Syncd Files from File_Master Table
    public func checkPerson(fileId : String,completion : @escaping (_ completed : Bool) -> Void)
    {
        oprationQueue.addOperation {
            do
            {
                try dbQueue.inDatabase({ (db) throws in
                    
                    let rows = try Row.fetchCursor(db, "SELECT * from Person WHERE id = '\(fileId)'")
                    while let _ = try rows.next(){
                        completion(true)
                        break
                    }
                })
            }
            catch let error as NSError{
                print(error.localizedDescription)
                completion(false)
            }
        }
        
    }
    
    // MARK: Data Insert Methods
    /// Method for Insert synced files in dabasebase
    public func insertPersons(Files arrfile : [Person],completion : @escaping (_ completed : Bool) -> Void)
    {
        oprationQueue.addOperation {
            do
            {
                try dbQueue.inDatabase({ (db) throws in
                    
                    for file in arrfile
                    {
                        try db.execute("INSERT OR REPLACE INTO Person (name,email) VALUES(:name,:email)", arguments: ["name": file.name,"createdDate" : file.email])
                    }
                    completion(true)
                })
            }
            catch let error as NSError{
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Data Deletation Methods
    /// Method for Remvoe all syncd file from File_Master
    public func clearPersons(){
        do{
            try dbQueue.inDatabase({ (db) throws in
                try db.execute("DELETE FROM Person")
            })
        }
        catch let error as NSError{
            print("Error while delete :- \(error.localizedDescription)")
        }
    }
    
   
    /// This method is used ot Unfavourite cloud file and remove it from Favourite Master Table
    public func removePerson(fileId : String,completion : (_ completed : Bool) -> Void){
        do{
            try dbQueue.inDatabase({ (db) throws in
                try db.execute("DELETE FROM Person WHERE id = '\(fileId)'")
                completion(true)
            })
        }
        catch let error as NSError{
            print(error.localizedDescription)
            completion(false)
        }
    }

    
    // MARK : Data Updations Methods
    
    // MARK: Utility Methods
}

