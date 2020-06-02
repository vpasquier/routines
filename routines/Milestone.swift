import SwiftUI
import CoreLocation

struct Milestone: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var topics: Set<Topic>
    
    func getScore() -> Float {
        return Float(topics.count / 100);
    }
}


