//
//  MotherView.swift
//  ToDoList
//
//  Created by Borborick Zhu on 30/8/21.
//

import SwiftUI

struct MotherView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
        case .page1: ListView(viewRouter: viewRouter)
        case .page2: WeeklyRecurringListView(viewRouter: viewRouter)
        case .page3: FortnightlyRecurringListView(viewRouter: viewRouter)
        case .page4: MonthlyRecurringListView(viewRouter: viewRouter)
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView(viewRouter: ViewRouter()).environmentObject(ListViewModel())
    }
}
