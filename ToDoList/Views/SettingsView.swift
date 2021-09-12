//
//  SettingsView.swift
//  ToDoList
//
//  Created by Brianna Kim on 23/8/21.
//



import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserModel()
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
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
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
        }
            
    }
}

public struct DarkModeViewModifier: ViewModifier {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light) // tint on status bar
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
    
}
