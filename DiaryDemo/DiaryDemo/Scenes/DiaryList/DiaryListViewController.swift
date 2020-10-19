
import UIKit
import AppCenter
import AppCenterCrashes

final class DiaryListViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var diaryListTableView   : UITableView!
    @IBOutlet private weak var noDataView           : UIView!
    @IBOutlet private weak var fetchDataButton      : UIButton!
    
    //MARK: - Variables
    private lazy var viewModel      = DiaryListViewModel(self)
    private lazy var viewNavigator  = DiaryListNavigator(self)
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MSAppCenter.start("0292e315-4c5c-44cc-b645-a08a3c53b8a4", withServices:[
            MSCrashes.self
        ])
        handleTableData()
        prepareAPICall()
        viewModel.fetchDataFromDB()
    }
    
    //MARK: - Helper Methods
    func addNodataView() {
        diaryListTableView.tableHeaderView = noDataView
        fetchDataButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.viewModel.fetchDataFromDB()
        }).disposed(by: disposeBag)
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
                DispatchQueue.main.async {
                    switch error {
                    case .noInternet:
                        self.showAlert(title: "Network error", message: "Unable to contact the server")
                        
                    default:
                        self.showAlert(title: "Error occurred", message: "Failed to retrieve data from server")
                    }
                }
            case .success:
                DispatchQueue.main.async {
                    self.diaryListTableView.tableHeaderView = nil
                }
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
        viewModel.formatedDiaryList.bind(to: diaryListTableView.rx.items){ (tableView, row, item) -> UITableViewCell in
            let cell = tableView.registerAndGet(cell: DiaryListTableViewCell.self)!
            cell.diaryDataObj = item
            cell.editTap = { id in
                if let obj = self.viewModel.diaryList.first(where: {$0.id == id}) {
                    self.viewNavigator.moveToCreateAcccont(with : obj)
                }
            }
            cell.deleteTap = { id in
                self.viewModel.deleteDiary(for: id)
            }
            return cell
        }.disposed(by: disposeBag)
    }
}

//MARK: - Navigation
extension DiaryListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushDetailVc" {
            if let detailVc = segue.destination as? DiaryDetailViewController,
                let diaryData = sender as? DiaryData {
                detailVc.diaryData = diaryData
                detailVc.shouldRefresh = { result in
                    if result {
                        self.viewModel.fetchDataFromDB()
                    }
                }
            }
        }
    }
}
