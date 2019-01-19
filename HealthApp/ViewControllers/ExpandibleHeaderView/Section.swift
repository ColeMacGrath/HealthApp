import Foundation

struct Section {
    var type: String!
    var data: [String]!
    var expanded: Bool!
    
    init(type: String, data: [String], expanded: Bool) {
        self.type = type
        self.data = data
        self.expanded = expanded
    }
}
