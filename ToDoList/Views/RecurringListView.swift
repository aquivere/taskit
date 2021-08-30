//
//  RecurringListView.swift
//  ToDoList
//
//  Created by Vivian Wang on 19/8/21.
//

import SwiftUI

struct WeeklyRecurringListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @ObservedObject var userSettings = UserModel()
    @StateObject var viewRouter: ViewRouter
   
    let today = Date()
    // let aWeekLater = Calendar.current.date(byAdding: dateComponent.day = 7, to: today)
    // ^ need to figure out how to do this properly
    let colorMinimal = "Minimal"
    var body: some View {
        NavigationView {
            VStack(alignment: .leading ) {
               
                TitleView()
                    .padding(.leading, 10)
                
                Text("Weekly View")
                    .fontWeight(.semibold)
                    .font(.body)
                    .textCase(.lowercase)
                    .padding(.vertical, 2)
                    .padding(.leading, 10)
                    .contextMenu {
                        Button(action: {
                            viewRouter.currentPage = .page1
                        }, label: {
                            Text("Daily View")
                                .textCase(.lowercase)
                        })
                        Button(action: {
                            viewRouter.currentPage = .page3
                        }, label: {
                            Text("Fortnightly View")
                                .textCase(.lowercase)
                        })
                        Button(action: {
                            viewRouter.currentPage = .page4
                        }, label: {
                            Text("Monthly View")
                                .textCase(.lowercase)
                        })
                    }
                
                Divider()
            
                List {
                    ForEach(listViewModel.items) { item in
                        ListRowView(item: item)
                            .onTapGesture {
                                listViewModel.updateItem(item: item)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .listRowInsets(EdgeInsets())
                            .background(Color.white)
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: listViewModel.moveItem)
                }

                .listStyle(PlainListStyle())
                
                
            }
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
    }
}

struct FortnightlyRecurringListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @ObservedObject var userSettings = UserModel()
    @StateObject var viewRouter: ViewRouter
    
    let today = Date()
    // let aWeekLater = Calendar.current.date(byAdding: dateComponent.day = 7, to: today)
    // ^ need to figure out how to do this properly
    let colorMinimal = "Minimal"
    var body: some View {
        NavigationView {
            VStack(alignment: .leading ) {
               
                TitleView()
                    .padding(.leading, 10)
                
                Text("Fortnightly View")
                    .fontWeight(.semibold)
                    .font(.body)
                    .textCase(.lowercase)
                    .padding(.vertical, 2)
                    .padding(.leading, 10)
                    .contextMenu {
                        Button(action: {
                            viewRouter.currentPage = .page1
                        }, label: {
                            Text("Daily View")
                                .textCase(.lowercase)
                        })
                        Button(action: {
                            viewRouter.currentPage = .page2
                        }, label: {
                            Text("Weekly View")
                                .textCase(.lowercase)
                        })
                        Button(action: {
                            viewRouter.currentPage = .page4
                        }, label: {
                            Text("Monthly View")
                                .textCase(.lowercase)
                        })
                    }
                
                Divider()
            
                List {
                    ForEach(listViewModel.items) { item in
                        ListRowView(item: item)
                            .onTapGesture {
                                listViewModel.updateItem(item: item)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .listRowInsets(EdgeInsets())
                            .background(Color.white)
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: listViewModel.moveItem)
                }

                .listStyle(PlainListStyle())
                
                
            }
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
    }
}


struct MonthlyRecurringListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @ObservedObject var userSettings = UserModel()
    @StateObject var viewRouter: ViewRouter
    let today = Date()
    // let aWeekLater = Calendar.current.date(byAdding: dateComponent.day = 7, to: today)
    // ^ need to figure out how to do this properly
    let colorMinimal = "Minimal"
    var body: some View {
        NavigationView {
            VStack(alignment: .leading ) {
               
                TitleView()
                    .padding(.leading, 10)
                
                Text("Monthly View")
                    .fontWeight(.semibold)
                    .font(.body)
                    .textCase(.lowercase)
                    .padding(.vertical, 2)
                    .padding(.leading, 10)
                    .contextMenu {
                        Button(action: {
                            viewRouter.currentPage = .page1
                        }, label: {
                            Text("Daily View")
                                .textCase(.lowercase)
                        })
                        Button(action: {
                            viewRouter.currentPage = .page2
                        }, label: {
                            Text("Weekly View")
                                .textCase(.lowercase)
                        })
                        Button(action: {
                            viewRouter.currentPage = .page3
                        }, label: {
                            Text("Fortnightly View")
                                .textCase(.lowercase)
                        })
                    }
                
                Divider()
            
                List {
                    ForEach(listViewModel.items) { item in
                        ListRowView(item: item)
                            .onTapGesture {
                                listViewModel.updateItem(item: item)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .listRowInsets(EdgeInsets())
                            .background(Color.white)
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: listViewModel.moveItem)
                }

                .listStyle(PlainListStyle())
                
                
            }
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
    }
}


struct WeeklyRecurringListView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyRecurringListView(viewRouter: ViewRouter()).environmentObject(ListViewModel())
    }
}
