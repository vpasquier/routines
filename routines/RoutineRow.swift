import SwiftUI

struct RoutineRow: View {
    var routine: Routine
    
    var body: some View {
        ProgressBar(name: routine.name!, count: routine.count, done: routine.done).frame(height: 70)
    }
}

struct ProgressBar: View {
    var name: String
    var count: Int64
    @State var done: Int64
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                Rectangle().frame(width: min(CGFloat(self.done/self.count)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
                HStack {
                    Spacer()
                    Button(action: {
                        if(self.done == 0){
                            return;
                        }
                        self.done -= 1
                    }) {
                        Text("-").font(.system(.title, design: .rounded)).padding()
                    }
                    Spacer()
                    VStack {
                        Text("\(self.name)").font(.system(.title, design: .rounded))
                        Text("\(self.done)/\(self.count)").font(.system(.caption, design: .rounded))
                    }
                    Spacer()
                    Button(action: {
                        if(self.done == self.count) {
                            return;
                        }
                        self.done += 1
                    }) {
                        Text("+").font(.system(.title, design: .rounded)).padding()
                    }
                    Spacer()
                }
            }.cornerRadius(25.0)
        }
    }
}
