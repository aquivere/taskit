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
    @StateObject var viewRouter: ViewRouter
    let minimal = "Minimal"
    
    var body: some View {
        TabView(selection: $currentTab, content:  {
            // Introduction
            // TO DO: make pretty
            VStack (alignment: .leading) {
                Text("Welcome to the future of organisation")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Text("We made to-do lists simple, so you can focus on finishing them.")
                    .font(.body)
                    .padding()
            }.tag(0)
            
            // SECOND VIEW = SCREENSHOT OF LISTVIEW WHICH IS ANNOTATED (e.g. the + button is circled, and is labeled "add new tasks here" e.g.) <- can only do once we finish list view completely
            VStack (alignment: .leading) {
                Text("To change views:")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Group {
                    Text("Long press on ") + Text("daily view ").fontWeight(.bold) + Text("to select weekly, fortnightly and monthly tasks")
                        
                }
                    .font(.body)
                    .padding()
                
                    
            }
                .tag(1)
            
            // TO DO: make pretty, espeically the next button appearing out of nowhere
            // TO DO: navigation link no work
            // Get user name and save it
            VStack (alignment: .center) {
                Text("What is your name?")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .frame(height: 50)
                            
                TextField("Enter name", text: $userSettings.name)
                    .textFieldStyle(PlainTextFieldStyle())
                    .keyboardType(.alphabet)
                    .frame(width: 300, height: 50, alignment: .center)
                
                if !userSettings.name.isEmpty {
                    
                    
                    Button (action: {
                        userSettings.isSetUp = true
                        //change views after clicking button.
                        viewRouter.currentPage = .page1
                    }, label: {
                        Text("Next")
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                            .foregroundColor(Color(minimal))
                            .padding()
                    })
                }
            }
        })
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(viewRouter: ViewRouter())
    }
}
