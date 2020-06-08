import SwiftUI
import CoreData

var routines: [NSManagedObject] = []

struct ContentView: View {
    //    var routines = [Routine(name: "Interviews", count: "3", done: "0"),  Routine(name: "Arts", count: "2", done: "1")]
    func fetchRoutines() -> [Routine]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Routine>(entityName: "Routine")
        var routines: [Routine]? = []
        do {
            routines = try managedContext.fetch(fetchRequest)
        } catch{
            print(error)
        }
        return routines;
    }
    var body: some View {
        NavigationView {
            VStack {
                List(fetchRoutines() ?? [], id: \.id) { routine in
                    RoutineRow(routine: routine)
                }
                NavigationLink(destination: FormView(name: "", count: "0")) {
                    Text("+")
                }.listSeparatorStyleNone()
                NavigationLink(destination: TodayView()) {
                    Text("Today Tasks")
                }.listSeparatorStyleNone()
            }
            .navigationBarTitle(Text("This Week"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public struct ListSeparatorStyleNoneModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
        }.onDisappear {
            UITableView.appearance().separatorStyle = .none
        }
    }
}

extension View {
    public func listSeparatorStyleNone() -> some View {
        modifier(ListSeparatorStyleNoneModifier())
    }
}

struct FormView: View {
    
    @State public var name: String = ""
    @State public var count: String = "0"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routine")) {
                    TextField("Name:", text: $name)
                    TextField("Count:", text: $count).keyboardType(.numberPad)
                }
                Section {
                    Button(action: {
                        self.save(name: self.name, count: self.count);
                    }) {
                        Text("Save")
                    }
                }
            }
            .navigationBarTitle(Text("New habits"))
        }
    }
    func save(name: String, count: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Routine", in: managedContext)!
        let routineEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        routineEntity.setValue(name, forKeyPath: "name")
        routineEntity.setValue(Int(count), forKeyPath: "count")
        routineEntity.setValue(UUID(), forKeyPath: "id")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

struct TodayView: View {
    var body: some View {
        Text("Hello Form")
    }
}
