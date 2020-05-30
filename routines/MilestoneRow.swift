import SwiftUI

struct MilestoneRow: View {
    var milestone: Milestone
    
    var body: some View {
        ProgressBar(name: milestone.name, progress: milestone.progress).frame(height: 70)
    }
}

struct ProgressBar: View {
    var name: String
    var progress: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                Rectangle().frame(width: min(CGFloat(self.progress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
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
