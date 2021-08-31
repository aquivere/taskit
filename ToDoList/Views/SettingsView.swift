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
        // NEED TO FIGURE out how to put in the title "settings"
            
        Form {
            Section(header: Text("Profile")) {
                // TO DO: figure out to open a ext window to edit name
                Text("Name: ")
                
                // FIGURE OUT WHY TEXT ISNT WORKING
                // TextField("New name", text: $userSettings.name)
            }
            
            Section(header: Text("Display")) {
                
                Toggle("Dark Mode", isOn: $userSettings.isDarkMode)
                if userSettings.isDarkMode {
                    // TO DO: how to actually switch colorway (probably have to save colour palette in assets, then use a binding variable or smth to denote change across all the views)
                }
                
                Picker(selection: $userSettings.selectedView, label: Text("View")) {
                    ForEach(userSettings.views, id: \.self) {selectedView in
                        Text(selectedView)
                    }
                }
            }
            // TO DO: about the app section
        }
            
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
    
}
