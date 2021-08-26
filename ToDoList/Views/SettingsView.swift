//
//  SettingsView.swift
//  ToDoList
//
//  Created by Brianna Kim on 23/8/21.
//
import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    // TO DO: figure out to open a ext window to edit name
                    Text("Name: ")
                    
                    // FIGURE OUT WHY TEXT ISNT WORKING
                    // TextField("New name", text: $userSettings.name)
                }
                
                Section(header: Text("Display"), footer: Text("System theme overrides Dark Mode setting")) {
                    Toggle("Dark Mode", isOn: $userSettings.isDarkMode)
                    if userSettings.isDarkMode {
                        
                    }
                    
                    Picker(selection: $userSettings.selectedView, label: Text("View")) {
                        ForEach(userSettings.views, id: \.self) {selectedView in
                            Text(selectedView)
                        }
                    }
                }
                // TO DO: about the app section
            }
            .navigationTitle("Settings")
        }
            
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
    
}
