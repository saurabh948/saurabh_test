
import Foundation
import CoreData

struct DiaryData: Codable {
    let id      : String?
    let title   : String?
    let content : String?
    let dateStr : String?
    var date    : Date?
    
    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case title      = "title"
        case content    = "content"
        case dateStr    = "date"
    }
    
    init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        id      = try values.decodeIfPresent(String.self, forKey: .id)
        title   = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        dateStr = try values.decodeIfPresent(String.self, forKey: .dateStr)
        
        if let dateString = dateStr {
            date = DateManager.dateStyleServerDate.date(from: dateString)
        }
    }
    
    init(data: NSManagedObject) {
        id      = data.value(forKey: "id") as? String
        title   = data.value(forKey: "title") as? String
        content = data.value(forKey: "content") as? String
        dateStr = data.value(forKey: "dateStr") as? String
        
        if let dateString = dateStr {
            date = DateManager.dateStyleServerDate.date(from: dateString)
        }
    }
}
