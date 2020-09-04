
import Foundation
import RxSwift
import RxCocoa

enum DiaryType {
    case today
    case yesterday
    case old
    
    func dayDifference(from date : Date) -> DiaryType {
        let calendar = Calendar.current
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfTimeStamp, to: startOfNow)
        let day = components.day ?? 0
        
        if abs(day) < 1 {
            return .today
            
        } else if day == 1 {
            return .yesterday
            
        } else {
            return .old
        }
    }
}

final class DiaryListViewModel: BaseViewModel {
    
    ///`State`
    var state = PublishSubject<ViewModelState<DiaryListViewModel>>()
    
    //MARK: - Variables
    var diaryList =  BehaviorRelay<[DiaryData]>(value: [])
    
    //MARK: - API Call
    func getDiaryList() {
        state.onNext(.loading)
        
        DiaryListInteractor.fetchData(type: [DiaryData].self)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (diaryResponse) in
                
                guard let `self` = self else { return }
                
                if diaryResponse.count > 0 {
                    //print(diaryResponse)
                    self.diaryList.accept(diaryResponse)
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
