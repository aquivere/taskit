//
//  SetUpView.swift
//  ToDoList
//
//  Created by Brianna Kim on 22/8/21.
//  Asks for users name and saves this
import SwiftUI

struct SetUpView: View {
    @ObservedObject var userSettings = UserModel()
    
    var body: some View {
        // TO DO: add background
        
        VStack (alignment: .center) {
            Text("What is your name?")
                .frame(height: 50)
            
            TextField("Enter name", text: $userSettings.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.alphabet)
                .frame(width: 300, height: 50, alignment: .center)
            
            
            NavigationLink(destination: ListView()) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.purple)
                    .clipShape(Capsule())
            }
        }
        
    }
        
}

struct SetUpView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpView()
    }
}
