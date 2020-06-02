import SwiftUI

struct RoutineRow: View {
    var routine: Routine
    
    var body: some View {
        ProgressBar(name: routine.name, count: routine.count, done: routine.done).frame(height: 70)
    }
}

struct ProgressBar: View {
    var name: String
    var count: String
    var done: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                Rectangle().frame(width: min(CGFloat(Double(self.done)!)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
                HStack {
                    Spacer()
                    VStack {
                        Text("\(self.name)").font(.system(.title, design: .rounded))
                        Text("2/4").font(.system(.caption, design: .rounded))
                    }
                    Spacer()
                    Text("+").font(.system(.title, design: .rounded))
                    Spacer()
                    Text("-").font(.system(.title, design: .rounded))
                }
            }.cornerRadius(25.0)
        }
    }
}
