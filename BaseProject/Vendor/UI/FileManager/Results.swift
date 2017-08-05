//
//  Result.swift



public enum Results<S,F> {
    
    case success(S)
    case failure(F)
    
    public init(success:S){
        self = .success(success)
    }
    
    public init(failure:F){
        self = .failure(failure)
    }
    
    public var isSuccess:Bool {
        switch self {
            case .success: return true
            case .failure: return false
        }
        
    }
    
    public var isFailure:Bool {
        switch self {
            case .success: return false
            case .failure: return true
        }
    }
    
    public var value:S? {
        switch self {
        case .success(let success):
            return success
        case .failure(_):
            return .none
        }
    }
    
    public var error:F? {
        switch self {
        case .success(_):
            return .none
        case .failure(let error):
            return error
        }
    }
    
    public func onFailure(_ handler:(F) -> Void ) -> Results<S,F> {
        switch self {
        case .success(_):
            return self
        case .failure(let error):
            handler( error )
            return self
        }
    }
    
    public func onSuccess(_ handler:(S) -> Void ) -> Results<S,F> {
        switch self {
        case .success(let success):
            handler(success )
            return self
        case .failure(_):
            return self
        }
    }
   
}


//How to Use 


//Create instance
//
//You can create Path object from String.
//
//let fooDir = Path("/path/to/fooDir")
//
//// You can re obtain String by calling toString.
//fooDir.toString() // "/path/to/fooDir"
//Get accessible Path from App by factory methods.
//
//Path.homeDir.toString()
//// "/var/mobile/Containers/Data/Application/<UUID>"
//
//Path.documentsDir.toString()
//// "/var/mobile/Containers/Data/Application/<UUID>/Documents"
//
//Path.cacheDir.toString()
//// "var/mobile/Containers/Data/Application/<UUID>/Library/Caches"
//
//Path.temporaryDir.toString()
//// "var/mobile/Containers/Data/Application/<UUID>/Library/tmp"
//Access to other directories and files
//
////  Get Path that indicate foo.txt file in Documents dir
//let textFilePath = Path.documentsDir["foo.txt"]
//textFilePath.toString() //  "~/Documents/foo.txt"
//
////  You can access subdir.
//let jsonFilePath = Path.documentsDir["subdir"]["bar.json"]
//jsonFilePath.toString() //  "~/Documents/subdir/bar.json"
//
//// Access to parent Path.
//jsonFilePath.parent.toString() // "~/Documents/subdir"
//jsonFilePath.parent.parent.toString() // "~/Documents"
//jsonFilePath.parent.parent.parent.toString() // "~/"
//let contents = Path.homeDir.contents!
////  Get dir contents as Path object.
//// [
////    Path<~/.com.apple.mobile_container_manager.metadata.plist>,
////    Path<~/Documents>,
////    Path<~/Library>,
////    Path<~/tmp>,
//// ]
//
//// Or you can use dir as iterator
//for content:Path in Path.homeDir {
//    println(content)
//}
//Access to file infomation
//
//Check if path is dir or not.
//
//Path.homeDir.isDir // true
//Path.homeDir["hoge.txt"].isDir //false
//Check if path is exists or not.
//
//// homeDir is exists
//Path.homeDir.exists // true
//
//// Is there foo.txt in homeDir ?
//Path.homeDir["foo.txt"].exists
//
//// Is there foo.txt in myDir ?
//Path.homedir["myDir"]["bar.txt"].exists
//You can get basename of file.
//
//Path.homedir["myDir"]["bar.txt"].basename // bar.txt
//You can get file extension.
//
////  Get all *json files in Documents dir.
//let allFiles  = Path.documentsDir.contents!
//let jsonFiles = allFiles.filter({$0.ext == "json" })
//You can get more attributes of file.
//
//let jsonFile = Path.documentsDir["foo.json"]
//jsonFile.attributes!.fileCreationDate()! // 2015-01-11 11:30:11 +0000
//jsonFile.attributes!.fileModificationDate()! // 2015-01-11 11:30:11 +0000
//jsonFile.attributes!.fileSize() // 2341
//File operation
//
//Create ( or delete ) dir and files.
//
//// Create "foo" dir in Documents.
//let fooDir = Path.documentsDir["foo"]
//fooDir.mkdir()
//
////  Create empty file "hoge.txt" in "foo" dir.
//let hogeFile = fooDir["hoge.txt"]
//hogeFile.touch()
//
//// Delete foo dir
//fooDir.remove()
//Copy ( or move ) file.
//
//let fooFile = Path.documentsDir["foo.txt"]
//let destination = Path.tmpDir["foo.txt"]
//fooFile.copyTo( destination )
//Write ( or read ) string data.
//
//// Write string.
//let textFile = Path.documentsDir["hello.txt"]
//textFile.writeString("HelloSwift")
//
//// Read string.
//let text = textFile.readString()! // HelloSwift
//Write ( or read ) binary data.
//
////  Write binary data.
//let binFile = Path.documentsDir["foo.bin"]
//binFile.writeData( NSData()  )
//
//// Read  binary data.
//let data = binFile.readData()!
//Error handling
//
//touch/remove/copyTo/writeTo/mkdir returns Result as Enum.
//
//If operation is success, Result has value property. If operation is failure,Result has error property.
//
//let result = Path.documentsDir["subdir"].mkdir()
//if( result.isSuccess ){
//    println( result.value! )
//}
//if( result.isFailure ){
//    println( result.error! )
//}
//Or you can write by closure style. ( You use this style, you don't need to unwrap optional value )
//
//Path.documentsDir["subdir"].mkdir()
//.onSuccess({ (value:Path) in
//println( value )
//})
//.onFailure({ (error:NSError) in
//println( error )
//})
