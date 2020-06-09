import SwiftUI
import CoreData
import Combine

var routines: [NSManagedObject] = []

var colors: [UIColor] = [UIColor.systemBlue, UIColor.systemOrange, UIColor.systemRed]

var reloader = Reloader()

struct ContentView: View {
    
    @State private var routines: [Routine]? = [];
    
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
                List(routines ?? [], id: \.id) { routine in
                    RoutineRow(routine: routine, reload: reloader);
                }
                NavigationLink(destination: FormView(name: "", count: "0")) {
                    Text("+").font(.system(.title, design: .rounded)).padding()
                }.listSeparatorStyleNone()
            }
            .navigationBarTitle(Text("This Week"))
        }.onAppear(perform: {
            self.routines = self.fetchRoutines()
        }).onReceive(reloader.reload) { (reload) in
            self.routines = self.fetchRoutines()
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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                        self.presentationMode.wrappedValue.dismiss();
                        reloader.reloadme()
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

struct Reloader {
      var reload = PassthroughSubject<String,Never>()

      func reloadme() {
        reload.send("reload")
      }
}
