//
//  SplashView.swift
//  ToDoList
//
//  Created by Vivian Wang on 6/9/21.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    @State var isActive:Bool = false
    
    var body: some View {
        VStack {
      
            if self.isActive {

                MotherView(viewRouter: ViewRouter())
                    .environmentObject(listViewModel)
            } else {
  
                Text("Awesome Splash Screen!")
                    .font(Font.largeTitle)
            }
        }
        
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}
