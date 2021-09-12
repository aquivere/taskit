//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Borborick Zhu on 8/7/21.
//

import SwiftUI

/*
 MVVM architecture
 
 Model - data point
 View - UI of our app.
 View Model - class that manages the models or the data for the view. 
 */

//Define observable
class AppState: ObservableObject {
    @Published var hasOnboarded: Bool {
        didSet {
            UserDefaults.standard.set(hasOnboarded, forKey: "hasOnboarded")
        }
    }

    init(hasOnboarded: Bool) {
        self.hasOnboarded = hasOnboarded
    }
}

@main
struct ToDoListApp: App {
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    @ObservedObject var userSettings = UserModel()
    @ObservedObject var appState = AppState(hasOnboarded: false)    
    var body: some Scene {
        WindowGroup {
            if appState.hasOnboarded == false && userSettings.isSetUp == false  {
                TutorialView()
                    .environmentObject(appState)
                    .environmentObject(listViewModel)
            } else {
                ListView()
                    .environmentObject(appState)
                    .environmentObject(listViewModel)
            }
        }
    }
}
