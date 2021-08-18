//
//  AddView.swift
//  ToDoList
//
//  Created by Borborick Zhu on 8/7/21.
//  Edited by Vivian Wang on 17/08/21

import SwiftUI
import Foundation


struct AddView: View {
    @StateObject private var notificationManager = NotificationManager()
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
                                //TODO: need to save recurrence string/ data and use it in this screen
                            }
                            
                        })
                        .padding()
                        .foregroundColor(.white)
                        .font(.headline)

                        .cornerRadius(10)
                    
                    Spacer()
                    
                
                Spacer()
                
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
            }.padding(14)
        }
        .onDisappear {
            notificationManager.reloadLocalNotifications()
        }
        
        
        .navigationTitle("Add an Item 🖊")
        .alert(isPresented: $showAlert, content: {
            getAlert()
        })
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() == true {
            listViewModel.addItem(title: textFieldText, dateCompleted: dateToString(date: date), date: date)
            
            presentationMode.wrappedValue.dismiss()
            
            // to create the notification
            let emojis = "‼️😱⏳"
            let text = textFieldText + emojis
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return }
            notificationManager.createLocalNotification(title: text, hour: hour, minute: minute) { error in
            }
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textFieldText.count < 3 {
            
            alertTitle = "Your new to do item must be at least three characters long!!! 😅"
            
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


