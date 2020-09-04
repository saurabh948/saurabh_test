
import UIKit

class DiaryDetailViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var titleTextField   : UITextField!
    @IBOutlet private weak var contentTextView  : UITextView!
    @IBOutlet private weak var saveButton       : UIButton!
    
    //MARK: - Variables
    private var viewModel           = DiaryDetailViewModel()
    private lazy var viewNavigator  = DiaryDetailViewNavigator(self)
    
    var diaryData: DiaryData?
    
    //MARK: - Callback
    var shouldRefresh:((Bool) -> Void)?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareActionMethods()
    }
    
    //MARK: - Helper Methods
    private func prepareView() {
        if let diaryObj = diaryData {
            titleTextField.text = diaryObj.title
            contentTextView.text = diaryObj.content
        }
        titleTextField.rx.text.orEmpty.bind(to: viewModel.title).disposed(by: disposeBag)
        contentTextView.rx.text.orEmpty.bind(to: viewModel.detail).disposed(by: disposeBag)
        prepareTextFieldDelegate()
    }
}

//MARK: - Action Methods
extension DiaryDetailViewController {
    private func prepareActionMethods() {
        saveButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            if let id  = self.diaryData?.id {
                if self.titleTextField.text?.trimmed.isEmpty ?? true || self.contentTextView.text.trimmed.isEmpty {
                    self.showAlert(title: "Data Required", message: "Please enter detail to save.")
                    return
                }
                self.viewModel.saveData(for: id)
                self.shouldRefresh?(true)
                self.viewNavigator.moveBack()
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - TextField Delegate
extension DiaryDetailViewController {
    private func prepareTextFieldDelegate() {
        titleTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.contentTextView.resignFirstResponder()
        }).disposed(by: self.disposeBag)
    }
}
