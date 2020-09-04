
import Foundation
import Alamofire

protocol Routable {
    var path : String { get }
    var method : HTTPMethod { get }
    var parameters : Parameters? { get }
}

enum Router: Routable {
    case getDiaryList(Parameters)
}

extension Router {
    var path: String {
        var endApiPath = ""
        switch self {
        case .getDiaryList:
            endApiPath = "notes"
        }
        return Environment.basePath + endApiPath
    }
}

extension Router {
    var method: HTTPMethod {
        switch self {
        case .getDiaryList:
            return .get
        }
    }
}

extension Router {
    var parameters: Parameters? {
        switch self {
        case .getDiaryList(let param):
            return param
        }
    }
}
