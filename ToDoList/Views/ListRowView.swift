//
//  ListRowView.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct ListRowView: View {
    @State private var pressed = false
    let item: ItemModel
    @EnvironmentObject var listViewModel: ListViewModel
    let SecondaryAccentColor = Color("Color")
    let regularListColor = Color("Minimal")
    @State var checkMark: Bool = false
    let background = Color("background")
    
    var body: some View {
        
        HStack {
            if (item.recurrence == "Do not repeat") {
                // if regular list
                Image(systemName: self.pressed ? "checkmark.square.fill"  : "square")
                    .foregroundColor(Color("AccentColor"))
                    .padding(.leading, 10)
                    .opacity(self.pressed ? 0 : 1.0)
                    .onTapGesture {
                        // delete the task when completed
                        withAnimation(.easeInOut(duration: 1)) {
                            self.pressed.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.pressed.toggle()
                            listViewModel.updateItem(item: item)
                        }
                    }
                
                Text(item.title)
                    .fontWeight(.semibold)
                    .textCase(.lowercase)
                    .padding(.vertical, 3)
                    .padding(.leading, 5)
                    .frame(alignment: .leading)
                    .opacity(self.pressed ? 0 : 1.0)
                    .onTapGesture {
                        // delete the task when completed
                        withAnimation(.easeInOut(duration: 1)) {
                            self.pressed.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.pressed.toggle()
                            listViewModel.updateItem(item: item)
                        }
                    }
                    
           } else {
                // if recurring list
            Image(systemName: self.pressed ? "checkmark.square.fill"  : "square")
                    .foregroundColor(Color("AccentColor"))
                    .padding(.leading, 10)
                    .opacity(self.pressed ? 0 : 1.0)
                    .onTapGesture {
                        // complete the task when tapped, don't delete as it will refresh
                        withAnimation(.easeInOut(duration: 1)) {
                            self.pressed.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.pressed.toggle()
                            listViewModel.updateRecItem(recItem: item)
                        }
                    }
                Text(item.title)
                    .fontWeight(.semibold)
                    .textCase(.lowercase)
                    .padding(.vertical, 3)
                    .padding(.leading, 5)
                    .frame(alignment: .leading)
                    .opacity(self.pressed ? 0 : 1.0)
                    .onTapGesture {
                        // complete the task when tapped, don't delete as it will refresh 
                        withAnimation(.easeInOut(duration: 1)) {
                            self.pressed.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.pressed.toggle()
                            listViewModel.updateRecItem(recItem: item)
                        }
                    }
            }
            Spacer()
        }
        .font(.body)
        .padding(.vertical, 8)
        .padding(.trailing, 15)
    }
    
}



struct ListRowView_Previews: PreviewProvider {
    
    let item: ListViewModel
    let item2: ItemModel
    
    static var item1 = ItemModel(title: "First Item!", isCompleted: false, dateCompleted: "04/03/2021", date: Date().addingTimeInterval(-5000), recurrence: "")
    static var item2 = ItemModel(title: "Second Item.", isCompleted: true, dateCompleted: "03/08/2021", date: Date().addingTimeInterval(5000), recurrence: "Every Week")
    static var previews: some View {
        Group {
            ListRowView(item: item1)
                .preferredColorScheme(.dark)
            ListRowView(item: item1)
                .preferredColorScheme(.dark)
            ListRowView(item: item2)
        }
        .previewLayout(.sizeThatFits)
    }
}


