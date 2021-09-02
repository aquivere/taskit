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
    @StateObject var viewRouter: ViewRouter
    @State var indexNumber = 1

   
    let today = Date()
    // let aWeekLater = Calendar.current.date(byAdding: dateComponent.day = 7, to: today)
    // ^ need to figure out how to do this properly
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
                                .background(Color.white)
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 300)
                    .padding(.leading, 20)
                }
                Spacer()
                // RECURRING VIEWS - A TAB UNDER.
                // TO DO: MAKE THE ANIMATION BETWEEN THE SWITCH SMOOTHER. 
                if indexNumber == 1 {
                    Divider()
                    Text("this week")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .textCase(.lowercase)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .contextMenu {
                           
                            Button(action: {
                                indexNumber = 2
                            }, label: {
                                Text("Fortnightly Tasks")
                                    .textCase(.lowercase)
                            })
                            Button(action: {
                                indexNumber = 3
                            }, label: {
                                Text("Monthly Tasks")
                                    .textCase(.lowercase)
                            })
                        }
                    Divider()
                    
                        WeeklyRecurringListView(viewRouter: ViewRouter())
                            .padding(.leading, 20)
                    
                    
                } else if indexNumber == 2 {
                    Divider()
                    Text("this fortnight")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .textCase(.lowercase)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .contextMenu {
                           
                            Button(action: {
                                indexNumber = 1
                            }, label: {
                                Text("Weekly Tasks")
                                    .textCase(.lowercase)
                            })
                            Button(action: {
                                indexNumber = 3
                            }, label: {
                                Text("Monthly Tasks")
                                    .textCase(.lowercase)
                            })
                        }
                    Divider()
                    
                        FortnightlyRecurringListView(viewRouter: ViewRouter())
                            .padding(.leading, 20)
                    
                    
                } else {
                    Divider()
                    Text("this month")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .textCase(.lowercase)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .contextMenu {
                           
                            Button(action: {
                                self.indexNumber = 1
                            }, label: {
                                Text("Weekly Tasks")
                                    .textCase(.lowercase)
                            })
                            Button(action: {
                                self.indexNumber = 2
                            }, label: {
                                Text("Fortnightly Tasks")
                                    .textCase(.lowercase)
                            })
                        }
                    Divider()
                    
                        MonthlyRecurringListView(viewRouter: ViewRouter())
                            .padding(.leading, 20)
                    
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
            ListView(viewRouter: ViewRouter())
                .preferredColorScheme(.light)
                .environmentObject(ListViewModel())
        }
    }
}


//extra code
/* if userSettings.selectedView == "Daily" {
     // Set up for daily view
     TitleView()
         .padding(.leading, 10)
     
     Divider()
     
     List {
         LazyVStack {
             ForEach(listViewModel.items) { item in
                 ListRowView(item: item)
                     .onTapGesture {
                         listViewModel.updateItem(item: item)
                     }
             }
             .onDelete(perform: listViewModel.deleteItem)
             .onMove(perform: listViewModel.moveItem)
         }
     }
         .listStyle(PlainListStyle())
         
         

 } else if userSettings.selectedView == "Weekly" {
     // Set up for weekly view
     // WEEKLY TASK COUNT IS FOR MON - SUN not NOW -> 7 days later NEED TO FIX
     TitleView()
         .padding(.leading, 10)
     
     Divider()
     
     ScrollView {
         LazyVStack {
             ForEach(listViewModel.recItems) { item in
                 ListRowView(item: item)
                     .onTapGesture {
                         listViewModel.updateRecItem(recItem: item)
                     }
             }
             .onDelete(perform: listViewModel.deleteRecItem)
             .onMove(perform: listViewModel.moveRecItem)
         }
     }
         .listStyle(PlainListStyle())
     
    
 }   else if userSettings.selectedView == "All Tasks" {
     // Set up for weekly view
     // WEEKLY TASK COUNT IS FOR MON - SUN not NOW -> 7 days later NEED TO FIX
     TitleView()
         .padding(.leading, 10)
     
     Divider()
     
     ScrollView {
         LazyVStack {
             ForEach(listViewModel.allItems) { item in
                 ListRowView(item: item)
                     .onTapGesture {
                         listViewModel.updateRecItem(recItem: item)
                     }
             }
             .onDelete(perform: listViewModel.deleteRecItem)
             .onMove(perform: listViewModel.moveRecItem)
         }
     }
         .listStyle(PlainListStyle())
 }
 */


// SECTION FOR RECURRING TASKS, CAN SWITCH BETWEEN VIEWS
//                VStack {
//                    Text("this week")
//                        .fontWeight(.semibold)
//                        .font(.body)
//                        .textCase(.lowercase)
//                        .padding(.vertical, 2)
//                        .padding(.leading, 10)
//
//                        .contextMenu {
//
//                            Button(action: {
//                                viewRouter.currentPage = .page3
//                            }, label: {
//                                Text("Fortnightly View")
//                                    .textCase(.lowercase)
//                            })
//                            Button(action: {
//                                viewRouter.currentPage = .page4
//                            }, label: {
//                                Text("Monthly View")
//                                    .textCase(.lowercase)
//                            })
//                        }
//                Divider()
//                    List {
//                        ForEach(listViewModel.recItems) { item in
//                            if (item.recurrence == "Every Week" && !item.isCompleted) {
//                                ListRowView(item: item)
//                                    .onTapGesture {
//                                        listViewModel.updateRecItem(recItem: item)
//                                    }
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                                    .listRowInsets(EdgeInsets())
//                                    .background(Color.white)
//                            }
//
//                        }
//                        .onDelete(perform: listViewModel.deleteRecItem)
//                        .onMove(perform: listViewModel.moveRecItem)
//                    }
//                    .listStyle(PlainListStyle())
//
//                }
//                .frame(width: 300, height: 200, alignment: .center)
//                .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.purple, lineWidth: 3)
//                    )                .padding(50)
