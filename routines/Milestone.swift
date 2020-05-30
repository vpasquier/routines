import SwiftUI
import CoreLocation

struct Milestone: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var progress: Float
}
