
import Foundation
import RxSwift

struct DiaryListInteractor {
    static func fetchData<T: Codable>(type: T.Type) -> Observable<T> {
        return Webservice.API.sendRequest(.getDiaryList([:]), type: T.self)
    }
}
