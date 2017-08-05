//
//  File.swift


extension  Path {
    
    public var ext:NSString {
        return URL(fileURLWithPath:path_string).pathExtension as NSString
    }
    
    public func touch() -> Results<Path,NSError> {
        assert(!self.isDir,"Can NOT touch to dir")
        return self.exists
            ? self.updateModificationDate()
            : self.createEmptyFile()
    }
    
    public func updateModificationDate(_ date: Date = Date() ) -> Results<Path,NSError>{
        var error: NSError?
        let result: Bool
        do {
            try fileManager.setAttributes(
                        [FileAttributeKey.modificationDate :date],
                        ofItemAtPath:path_string)
            result = true
        } catch let error1 as NSError {
            error = error1
            result = false
        }
        return result
            ? Results(success: self)
            : Results(failure: error!)
    }
    
    fileprivate func createEmptyFile() -> Results<Path,NSError>{
        return self.writeString("")
    }
    
    // MARK: - read/write String
    
    public func readString() -> String? {
        assert(!self.isDir,"Can NOT read data from  dir")
        var readError:NSError?
        let read: String?
        do {
            read = try String(contentsOfFile: path_string,
                                            encoding: String.Encoding.utf8)
        } catch let error as NSError {
            readError = error
            read = nil
        }
        
        if let error = readError {
            print("readError< \(error.localizedDescription) >")
        }
        
        return read
    }
    
    public func writeString(_ string:String) -> Results<Path,NSError> {
        assert(!self.isDir,"Can NOT write data from  dir")
        var error: NSError?
        let result: Bool
        do {
            try string.write(toFile: path_string,
                        atomically:true,
                        encoding: String.Encoding.utf8)
            result = true
        } catch let error1 as NSError {
            error = error1
            result = false
        }
        return result
            ? Results(success: self)
            : Results(failure: error!)
    }
    
    // MARK: - read/write NSData
    
    public func readData() -> Data? {
        assert(!self.isDir,"Can NOT read data from  dir")
        return (try? Data(contentsOf: URL(fileURLWithPath: path_string)))
    }
    
    public func writeData(_ data:Data) -> Results<Path,NSError> {
        assert(!self.isDir,"Can NOT write data from  dir")
        var error: NSError?
        let result: Bool
        do {
            try data.write(to: URL(fileURLWithPath: path_string), options:.atomic)
            result = true
        } catch let error1 as NSError {
            error = error1
            result = false
        }
        return result
            ? Results(success: self)
            : Results(failure: error!)
    }
    
}
