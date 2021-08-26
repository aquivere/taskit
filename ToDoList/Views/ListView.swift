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
                    Text("Hello \(userSettings.name),")
                        .font(.title)
                    
                    Text("you have \(listViewModel.ordDailyItems.count) tasks today")
                        .font(.title)
                        .bold()
                    
                    Text(today, style: .date)
                        .italic()
                        .font(.footnote)
                    
                    Divider()
                    
                    List {
                        ForEach(listViewModel.ordDailyItems) { item in
                            ListRowView(item: item)
                                .onTapGesture {
                                    listViewModel.updateRecItem(recItem: item)
                                }
                        }
                        .onDelete(perform: listViewModel.deleteRecItem)
                        .onMove(perform: listViewModel.moveRecItem)
                    }
                        .listStyle(PlainListStyle())
                        .padding(30)
    
                } else if userSettings.selectedView == "Weekly" {
                    // Set up for weekly view
                    // WEEKLY TASK COUNT IS FOR MON - SUN not NOW -> 7 days later NEED TO FIX
                    Text("Hello \(userSettings.name),")
                        .font(.title)
                    
                    Text("you have \(listViewModel.ordWeeklyItems.count) tasks this week")
                        .font(.title)
                        .bold()
                    
                    Text(today, style: .date) + Text("-") + Text(today, style: .date)
                        .italic()
                        .font(.footnote)
                    
                    Divider()
                    
                    List {
                        // Section 1: Recurring Features
                        ForEach(listViewModel.ordWeeklyItems) { item in
                            ListRowView(item: item)
                                .onTapGesture {
                                    listViewModel.updateRecItem(recItem: item)
                                }
                        }
                        .onDelete(perform: listViewModel.deleteRecItem)
                        .onMove(perform: listViewModel.moveRecItem)
                    }
                        .listStyle(PlainListStyle())
                        .padding(30)
                   
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
                .offset(x: 20)
        }
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
