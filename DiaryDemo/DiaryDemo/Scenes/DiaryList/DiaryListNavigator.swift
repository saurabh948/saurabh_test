
import Foundation

final class DiaryListNavigator {
    //MARK: - Variables
    private let viewController: DiaryListViewController
    
    ///`Setup`
    init(_ viewController: DiaryListViewController) {
        self.viewController = viewController
    }
    func moveToCreateAcccont(with data: DiaryData) {
        viewController.performSegue(withIdentifier: "pushDetailVc", sender: data)
    }
}
