
import UIKit

class DiaryListTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var diariesStackView: UIStackView!
    
    //MARK: - Callbacks
    var editTap:((String) -> Void)?
    var deleteTap:((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Property Observer
    var diaryDataObj: DiaryGroup! {
        didSet {
            titleLabel.text = diaryDataObj.type.title
            diariesStackView.removeArrangedSubviews()
            for diary in diaryDataObj.diaryList {
                setDiaryData(with: diary)
            }
        }
    }
    
    private func setDiaryData(with data: DiaryData) {
        let diaryView = DiaryDataView().getXIB(type: DiaryDataView.self)
        diaryView.diaryDetail   = data
        diaryView.diaryType     = diaryDataObj.type
        diaryView.editTap       = { id in
            self.editTap?(id)
        }
        diaryView.deleteTap     = { id in
            self.deleteTap?(id)
        }
        diariesStackView.addArrangedSubview(diaryView)
    }
}
