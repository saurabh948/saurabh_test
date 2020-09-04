
import UIKit

final class DiaryListViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var diaryListTableView: UITableView!
    
    //MARK: - Variables
    private var viewModel           = DiaryListViewModel()
    private lazy var viewNavigator  = DiaryListNavigator(self)
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAPICall()
        viewModel.getDiaryList()
    }
}

//MARK: - API Call Handler
extension DiaryListViewController {
    private func prepareAPICall() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            
            guard let `self` = self else {
                return
            }
            
            switch state {
            case .loading:
                self.startLoading()
                
            case .failure(let error):
                self.stopLoading()
                
                switch error {
                case .noInternet:
                    self.showAlert(title: "Network error", message: "Unable to contact the server")
                    
                default:
                    self.showAlert(title: "Error occurred", message: "Failed to retrieve data from server")
                }
            case .success:
                self.stopLoading()
                
            case .finish:
                print("Finish")
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - TableView Delegate and DataSource
extension DiaryListViewController {
    private func handleTableData() {
        viewModel.diaryList.bind(to: diaryListTableView.rx.items){ (tableView, row, item) -> UITableViewCell in
            let cell = tableView.registerAndGet(cell: DiaryListTableViewCell.self)!
            return cell
        }.disposed(by: disposeBag)
        
        //DidSelect
        diaryListTableView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (indexPath) in
            guard let self = `self` else {
                return
            }
            let num = self.viewModel.diaryList.value[indexPath.row]
            print(num)
        }).disposed(by: self.disposeBag)
    }
}

