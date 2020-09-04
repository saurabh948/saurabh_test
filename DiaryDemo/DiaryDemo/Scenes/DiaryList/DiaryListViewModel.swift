
import Foundation
import RxSwift
import RxCocoa

final class DiaryListViewModel: BaseViewModel {
    
    ///`State`
    var state = PublishSubject<ViewModelState<DiaryListViewModel>>()
    
    //MARK: - API Call
    func getDiaryList() {
        state.onNext(.loading)
        
        DiaryListInteractor.fetchData(type: [DiaryData].self)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (diaryList) in
                
                guard let `self` = self else { return }
                
                if diaryList.count > 0 {
                    print(diaryList)
                    self.state.onNext(.success(self))
                    
                } else {
                    self.state.onNext(.failure(.noData))
                }
                
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.state.onNext(.failure(error as! WebError))
                    self.state.onNext(.finish(false))
                    
                }, onCompleted: { [weak self] in
                    guard let `self` = self else { return }
                    self.state.onNext(.finish(false))
                    
            }).disposed(by: disposeBag)
    }
}
