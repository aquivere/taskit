//
//  TutorialView.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
//

import SwiftUI

struct TutorialView: View {
    @State private var currentTab = 0
    @ObservedObject var userSettings = UserModel()
    
    @EnvironmentObject var appState: AppState
    
    let minimal = "Minimal"
    
    var body: some View {
        TabView(selection: $currentTab, content:  {
            // Introduction
            VStack (alignment: .leading) {
                Text("Welcome to the future of organisation")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Text("We made to-do lists simple, so you can focus on finishing them.")
                    .font(.body)
                    .padding()
            }.tag(0)

            VStack (alignment: .leading) {
                Text("To change views:")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Group {
                    Text("Long press on ") + Text("this week ").fontWeight(.bold) + Text("to select fortnightly and monthly tasks")
                        
                }
                    .font(.body)
                    .padding()
                
                    
            }
                .tag(1)
            
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
                        appState.hasOnboarded = true
                        
                        
                    }, label: {
                        Text("Next")
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                            .foregroundColor(Color(minimal))
                            .padding()
                    })
                }
            }.tag(2)
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
