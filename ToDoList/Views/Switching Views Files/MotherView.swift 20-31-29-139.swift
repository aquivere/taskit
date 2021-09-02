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
        case .page5: TutorialView(viewRouter: viewRouter)
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView(viewRouter: ViewRouter()).environmentObject(ListViewModel())
    }
}
