//
//  TutorialView.swift
//  ToDoList
//
//  Created by Brianna Kim on 22/8/21.
//
import SwiftUI

struct TutorialView: View {
    @State private var currentTab = 0
    @ObservedObject var userSettings = UserModel()
    
    var body: some View {
        TabView(selection: $currentTab, content:  {
            // Introduction
            // TO DO: make pretty
            VStack (alignment: .leading) {
                Text("Welcome to the future of organisation")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Text("We made to-do lists simple, so you can focus on finishing them")
                    .font(.body)
                    .padding()
            }.tag(0)
            
            // SECOND VIEW = SCREENSHOT OF LISTVIEW WHICH IS ANNOTATED (e.g. the + button is circled, and is labeled "add new tasks here" e.g.) <- can only do once we finish list view completely
            Text("Second View")
                .tag(1)
            
            // TO DO: make pretty, espeically the next button appearing out of nowhere
            // TO DO: navigation link no work
            // Get user name and save it
            VStack (alignment: .center) {
                Text("What is your name?")
                    .frame(height: 50)
                            
                TextField("Enter name", text: $userSettings.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.alphabet)
                    .frame(width: 300, height: 50, alignment: .center)
                
                if !userSettings.name.isEmpty {
                    NavigationLink(destination: ListView(viewRouter: ViewRouter()), label: {
                        Text("Next")
                           .foregroundColor(.white)
                           .padding()
                           .frame(width: 300, height: 50)
                           .background(Color.purple)
                           .clipShape(Capsule())
                        }
                    )
                }
            }
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
