
import Foundation

enum DiaryType {
    case today
    case yesterday
    case old(_ month: String)
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .old(let month):
            return month
        }
    }
}

struct DiaryGroup {
    var type : DiaryType
    var diaryList = [DiaryData]()
}
