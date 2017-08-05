
import Foundation

/// `APIAuthorization` defines all the properties and methods a class must contain to be used as an authorization for an `APIRequest`.
public protocol APIAuthorization {
    
    // TODO: Document
    func embedInto<Service: APIService>(request: APIRequest<Service>) -> (HTTPParameters?, JSON?)
}
