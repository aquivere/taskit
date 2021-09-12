//
//  RecurringView.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
//

import SwiftUI
import Foundation

struct RecurringView: View {
    
    @Binding var recurrenceTitle: String
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var options = [
        "Do not repeat",
        "Every Day",
        "Every Week",
        "Every Fortnight",
        "Every Month",
    ]
    
    var body: some View {
        List {
            Button(action: {
                recurrenceTitle = "Do not repeat"
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Do not repeat".uppercased())
                    //.foregroundColor(.white)
                    .font(.headline)
                    .frame(height:40)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(0)
            })
//            Button(action: {
//                recurrenceTitle = "Every Day"
//                presentationMode.wrappedValue.dismiss()
//            }, label: {
//                Text("Repeat Every Day".uppercased())
//                    //.foregroundColor(.white)
//                    .font(.headline)
//                    .frame(height:40)
//                    .frame(maxWidth: .infinity)
//                    .cornerRadius(0)
//            })
            Button(action: {
                recurrenceTitle = "Every Week"
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Repeat Every Week".uppercased())
                    //.foregroundColor(.white)
                    .font(.headline)
                    .frame(height:40)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(0)
            })
            Button(action: {
                recurrenceTitle = "Every Fortnight"
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Repeat Every Fortnight".uppercased())
                    //.foregroundColor(.white)
                    .font(.headline)
                    .frame(height:40)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(0)
            })
            Button(action: {
                recurrenceTitle = "Every Month"
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Repeat Every Month".uppercased())
                    //.foregroundColor(.white)
                    .font(.headline)
                    .frame(height:40)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(0)
            })
        }.padding(14)
        .listStyle(PlainListStyle())
        .navigationTitle("Recurrence")
    }
}

class recurrenceData: ObservableObject {
    @Published var title: String
    @Published var time: Int
    
    init(title: String, time: Int) {
        self.title = title
        self.time = time
    }
}
    

