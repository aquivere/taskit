//
//  NoItemsView.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
//

import SwiftUI

struct NoItemsView: View {
    @State var animate: Bool = false
    
    let SecondaryAccentColor = Color("Color")
    
    var body: some View {
        ScrollView {
            
            VStack (spacing: 10) {
                Text("There are no items!")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Add to start!")
                    .padding(.bottom, 20)
                
                NavigationLink(
                    destination: AddView(),
                    label: {
                        Text("Add To-Do ✏️")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(height:55)
                            .frame(maxWidth: .infinity)
                            .background(animate ? SecondaryAccentColor: Color.accentColor)
                            .cornerRadius(20)
                    })
                    .padding(.horizontal, animate ? 30: 50)
                    .shadow(
                        color: animate ? SecondaryAccentColor.opacity(0.7) :
                            Color.accentColor.opacity(0.7),
                        radius: animate ? 30:10,
                        x: 0,
                        y: animate ? 50:30)
                    .scaleEffect(animate ? 1.1: 1.0)
                    .offset(y:animate ? -7: 0)
                
            }
            .frame(maxWidth: 400)
            .padding(40)
            .multilineTextAlignment(.center)
            .onAppear (perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func addAnimation() {
        guard !animate else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            
            ) {
                animate.toggle()
            }
        }
    }
    
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoItemsView()
                .navigationTitle("Title")
        }
        
    }
}
