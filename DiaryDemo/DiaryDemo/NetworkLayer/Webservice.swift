
import Alamofire
import Foundation
import RxSwift
import RxCocoa

final class Webservice: Session {
    var header : HTTPHeaders = [
        "Content-Type":"application/json"
    ]
    
    static let API: Webservice = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest  = 60
        
        var webService = Webservice(configuration: configuration)
        return webService
    }()
    
    @discardableResult
    func sendRequest<T: Codable>(_ route: Router, type: T.Type) -> Observable<T> {
        
        return Observable<T>.create { observer -> Disposable in
            
            guard NetworkReachabilityManager()!.isReachable == true else {
                observer.onError(WebError.noInternet)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let path = route.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
            
            var parameter = route.parameters
            
            if route.parameters == nil {
                parameter = [:]
            }
            
            var encoding: ParameterEncoding = JSONEncoding.default
            if route.method == .get {
                encoding = URLEncoding.default
            }
            
            let request = self.request(path!, method: route.method, parameters: parameter!, encoding: encoding, headers: self.header)
            
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    if let resp = try? JSONDecoder().decode(type.self, from: data) {
                        observer.onNext(resp)
                    } else {
                        observer.onError(WebError.noData)
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                    if error._code == NSURLErrorTimedOut {
                        observer.onError(WebError.timeout)
                    } else if error._code == NSURLErrorCannotConnectToHost {
                        observer.onError(WebError.hostFail)
                    } else if error._code == NSURLErrorCancelled {
                        observer.onError(WebError.cancel)
                    } else if error._code == NSURLErrorNetworkConnectionLost {
                        observer.onError(WebError.noInternet)
                    } else {
                        observer.onError(WebError.unknown)
                    }
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

