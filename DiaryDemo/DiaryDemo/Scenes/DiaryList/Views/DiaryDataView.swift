
import UIKit
import RxSwift
import RxCocoa

class DiaryDataView: UIView {
    
    //MARK: - Outlets
    @IBOutlet private weak var bgView           : UIView!
    @IBOutlet private weak var titleLabel       : UILabel!
    @IBOutlet private weak var detailLabel      : UILabel!
    @IBOutlet private weak var diaryTimeLabel   : UILabel!
    @IBOutlet private weak var editButton       : UIButton!
    @IBOutlet private weak var deleteButton     : UIButton!
    
    //MARK: - Callbacks
    var editTap:((String) -> Void)?
    var deleteTap:((String) -> Void)?
    
    //MARK: - Variables
    var disposeBag = DisposeBag()
    
    //MARK: - Property Observers
    var diaryDetail : DiaryData! {
        didSet {
            prapareActionMethods()
            titleLabel.text = diaryDetail.title
            detailLabel.text = diaryDetail.content
            DispatchQueue.main.async {
                self.bgView.dropShadow(color: .gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            }
        }
    }
    
    var diaryType : DiaryType! {
        didSet {
            if let date = diaryDetail.date {
                switch  diaryType {
                case .today, .yesterday:
                    diaryTimeLabel.text = getHourDifference(from: date)
                case .old:
                    diaryTimeLabel.text = getWeekDifference(from: date)
                case .none:
                    break
                }
            }
        }
    }
    
    //MARK: - Action Methods
    private func prapareActionMethods() {
        editButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.editTap?(self.diaryDetail.id ?? "")
        }).disposed(by: disposeBag)
        
        deleteButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.deleteTap?(self.diaryDetail.id ?? "")
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Helper Methods
    private func getHourDifference(from date : Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: date, to: Date())
        let hours = components.hour ?? 0
        return " \(abs(hours)) hours ago"
    }
    
    private func getWeekDifference(from date : Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: Date())
        let weeks = Int((components.day ?? 0) / 7)
        return " \(abs(weeks)) weeks ago"
    }
}
