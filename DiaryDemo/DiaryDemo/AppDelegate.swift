
import UIKit
import SVProgressHUD
import CoreData
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpLibraryData()
        setUpNavBar()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        MSAppCenter.start("0292e315-4c5c-44cc-b645-a08a3c53b8a4", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        return true
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func setUpNavBar() {
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for:UIBarMetrics.default)
    }
}

//MARK: - Library Setup
extension AppDelegate {
    /// All External Library setup will be done here
    private func setUpLibraryData() {
        SVProgressHUD.setDefaultMaskType(.black)
    }
}
