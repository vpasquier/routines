import SwiftUI

struct RoutineRow: View {
    var routine: Routine
    
    var body: some View {
        ProgressBar(name: self.routine.name!, count: self.routine.count, done: self.routine.done).frame(height: 70)
    }
}

struct ProgressBar: View {
    var name: String
    var count: Int64
    @State var done: Int64 = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                Rectangle().frame(width: min(CGFloat(CGFloat(self.done)/CGFloat(self.count))*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
                HStack {
                    Spacer()
                    Text("-").font(.system(.title, design: .rounded)).padding().onTapGesture {
                        if(self.done == 0){
                            return;
                        }
                        self.done -= 1
                    }
                    Spacer()
                    VStack {
                        Text("\(self.name)").font(.system(.title, design: .rounded))
                        Text("\(self.done)/\(self.count)").font(.system(.caption, design: .rounded))
                    }
                    Spacer()
                    Text("+").font(.system(.title, design: .rounded)).padding().onTapGesture {
                        if(self.done == self.count) {
                            return;
                        }
                        self.done += 1
                    }
                    Spacer()
                }
            }.cornerRadius(10.0)
        }
    }
}
