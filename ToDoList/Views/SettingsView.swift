//
//  SettingsView.swift
//  ToDoList
//
//  Created by Brianna Kim on 23/8/21.
//



import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserModel()
    
    @State var nameInEditMode = false
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                HStack {
                    if nameInEditMode {
                        TextField("Name", text: $userSettings.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading, 5)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    } else {
                        Text("\(userSettings.name)")
                    }
                    
                    Spacer()

                    Button(action: {
                        self.nameInEditMode.toggle()
                    }) {
                        Text(nameInEditMode ? "Done" : "Edit")
                            .foregroundColor(Color("AccentColor"))
                    }
                }

            }
            
            Section(header: Text("Display")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
        .modifier(DarkModeViewModifier())
            
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
