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
@main
struct ToDoListApp: App {
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    @ObservedObject var userSettings = UserModel()
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            if userSettings.isSetUp == false {
                NavigationView {
                    TutorialView(viewRouter: ViewRouter())
                    NotificationListView()
                }.environmentObject(listViewModel)
            } else {
                MotherView(viewRouter: ViewRouter())
                    .environmentObject(listViewModel)
            }
            // TO DO: SOMEHOW INTEGRATE THE NOTIFICATIONLISTVIEW INTO THE MOTHERVIEW SO THAT NOTIFICATIONS CAN RUN. 
        }
    }
}
