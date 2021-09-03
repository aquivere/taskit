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
                // include that date due is the current week
                if (item.recurrence == "Every Week" && !item.isCompleted && checkDate(item: item)) {
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
        .onAppear{ listViewModel.resetRecItem() }
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
                if (item.recurrence == "Every Fortnight" && !item.isCompleted && checkDate(item: item)) {
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
                if (item.recurrence == "Every Month" && !item.isCompleted && checkDate(item: item)) {
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

func checkDate(item: ItemModel) -> Bool {
    let components = Calendar.current.dateComponents([.weekOfYear, .year, .month], from: item.date)
    guard let itemWeek = components.weekOfYear else {return false}
    guard let itemYear = components.year else {return false}
    guard let itemMonth = components.month else {return false}
    let currComponents = Calendar.current.dateComponents([.weekOfYear, .year, .month], from: Date())
    guard let currWeek = currComponents.weekOfYear else {return false}
    guard let currYear = currComponents.year else {return false}
    guard let currMonth = currComponents.month else {return false}
    
    if (item.recurrence == "Every Week") {
        // if the item has a due date that is this week
        if ((itemWeek == currWeek) && (itemYear == currYear)) {
            return true;
        }
    } else if (item.recurrence == "Every Fortnight") {
        // if the item has a due date that is within this week and next week
        if (((itemWeek == currWeek) || (itemWeek == currWeek + 1)) && (itemYear == currYear)) {
            return true;
        } else if ((itemWeek == 52) && (currWeek == 1) && (itemYear == currYear - 1)) {
            return true;
        }
    } else if (item.recurrence == "Every Month") {
        // if the item has a due date that is this month
        if ((itemMonth == currMonth) && (itemYear == currYear)) {
            return true;
        }
    }
    
    return false
}


