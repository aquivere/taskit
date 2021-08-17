//
//  ListRowView.swift
//  ToDoList
//
//  Created by Borborick Zhu on 8/7/21.
//

import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    @EnvironmentObject var listViewModel: ListViewModel
    
    let SecondaryAccentColor = Color("Color")
    
    @State var checkMark: Bool = false
    
    var body: some View {
        
        HStack{
            
//            Button(action: updateModel, label: {
//                if item.isCompleted == true || checkMark == true {
//                    Image(systemName: "circle.fill")
//
//
//                } else {
//                    Image(systemName: "circle")
//
//                }
//
//            })
//            .foregroundColor(item.isCompleted ? Color.accentColor: Color.accentColor)
//            .padding(.leading, 10)
            
            Image(systemName: item.isCompleted ? "circle.fill"  : "circle")
                .animation(Animation.default.delay(2))
                .foregroundColor(item.isCompleted ? Color.accentColor: Color.accentColor)
                .padding(.leading, 10)

            if item.isCompleted == true {
                Text(item.title)
                    .strikethrough()
                    .padding(.vertical, 2)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                
            } else {
                Text(item.title)
                    .padding(.vertical, 2)
                    .frame(alignment: .leading)
            }
            
            
            Spacer()
            if item.date < Date() {
                Text(item.dateCompleted)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .font(.caption)
                    .fontWeight(.semibold)
                
            }
            else {
                Text(item.dateCompleted)
                    .foregroundColor(Color.accentColor)
                    .font(.caption)
                    .fontWeight(.semibold)
                    
            }

        }.font(.title2)
        .padding(.vertical, 8)
        .padding(.trailing, 15)
    }
    func updateModel() {
        listViewModel.updateItem(item: item)
        withAnimation(.default) {
            checkMark.toggle()
        }
        
    }
}

struct ListRowView_Previews: PreviewProvider {
    
    let item: ListViewModel
    let item2: ItemModel
    
    static var item1 = ItemModel(title: "First Item!", isCompleted: false, dateCompleted: "04/03/2021", date: Date().addingTimeInterval(-5000))
    static var item2 = ItemModel(title: "Second Item.", isCompleted: true, dateCompleted: "03/08/2021", date: Date().addingTimeInterval(5000))
    static var previews: some View {
        Group {
            ListRowView(item: item1)
                .preferredColorScheme(.dark)
            ListRowView(item: item2)
        }
        .previewLayout(.sizeThatFits)
    }
}
