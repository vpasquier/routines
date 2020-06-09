import SwiftUI
import CoreData
import Combine

var routines: [NSManagedObject] = []

var colors: [UIColor] = [UIColor.systemBlue, UIColor.systemOrange, UIColor.systemRed]

struct Global {
    static var reloader = Reloader()
}

struct ContentView: View {
    
    @State private var totalCount: String = "";
    
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
        var totalCount : Int64 = 0;
        var totalDone : Int64 = 0;
        for routine in routines ?? [] {
            totalCount += routine.count;
            totalDone += routine.done;
        }
        self.totalCount = "\(totalDone) / \(totalCount)"
        return routines;
    }
    var body: some View {
        NavigationView {
            VStack {
                List(routines ?? [], id: \.id) { routine in
                    RoutineRow(routine: routine);
                }
                NavigationLink(destination: FormView(name: "", count: "")) {
                    Text("+").font(.system(.title, design: .rounded)).padding()
                }.listSeparatorStyleNone()
            }
            .navigationBarTitle(Text("This Week - \(self.totalCount)"))
        }.onAppear(perform: {
            self.routines = self.fetchRoutines()
        }).onReceive(Global.reloader.reload) { (reload) in
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
    @State public var count: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Number per week", text: $count).keyboardType(.numberPad)
                }
                Section {
                    Button(action: {
                        if(self.name.isEmpty || self.count.isEmpty || Int(self.count) ?? 0 <= 0){
                            self.showingAlert = true
                        }else{
                            self.save(name: self.name, count: self.count);
                            self.presentationMode.wrappedValue.dismiss();
                            Global.reloader.reloadme()
                        }
                    }) {
                        Text("Save")
                    }
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss();
                    }) {
                        Text("Cancel")
                    }
                }
            }
            .navigationBarTitle(Text("New routine"))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Form Errors"), message: Text("Name and number should not be empty"), dismissButton: .default(Text("Got it!")))
            }
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
