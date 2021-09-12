//
//  ListView.swift
//  ToDoList
//
//  Created by Borborick Zhu on 8/7/21.
//  Home page view

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @ObservedObject var userSettings = UserModel()
    @EnvironmentObject var appState: AppState
    @State private var pressed = false
    @State var indexNumber = 1

   
    let today = Date()
    let colorMinimal = "Minimal"
    let background = "background"
    
    var body: some View {

        NavigationView {
            VStack(alignment: .leading ) {
               
                TitleView()
                    .padding(.leading, 20)
                
                // DAILY VIEW FOR REGULAR TASKS
                Divider()
                Text("Tasks")
                    .italic()
                    .fontWeight(.semibold)
                    .font(.body)
                    .textCase(.lowercase)
                    .padding(.vertical, 2)
                    .padding(.leading, 20)
                    
                Divider()
                ScrollView {
                    List {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .listRowInsets(EdgeInsets())
                                
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 300)
                    
                }
                Spacer()
                // RECURRING VIEWS - A TAB UNDER.
                if indexNumber == 1 {
                    Divider()
                    Text("this week")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .textCase(.lowercase)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .opacity(self.pressed ? 0 : 1.0)
                        .contextMenu {
                           
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 2
                                        self.pressed.toggle()
                                    }
                                    
                                }
                                
                            }, label: {
                                Text("this fortnight")
                                    .textCase(.lowercase)
                            })
                            Button(action: {
                                
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 3
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("this month")
                                    .textCase(.lowercase)
                            })
                        }
                    Divider()
                    
                        WeeklyRecurringListView()
                            
                    
                    
                } else if indexNumber == 2 {
                    Divider()
                    Text("this fortnight")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .textCase(.lowercase)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .opacity(self.pressed ? 0 : 1.0)
                        .contextMenu {
                           
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 1
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("this week")
                                    .textCase(.lowercase)
                            })
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 3
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("this month")
                                    .textCase(.lowercase)
                            })
                        }
                    Divider()
                    
                        FortnightlyRecurringListView()
                            
                    
                    
                } else {
                    Divider()
                    Text("this month")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .textCase(.lowercase)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .opacity(self.pressed ? 0 : 1.0)
                        .contextMenu {
                           
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 1
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("this week")
                                    .textCase(.lowercase)
                            })
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 2
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("this fortnight")
                                    .textCase(.lowercase)
                            })
                        }
                    Divider()
                    
                        MonthlyRecurringListView()
                            
                    
                }
            }
            .navigationBarTitle("Hello \(userSettings.name)!")
            .navigationBarItems(
                leading: NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .textCase(.lowercase)
                        .foregroundColor(Color(colorMinimal))
                        
                },
                trailing: NavigationLink(destination: AddView()) {
                    Text("+")
                        .textCase(.lowercase)
                        .foregroundColor(Color(colorMinimal))
                }
            )
        }
        // .navigationTitle("Notifications")
        .onAppear(perform: listViewModel.reloadAuthorizationStatus)
        .onChange(of: listViewModel.authorizationStatus) {
            authorizationStatus in switch authorizationStatus {
            case .notDetermined:
                // request Authorization
                listViewModel.requestAuthorization()
            case .authorized:
                // get local authorisation
                listViewModel.reloadLocalNotifications()
            default:
                break
            }
        }
    }
    
}


// TitleView
struct TitleView: View {
    @ObservedObject var userSettings = UserModel()
    @EnvironmentObject var listViewModel: ListViewModel
    
    let today = Date()
    
    var body: some View {
        
        Text("You have \(listViewModel.items.count) tasks to complete!")
            .font(.title)
            .bold()
        
        Text(today, style: .date)
            .padding(.vertical, 5)
    }
}

struct WeeklyView: View {
    // TODO: align everything so it's centered
    // also need to make the list background the same colour
    // then repeat for all the other recurring
    @ObservedObject var userSettings = UserModel()
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color("Recurring"))
                            .frame(width: 350, height: 250)
            VStack {
                
                Text("Weekly Tasks").font(.headline)
                
                List {
                    ForEach(listViewModel.recItems) { item in
                        if item.recurrence == "Every Week" {
                            ListRowView(item: item)
                                .onTapGesture {
                                    listViewModel.updateRecItem(recItem: item)
                                }.background(Color("Recurring"))
                        }
                    }
                    .onDelete(perform: listViewModel.deleteRecItem)
                    .onMove(perform: listViewModel.moveRecItem)
                
                .listStyle(PlainListStyle())
                }.frame(width: 300, height: 200, alignment: .center)
            }
        }.padding(10)
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListView()
                .preferredColorScheme(.light)
                .environmentObject(ListViewModel())
        }
    }
}
