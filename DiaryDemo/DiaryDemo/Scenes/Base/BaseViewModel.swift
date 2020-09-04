
import Foundation
import RxSwift
import RxCocoa

enum ViewModelState<T> {
    case loading
    case failure(WebError)
    case success(T)
    case finish(Bool)
}

class BaseViewModel {
    // Dispose Bag
    let disposeBag  = DisposeBag()
    let alertDialog = PublishSubject<(String)>()
    let toastDialog = PublishSubject<(String)>()
}
