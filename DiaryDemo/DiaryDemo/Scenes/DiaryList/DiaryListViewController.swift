
import UIKit

class DiaryListViewController: BaseViewController {
    
    //MARK: - Variables
    private var viewModel           = DiaryListViewModel()
    private lazy var viewNavigator  = DiaryListNavigator(self)

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDiaryList()
    }


}
