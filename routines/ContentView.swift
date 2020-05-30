//
//  ContentView.swift
//  routines
//
//  Created by V on 5/29/20.
//  Copyright © 2020 V. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var milestones = [Milestone(id: 0, name: "Interviews", progress: 0.5),  Milestone(id: 0, name: "Arts", progress: 0.8)]
    var body: some View {
        NavigationView {
            VStack {
                List(milestones) { milestone in
                    MilestoneRow(milestone: milestone)
                }
                NavigationLink(destination: ResultView()) {
                    Text("+")
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

struct ResultView: View {
    var body: some View {
        Text("Hello Form")
    }
}
