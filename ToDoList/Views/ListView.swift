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
                if userSettings.selectedView == "Daily" {
                    // Set up for daily view
                    TitleView()
                        .padding(.leading, 10)
                    
                    Divider()
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(listViewModel.ordDailyItems) { item in
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
                        
                        
    
                } else if userSettings.selectedView == "Weekly" {
                    // Set up for weekly view
                    // WEEKLY TASK COUNT IS FOR MON - SUN not NOW -> 7 days later NEED TO FIX
                    TitleView()
                        .padding(.leading, 10)
                    
                    Divider()
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(listViewModel.ordWeeklyItems) { item in
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
                        
                        
                        
                        
                   
                } else if userSettings.selectedView == "All Tasks" {
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
        
        Text("you have \(listViewModel.allItems.count) tasks in total")
            .font(.title)
            .bold()
        
        Text(today, style: .date) + Text("-") + Text(today, style: .date)
            .italic()
            .font(.footnote)
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
