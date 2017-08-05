

import UIKit

class APIRequestManager: APIService {
    
    open class func validate(json: JSON) -> JSONValidationResult {
        if let error = json["error"] as? String {
            return .failure(error: error)
        }
        
        if json["image_list"] != nil {
            return .success
        }
        
        return .failure(error: "No data nor error returned.")
    }
    
    open class var baseURL: String {
        return "http://appsdata2.cloudapp.net/"
    }
    
    
    open class var headers: HTTPHeaders? {
        return [
            "Content-Type": "multipart/form-data"
            
        ]
    }
    
    open class func getImages() -> APIRequest<APIRequestManager> {
        
        return APIRequest<APIRequestManager>(endpoint: "image_upload/display_data.php", params: ["": ""], body: nil, method: .POST)
    }
    
    
    //How to USe
    
    //            APIRequestManager.getImages().onSuccess({ (JSON) in
    //                print(JSON)
    //            }).onFailure({ (error) in
    //                print(error)
    //            }).perform(withAuthorization: nil)
    
    // structure definition goes here
}
