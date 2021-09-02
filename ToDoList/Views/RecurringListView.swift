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
        
        List {
            ForEach(listViewModel.recItems) { item in
                if (item.recurrence == "Every Week" && !item.isCompleted) {
                    ListRowView(item: item)
                        .onTapGesture {
                            listViewModel.updateRecItem(recItem: item)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .listRowInsets(EdgeInsets())
                        .background(Color.white)
                }
                
            }
            .onDelete(perform: listViewModel.deleteRecItem)
            .onMove(perform: listViewModel.moveRecItem)
        }
        .listStyle(PlainListStyle())
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
        
        List {
            ForEach(listViewModel.recItems) { item in
                if (item.recurrence == "Every Fortnight" && !item.isCompleted) {
                    ListRowView(item: item)
                        .onTapGesture {
                            listViewModel.updateRecItem(recItem: item)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .listRowInsets(EdgeInsets())
                        .background(Color.white)
                }
                
            }
            .onDelete(perform: listViewModel.deleteRecItem)
            .onMove(perform: listViewModel.moveRecItem)
        }
        .listStyle(PlainListStyle())
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
        
        List {
            ForEach(listViewModel.recItems) { item in
                if (item.recurrence == "Every Month" && !item.isCompleted) {
                    ListRowView(item: item)
                        .onTapGesture {
                            listViewModel.updateRecItem(recItem: item)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .listRowInsets(EdgeInsets())
                        .background(Color.white)
                }
                
            }
            .onDelete(perform: listViewModel.deleteRecItem)
            .onMove(perform: listViewModel.moveRecItem)
        }
        .listStyle(PlainListStyle())

    }
}


