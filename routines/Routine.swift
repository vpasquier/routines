import SwiftUI
import CoreData
import CoreLocation

struct Routine: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var count: String
    var done: String
}

class RoutineBuilder: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var count: String
    @NSManaged var done: String

    var routine : Routine {
       get {
        return Routine(name: self.name, count: self.count, done: self.done)
        }
        set {
            self.name = newValue.name
            self.count = newValue.count
            self.done = newValue.done
        }
     }
}
