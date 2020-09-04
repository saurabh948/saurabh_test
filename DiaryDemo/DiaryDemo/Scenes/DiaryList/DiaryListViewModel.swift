
import Foundation
import RxSwift
import RxCocoa

final class DiaryListViewModel: BaseViewModel {
    
    ///`State`
    var state = PublishSubject<ViewModelState<DiaryListViewModel>>()
    
    //MARK: - Variables
    var diaryList           =  [DiaryData]()
    var formatedDiaryList   =  BehaviorRelay<[DiaryGroup]>(value: [])
    
    //MARK: - API Call
    private func getDiaryList() {
        state.onNext(.loading)
        
        DiaryListInteractor.fetchData(type: [DiaryData].self)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (diaryResponse) in
                
                guard let `self` = self else { return }
                
                if diaryResponse.count > 0 {
                    //print(diaryResponse)
                    self.diaryList = diaryResponse
                    self.formatDiaryData(diaryResponse)
                    DBManager.shared.deleteEntity(DataEntity.diaryData.rawValue)
                    self.addDataToDB(diaryResponse)
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

//MARK: - DB Methods
extension DiaryListViewModel {
    func fetchDataFromDB() {
        DBManager.shared.fetchQuery(entity: DataEntity.diaryData.rawValue) { (objs) in
            let fetchedData = objs.reduce(into: [DiaryData]()) { (result, data) in
                result.append(DiaryData(data: data))
            }
            if fetchedData.count > 0 {
                diaryList = fetchedData
                formatDiaryData(fetchedData)
                
            } else {
                getDiaryList()
            }
        }
    }
    
    private func addDataToDB(_ diaryDataArray: [DiaryData]) {
        for obj in diaryDataArray {
            DBManager.shared.AddDiaryData(diaryData: obj)
        }
    }
    
    func deleteDiary(for id : String) {
        DBManager.shared.deleteDiaryById(for: id)
        fetchDataFromDB()
    }
}

//MARK: - Helper Methods
extension DiaryListViewModel {
    private func formatDiaryData(_ diaryArray : [DiaryData]) {
        let diaryDataArray = diaryArray.filter({ $0.date != nil }).sorted(by: { $0.date!.compare($1.date!) == .orderedDescending })
        
        var todayData       = [DiaryData]()
        var yesterdayData   = [DiaryData]()
        var oldData         = [DiaryGroup]()
        
        for diaryObj in diaryDataArray {
            if let date = diaryObj.date {
                let diaryType = getType(from : date)
                switch diaryType {
                case .today:
                    todayData.append(diaryObj)
                case .yesterday:
                    yesterdayData.append(diaryObj)
                    
                case .old:
                    let months = oldData.map({ $0.type.title })
                    let index = months.firstIndex(of: diaryType.title)
                    if index == nil {
                        oldData.append(DiaryGroup(type: diaryType, diaryList: [diaryObj]))
                    } else {
                        oldData[index!].diaryList.append(diaryObj)
                    }
                }
            }
        }
        var formatedArray = [DiaryGroup]()
        if todayData.count > 0 {
            formatedArray.append(DiaryGroup(type: .today, diaryList: todayData))
        }
        if yesterdayData.count > 0 {
            formatedArray.append(DiaryGroup(type: .yesterday, diaryList: yesterdayData))
        }
        if oldData.count > 0 {
            formatedArray += oldData
        }
        formatedDiaryList.accept(formatedArray)
    }
    
    private func getType(from date : Date) -> DiaryType {
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
            let month = DateManager.monthInitial.string(from: date)
            return .old(month)
        }
    }
}
