import SwiftUI

struct ContentView: View {
    var milestones = [Milestone(name: "Interviews", topics: Set<Topic>()),  Milestone(name: "Arts", topics: Set<Topic>())]
    var body: some View {
        NavigationView {
            VStack {
                List(milestones) { milestone in
                    MilestoneRow(milestone: milestone)
                }
                NavigationLink(destination: FormView(name: "", topics: Array(Set<Topic>()))) {
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
    @State public var topics: Array<Topic> = []
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Category:")) {
                    TextField("Routine category", text: $name)
                }
                Section(header: Text("Routines:")) {
                    List(topics, id: \.topics) { index, topic in
                        HStack {
                            Group {
                                TextField("", text: self.$topic.item[index].name)
                                TextField("", text: self.$topic.item[index].count).keyboardType(.numberPad)
                            }
                        }
                    }
                    Button(action: {
                        //bla
                    }) {
                        Text("-")
                    }
                    Button(action: {
                        //bla
                    }) {
                        Text("+")
                    }
                }
                Section {
                    Button(action: {
                        print("cancel")
                    }) {
                        Text("Cancel")
                    }
                    Button(action: {
                        print("Save")
                    }) {
                        Text("Save")
                    }
                }
            }
            .navigationBarTitle(Text("New habits"))
        }
    }
}

struct TodayView: View {
    var body: some View {
        Text("Hello Form")
    }
}
