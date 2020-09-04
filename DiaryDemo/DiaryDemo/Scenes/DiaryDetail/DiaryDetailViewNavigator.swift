
import Foundation

final class DiaryDetailViewNavigator {
    //MARK: - Variables
    private let viewController: DiaryDetailViewController
    
    ///`Setup`
    init(_ viewController: DiaryDetailViewController) {
        self.viewController = viewController
    }
    
    func moveBack() {
        viewController.navigationController?.popViewController(animated: false)
    }
}
