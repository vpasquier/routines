import SwiftUI
import CoreData

struct RoutineRow: View {
    
    var routine: Routine
    var colors: [UIColor] = [UIColor.systemBlue, UIColor.systemOrange, UIColor.systemRed, UIColor.systemPink, UIColor.systemGreen, UIColor.systemPurple, UIColor.systemYellow]
    
    var body: some View {
        ProgressBar(name: self.routine.name!, count: self.routine.count, done: self.routine.done, save: self.save, delete: self.delete, color: colors.randomElement() ?? UIColor.systemBlue).frame(height: 70)
    }
    
    func save(done: Int64) {
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            self.routine.setValue(done, forKey: "done")
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete() {
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(self.routine)
            try managedContext.save()
            Global.reloader.reloadme()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

struct ProgressBar: View {
    var name: String
    var count: Int64
    @State var done: Int64 = 0
    var save: (_ done: Int64)  -> Void
    var delete: ()  -> Void
    var color: UIColor = UIColor.systemBlue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(self.color))
                Rectangle().frame(width: min(CGFloat(CGFloat(self.done)/CGFloat(self.count))*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(self.color))
                    .animation(.linear)
                HStack {
                    Spacer()
                    Text("-").font(.system(.title, design: .rounded)).padding().onTapGesture {
                        if(self.done == 0){
                            return;
                        }
                        self.done -= 1
                        self.save(self.done)
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                    Spacer()
                    VStack {
                        Text("\(self.name)").font(.system(.title, design: .rounded))
                        Text("\(self.done)/\(self.count)").font(.system(.caption, design: .rounded))
                    }.contextMenu {
                        Button(action: {
                            self.delete()
                        }) {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                    Spacer()
                    Text("+").font(.system(.title, design: .rounded)).padding().onTapGesture {
                        if(self.done == self.count) {
                            return;
                        }
                        self.done += 1
                        self.save(self.done)
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                    Spacer()
                }
            }
        }.cornerRadius(10.0)
    }
}
