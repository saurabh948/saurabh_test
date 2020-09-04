
import Foundation
import RxSwift
import RxCocoa

final class DiaryDetailViewModel: BaseViewModel {
    
    //MARK: - Variables
    var title   = BehaviorRelay<String>(value: "")
    var detail  = BehaviorRelay<String>(value: "")
    
    func saveData(for id: String) {
        if !title.value.isEmpty && !detail.value.isEmpty {
            DBManager.shared.updateData(for: id, title: title.value, content: detail.value)
        }
    }
}

