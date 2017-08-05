//
//  APIManager.swift
//  APIManager
//

//

import Foundation
import MobileCoreServices

class APIManager{
    
    class var shared: APIManager
    {
        struct Static
        {
            static var instance: APIManager?
        }
        
        let _onceToken = NSUUID().uuidString
        
        DispatchQueue.once(token: _onceToken) {
            Static.instance = APIManager()
        }
        return Static.instance!
    }
    
    static let urlString = APIConstant.userPhotoList
    
    func getRequest(URL url : String , Parameter param : NSDictionary , Type type : APITask, completionHandler : @escaping (_ result : Result) -> ()){
        AppUtility.isNetworkAvailableWithBlock { (isAvailable) in
            if isAvailable == true{
                completionHandler(Result.Internet(isOn: true))
                
                var requestURL : String! = APIConstant.baseURL + url
                let headers = [
                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                    "Accept": "application/json"
                ]
                
                print("---------------------")
                print("\(type.rawValue) request :- \(param .JSONString())")
                print("Request URL :- \(requestURL)")
                print("---------------------")
                
                
                var request = URLRequest(url: URL(string:requestURL)!)
                request.httpMethod = "get"
                let strings : String = param.JSONString() as String
                request.httpBody = strings.data(using: .utf8)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
                        print("error=\(error)")
                        
                        completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                        // make error here and then
                        completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                        return
                    }
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString)")
                    
                    DispatchQueue.main.async {
                        do {
                            let dicResponse:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] as NSDictionary
                            
                            print("Response : \((dicResponse) .JSONString())")
                            
                            var handledResopnse : (BaseError? , AnyObject?)! = self.handleResponse(response: dicResponse, task: type)
                            if handledResopnse.1 != nil{
                                completionHandler(Result.Success(response: handledResopnse.1, error: handledResopnse.0))
                            }
                            else{
                                completionHandler(Result.Error(error: handledResopnse.0))
                            }
                            defer{
                                handledResopnse = nil
                            }
                            
                        } catch {
                            completionHandler(Result.Error(error: self.handleFailure(error: error)))
                        }
                    }
                    
                    
                }
                task.resume()
                
                
                requestURL = nil
                
            }
            else{
                completionHandler(Result.Internet(isOn: false))
            }
        }
    }
    
    
    func postRequest(URL url : String , Parameter param : NSDictionary , Type type : APITask, completionHandler : @escaping (_ result : Result) -> ()){
        AppUtility.isNetworkAvailableWithBlock { (isAvailable) in
            if isAvailable == true{
                completionHandler(Result.Internet(isOn: true))
                
                var requestURL : String! = APIConstant.baseURL + url
                let headers = [
                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                    "Accept": "application/json"
                ]
                
                print("---------------------")
                print("\(type.rawValue) request :- \(param .JSONString())")
                print("Request URL :- \(requestURL)")
                print("---------------------")
                
                    
                    var request = URLRequest(url: URL(string:requestURL)!)
                    request.httpMethod = "post"
                    let strings : String = param.JSONString() as String
                    request.httpBody = strings.data(using: .utf8)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {                                                 // check for fundamental networking error
                            print("error=\(error)")
                           
                            completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(response)")
                            // make error here and then
                            completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                            return
                        }
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            let httpStatus = self.getHTTPStatusCode(httpResponse)
                            print("HTTP Status Code: \(httpStatus.rawValue) \(httpStatus)")
                            
                            if httpStatus.rawValue != 200 {
                                let statusError = NSError(domain:"com.io-pandacode.CoreDataCRUD", code:httpStatus.rawValue, userInfo:[NSLocalizedDescriptionKey: "HTTP status code: \(httpStatus.rawValue) - \(httpStatus)"])
                                
                            } else {
                                
                            }
                            
                        }
                        
                        let responseString = String(data: data, encoding: .utf8)
                        print("responseString = \(responseString)")
                        
                        DispatchQueue.main.async {
                            do {
                                let dicResponse:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] as NSDictionary
                                
                                print("Response : \((dicResponse) .JSONString())")
                                
                                var handledResopnse : (BaseError? , AnyObject?)! = self.handleResponse(response: dicResponse, task: type)
                                if handledResopnse.1 != nil{
                                    completionHandler(Result.Success(response: handledResopnse.1, error: handledResopnse.0))
                                }
                                else{
                                    completionHandler(Result.Error(error: handledResopnse.0))
                                }
                                defer{
                                    handledResopnse = nil
                                }
                                
                            } catch {
                                completionHandler(Result.Error(error: self.handleFailure(error: error)))
                            }
                        }
                        
                        
                    }
                    task.resume()
                
                
                requestURL = nil
                
            }
            else{
                completionHandler(Result.Internet(isOn: false))
            }
        }
    }
    
    /**
     Get the HTTP status code of the request reponse.
     
     - Parameter httpURLResponse: the reponse that will contain the response code.
     - Returns: HTTPStatusCode status code of HTTP response.
     */
    func getHTTPStatusCode(_ httpURLResponse: HTTPURLResponse) -> HTTPStatusCode {
        var httpStatusCode: HTTPStatusCode!
        
        for status in HTTPStatusCode.getAll {
            if httpURLResponse.statusCode == status.rawValue {
                httpStatusCode = status
            }
        }
        
        return httpStatusCode
    }
    
    func uploadImage (url: String, Parameter param : NSDictionary, Images arrImage: NSArray, Type type : APITask , completionHandler : @escaping (_ result : Result) -> ()) -> Void
    {
        
        AppUtility.isNetworkAvailableWithBlock { (isAvailable) in
            
            if isAvailable == true{
                completionHandler(Result.Internet(isOn: true))
                var requestURL : String! = APIConstant.baseURL + url
                let headers = [
                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                    "Accept": "application/json"
                ]
                
                print("---------------------")
                print("\(type.rawValue) request :- \(param .JSONString())")
                print("Request URL :- \(requestURL)")
                print("---------------------")
                
                    var request : URLRequest
                    do {
                        request = try self.createRequest(param, requestURL: APIConstant.baseURL + url, Image: arrImage)
                        
                    } catch {
                        print(error)
                        return
                    }
                    
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {                                                 // check for fundamental networking error
                            print("error=\(error)")
                            
                            completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                            return
                        }
                        
//                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                            print("response = \(response)")
//                            // make error here and then
//                            if error != nil
//                            {
//                                completionHandler(Result.Error(error: self.handleFailure(error: error!)))
//                            }
//                            else
//                            {
//                                completionHandler(Result.Error(error: self.handleFailure(error: Error())))
//                            }
//                            
//                            return
//                        }
                        let responseString = String(data: data, encoding: .utf8)
                        print("responseString = \(responseString)")
                        
                        DispatchQueue.main.async {
                            do {
                                let dicResponse:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] as NSDictionary
                                
                                print("Response : \((dicResponse) .JSONString())")
                                
                            
                                var handledResopnse : (BaseError? , AnyObject?)! = self.handleResponse(response: dicResponse, task: type)
                                
                                if handledResopnse.1 != nil{
                                    completionHandler(Result.Success(response: handledResopnse.1, error: handledResopnse.0))
                                }
                                else{
                                    completionHandler(Result.Error(error: handledResopnse.0))
                                }
                                
                                defer{
                                    handledResopnse = nil
                                }
                                
                                
                            } catch {
                                completionHandler(Result.Error(error: self.handleFailure(error: error)))
                            }
                        }
                        
                        
                    }
                    task.resume()
                
                
                requestURL = nil

            }
            else{
                completionHandler(Result.Internet(isOn: false))
            }
        }
    }
    
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created
    
    func createRequest(_ parameter : NSDictionary,requestURL : String, Image : NSArray) throws -> URLRequest {
        let parameters = parameter  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: requestURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try createBody(with: parameters as? [String : String], filePathKey: "file", paths: [Image], boundary: boundary)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    func createBody(with parameters: [String: String]?, filePathKey: String, paths: [NSArray], boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        for imageInfo in paths
        {
            let dicInfo : NSDictionary! = imageInfo[0] as? NSDictionary
          
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(dicInfo["name"] as! String)\"; filename=\"\(dicInfo["fileName"] as! String)\"\r\n")
            body.append("Content-Type: \(dicInfo["type"] as! String)\r\n\r\n")
            body.append(dicInfo["data"] as! Data)
            body.append("\r\n")
            
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeType(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    
    private func handleResponse(response : AnyObject,task : APITask) -> (BaseError? , AnyObject?){
        
        var baseError : BaseError! = BaseError.getError(responseObject: response, task: task)
        
        if baseError.errorCode == "1" || baseError.errorCode == "200"{ // 1 is success code, here we need to set success code as per project and api backend. its may 1 or 200, depend on API
            var modelResponse : AnyObject! = MainResponse().getModelFromResponse(response: response , task: task)
            defer{
                modelResponse = nil
                baseError = nil
            }
            return (baseError,modelResponse)
        }
        else{
            defer{
                baseError = nil
            }
            return (baseError, nil)
        }
    }
    
    private func handleFailure(error : Error) -> BaseError{
        
        print("Error : \(error.localizedDescription)")
        
        var baseError : BaseError! = BaseError()
        
        switch error._code{
        case NSURLErrorTimedOut:
            baseError.errorCode = String(error._code)
            baseError.alertMessage = "Server is not responding please try again after some time."
            baseError.serverMessage = "Server is not responding please try again after some time."
            break
        case NSURLErrorNetworkConnectionLost:
            baseError.errorCode = String(error._code)
            baseError.alertMessage = "Network connection lost try again."
            baseError.serverMessage = "Network connection lost try again."
            break
        default:
            baseError.errorCode = String(-1)
            baseError.alertMessage = "Something wants wrong please try again leter."
            baseError.serverMessage = "Something wants wrong please try again leter."
            break
        }
        
        defer{
            baseError = nil
        }
        return baseError
    }
    
    func ServiceCall(method: String,parameter:String, completion: @escaping (_ dictionary: NSDictionary?, _ error: Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            var request = URLRequest(url: URL(string:APIManager.urlString)!)
            request.httpMethod = method
            request.httpBody = parameter.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    completion(nil, error)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    // make error here and then
                    completion(nil, error)
                    return
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                
                DispatchQueue.main.async {
                    do {
                        let jsonDictionary:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] as NSDictionary
                        completion(jsonDictionary, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
                
                
            }
            task.resume()
        }
    }
}
