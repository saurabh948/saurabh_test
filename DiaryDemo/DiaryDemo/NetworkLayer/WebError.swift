
import Foundation

enum WebError: Error {
    case noData
    case noInternet
    case hostFail
    case parseFail
    case timeout
    case unAuthorise
    case cancel
    case unknown
}
