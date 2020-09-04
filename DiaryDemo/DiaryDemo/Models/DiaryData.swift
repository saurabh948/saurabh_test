
import Foundation

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
}

/*
 {
     "id": "1",
     "title": "Watch moive",
     "content": "Today i watch a moive,and very happy",
     "date": "2020-05-28T00:03:22.303Z"
 }
 */
