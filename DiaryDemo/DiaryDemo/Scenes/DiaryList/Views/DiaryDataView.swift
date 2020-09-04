
import UIKit

class DiaryDataView: UIView {
    
    //MARK: - Outlets
    @IBOutlet private weak var bgView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView.dropShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
