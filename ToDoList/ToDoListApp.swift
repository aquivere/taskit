//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
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
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            if appState.hasOnboarded == false && userSettings.isSetUp == false  {
                TutorialView()
                    .environmentObject(appState)
                    .environmentObject(listViewModel)
                    .modifier(DarkModeViewModifier())
            } else {
                ListView()
                    .environmentObject(appState)
                    .environmentObject(listViewModel)
                    .modifier(DarkModeViewModifier())
            }
        }
    }
}
