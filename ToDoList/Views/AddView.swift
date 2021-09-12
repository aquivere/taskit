//
//  AddView.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
//

import SwiftUI
import Foundation


struct AddView: View {
    // @StateObject private var notificationManager = NotificationManager()
    @State var textFieldText: String = ""
    
    @State private var date = Date()
    
    @State var recurrenceTitle: String  = "Do not repeat"
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                
                TextField("Type something here...", text: $textFieldText)
                    .padding (.horizontal)
                    .frame(height:55)
                    .cornerRadius(10)
                
                Spacer()
                
                VStack {
                    DatePicker("Date", selection : $date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .frame(maxHeight: 400)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(20)
                
                Spacer()
                
                    NavigationLink(
                        destination: RecurringView(recurrenceTitle: $recurrenceTitle),
                        label: {
                            HStack {
                                Text("RECURRENCE:")
                                Spacer()
                                
                                Text(recurrenceTitle.uppercased())
                            }
                            
                        })
                        .padding()
                        .font(.headline)

                        .cornerRadius(10)
                    
                    Spacer()
                    
                
                Spacer()
                
                // if it is a regular reminder
                if recurrenceTitle == "Do not repeat" {
                    Button(action: saveButtonPressed,
                           label: {
                        Text("Save".uppercased())
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(height:40)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    })
                } else {
                    // if it is a recurring reminder
                    Button(action: saveRecButtonPressed,
                           label: {
                        Text("Save".uppercased())
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(height:40)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    })
                }
                
            }.padding(14)
        }
        .onDisappear {
            listViewModel.reloadLocalNotifications()
        }
        
        
        .navigationTitle("Add an Item 🖊")
        .alert(isPresented: $showAlert, content: {
            getAlert()
        })
    }
    
    // when the save button is pressed, the task is added into the list, and a notification is created
    func saveButtonPressed() {
        if textIsAppropriate() == true {
            listViewModel.addItem(title: textFieldText, dateCompleted: dateToString(date: date), date: date)
            
            presentationMode.wrappedValue.dismiss()
  
            listViewModel.createLocalNotification(title: textFieldText, date: date, recurrence: "Do not repeat") { error in
            }
        }
    }
    
    func saveRecButtonPressed() {
        if textIsAppropriate() == true {
            if recurrenceTitle == "Do not repeat" {
                saveButtonPressed()
                return;
            } else {
                listViewModel.addRecItem(title: textFieldText, dateCompleted: dateToString(date: date), date: date, recurrence: recurrenceTitle)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textFieldText.count == 0 {
            
            alertTitle = "You must enter a task!"
            
            showAlert.toggle()
            return false
        } else {
            return true
        }
    }
    
    func getAlert() ->Alert {
        return Alert(title: Text(alertTitle))
    }
    
    func dateToString (date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        let now = df.string(from: date)
        return now
    }
    
}



struct AddView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            AddView()
        }
        .preferredColorScheme(.dark)
        .environmentObject(ListViewModel())
    }
}


