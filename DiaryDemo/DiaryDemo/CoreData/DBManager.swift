
import UIKit
import CoreData

final class Application {
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

enum DataEntity: String {
    case diaryData = "DiaryDataModel"
}

class DBManager {
    
    // MARK: - ManagedContext
    private let managedContext = Application.shared.persistentContainer.viewContext
    
    // MARK: - Get Instance
    static let shared = DBManager()
    
    // MARK: - Save Data
    func AddDiaryData(diaryData: DiaryData) {
        let entityDesc = NSEntityDescription.entity(forEntityName: DataEntity.diaryData.rawValue, in: self.managedContext)
        let object = NSManagedObject(entity: entityDesc!, insertInto: self.managedContext);
        object.setValue(diaryData.title ?? "", forKey: "title")
        object.setValue(diaryData.id ?? "", forKey: "id")
        object.setValue(diaryData.content ?? "", forKey: "content")
        object.setValue(diaryData.dateStr ?? "", forKey: "dateStr")
        saveData()
    }
    
    // MARK: - Save Data
    func saveData() {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Fetch Query
    func fetchQuery(entity: String, completionSuccess: (_ response: [NSManagedObject]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            completionSuccess(result as! [NSManagedObject])
        } catch let error as NSError {
            print("Failed fetchSettingsResult error :- \(error.localizedDescription)")
        }
    }
    
    private func getEntityFetchRequest(forEntityName: String, predicateKey: String) -> NSFetchRequest<NSFetchRequestResult> {
        let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: managedContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        return request
    }
    
    //MARK: - Update Data
    func updateData(for id:String, title: String, content: String) {
        let Request = self.getEntityFetchRequest(forEntityName: DataEntity.diaryData.rawValue, predicateKey: "fileName");
        Request.predicate = NSPredicate(format: "id == %@", id)
        guard let fetchedResults = try? managedContext.fetch(Request) as? [NSManagedObject] else { return  }
        if let fetchedObj = fetchedResults.first {
            let date = DateManager.dateStyleServerDate.string(from: Date())
            fetchedObj.setValue(title, forKey: "title")
            fetchedObj.setValue(content, forKey: "content")
            fetchedObj.setValue(date, forKey: "dateStr")
        }
        self.saveData()
    }
    
    //MARK: - Delete Data
    func deleteDiaryById(for id: String){
        let Request = self.getEntityFetchRequest(forEntityName: DataEntity.diaryData.rawValue, predicateKey: "fileName");
        Request.predicate = NSPredicate(format: "id == %@", id)
        guard let fetchedResults = try? managedContext.fetch(Request) as? [NSManagedObject] else { return  }
        for asset in fetchedResults {
            managedContext.delete(asset)
        }
        self.saveData()
    }
    
    func deleteEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            saveData()
        } catch {
            print ("There was an error deleting DB :- \(entity)")
        }
    }
}
