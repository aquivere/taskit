//
//  TutorialView.swift
//  ToDoList
//
//  Created by Brianna Kim on 22/8/21.
//
import SwiftUI


struct ContentView: View {
    @State private var currentTab = 0
   

    var body: some View {
        TabView(selection: $currentTab, content:  {
            Text("First View")
                .tag(0)
            Text("Second View")
                .tag(1)
            Text("Third View")
                .tag(2)
        })
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct TutorialView: View {
    @State private var currentTab = 0
    
        var body: some View {
            TabView(selection: $currentTab, content:  {
                // TO DO: update each subview with tutorial picture
                
                Text("First View")
                    .tag(0)
                Text("Second View")
                    .tag(1)
                Text("Third View")
                    .tag(2)
            })
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
