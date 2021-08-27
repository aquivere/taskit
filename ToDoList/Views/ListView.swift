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
   
    let today = Date()
    // let aWeekLater = Calendar.current.date(byAdding: dateComponent.day = 7, to: today)
    // ^ need to figure out how to do this properly
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading ) {
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
                TitleView()
                    .padding(.leading, 10)
                List {
                    ForEach(listViewModel.items) { item in
                        ListRowView(item: item)
                            .onTapGesture {
                                listViewModel.updateItem(item: item)
                            }
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: listViewModel.moveItem)
                
                .listStyle(PlainListStyle())
                }
                
                WeeklyView()
            }
                .navigationBarItems(
                    leading: NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    },
                    trailing: NavigationLink(destination: AddView()) {
                        Text("+")
                    }
                )
        }
    }
}


// TitleView
struct TitleView: View {
    @ObservedObject var userSettings = UserModel()
    @EnvironmentObject var listViewModel: ListViewModel
    
    let today = Date()
    
    var body: some View {
        
        Text("Hello \(userSettings.name),")
            .font(.title)
        
        Text("you have \(listViewModel.items.count) tasks to complete here!")
            .font(.title)
            .bold()
        
        Text(today, style: .date) + Text("-") + Text(today, style: .date)
            .italic()
            .font(.footnote)
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
                .environmentObject(ListViewModel())
        }
    }
}
