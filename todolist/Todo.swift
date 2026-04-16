import SwiftData
import Foundation

@Model
class Todo {
    var title: String
    var isCompleted: Bool
    var createdAt: Date

    init(title: String) {
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
    }
}


