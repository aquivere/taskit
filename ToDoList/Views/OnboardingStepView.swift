//
//  OnboardingStep.swift
//  ToDoList
//
//  Created by Brianna Kim on 21/8/21.
//
//  Sets up app and takes the user through a tutorial
import SwiftUI

struct OnboardingStepView: View {
    var body: some View {
        VStack (alignment: .center) {
            // TO DO: add background + figure out align
            Text("Welcome to the future of organisation")
                .fontWeight(.bold)
                .font(.title)
            Text("We made to-do lists simple, so you can focus on finishing them")
                .font(.body)
                .padding()
            
            // User taps screen
            // Takes user through tutorial and set-up
            NavigationLink(
                destination: TutorialView(),
                label: {
                    Text("Get started")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.horizontal)
                }
            )
                
        }
                
    }
}
    
struct OnboardingStepView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStepView()
    }
}
