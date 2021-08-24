//
//  ListView.swift
//  ToDoList
//
//  Created by Borborick Zhu on 8/7/21.
//

import SwiftUI

// TODO: create a toggle for on and off
struct ToDoButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("RegularListColor").opacity(configuration.isPressed ? 1 : 0.5))
            .clipShape(Capsule())
    }
}

struct RecurringButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("RecurringListColor").opacity(configuration.isPressed ? 1 : 0.5))
            .clipShape(Capsule())
    }
}

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var items: [ItemModel] = [
        ItemModel(title: "This is the first title!", isCompleted: false, dateCompleted: "04/03/2021", date: Date(), recurrence: ""),
        ItemModel(title: "This is the second title", isCompleted: false, dateCompleted: "04/03/2021",date: Date(), recurrence: ""),
        ItemModel(title: "Third!", isCompleted: false, dateCompleted: "04/03/2021",date: Date(), recurrence: "")
    ]
    
    // default is regular list
    @State private var regularListClicked = true
    @State private var recurringListClicked = false
    @State private var todayListClicked = false
    @State private var weeklyListClicked = false
    
    var body: some View {
        if listViewModel.items.isEmpty && listViewModel.recItems.isEmpty {
            NoItemsView()
                .transition(AnyTransition.opacity.animation(.easeIn))
                .offset(y: -100)
        } else {
            VStack {
                // background art.
                backgroundArt()
                
                // Elements recurring and not recurring.
                HStack {
                    Button ("To Do") {
                        regularListClicked = true
                        recurringListClicked = false
                        todayListClicked = false
                        weeklyListClicked = false
                    }
                    .buttonStyle(ToDoButton())
                    .offset(x: -50)
                    Button ("Recurring") {
                        recurringListClicked = true
                        regularListClicked = false
                        todayListClicked = false
                        weeklyListClicked = false

                    }
                    .buttonStyle(RecurringButton())
                    .offset(x:-20)
                    // -------------------------------------------------- //
                    // displaying sorted lists
                    Button ("Today") {
                        recurringListClicked = false
                        regularListClicked = false
                        todayListClicked = true
                        weeklyListClicked = false
                        listViewModel.orderDailyTasks()
                    }
                    .buttonStyle(ToDoButton())
                    .offset(x:20)
                    Button ("Weekly") {
                        recurringListClicked = false
                        regularListClicked = false
                        todayListClicked = false
                        weeklyListClicked = true
                        listViewModel.orderWeeklyTasks()
                    }
                    .buttonStyle(ToDoButton())
                    .offset(x:50)
                    // -------------------------------------------------- //

                } .offset(y: -100)
                
                // The list elements.
                // normal list.
                if regularListClicked {
                        List {
                            // Section 1: Recurring Features
                            ForEach(listViewModel.items) { item in
                                ListRowView(item: item)
                                    .onTapGesture {
                                            listViewModel.updateItem(item: item)

                                    }
                            }
                            .onDelete(perform: listViewModel.deleteItem)
                            .onMove(perform: listViewModel.moveItem)
                        }
                        .listStyle(PlainListStyle())
                        .padding(30)
                        .offset(y: -100)
                        NavigationLink(
                            destination: AddView(),
                            label: {
                                Text("Add To-Do ✏️")
                                    .font(.headline).italic()
                                    .foregroundColor(.black).opacity(1.0)
                                    .padding()
                                    .background(Color("RegularListColor").opacity(0.6))
                                    .cornerRadius(20)
                            }
                        )
                    
                }
                
                //recurring list.
                else if recurringListClicked {
                        List {
                            // Section 1: Recurring Features
                            ForEach(listViewModel.recItems) { item in
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
                        .offset(y: -100)
                        NavigationLink(
                            destination: AddView(),
                            label: {
                                Text("Add To-Do ✏️")
                                    .font(.headline).italic()
                                    .foregroundColor(.black).opacity(1.0)
                                    .padding()
                                    .background(Color("RecurringListColor").opacity(0.6))
                                    .cornerRadius(20)
                            }
                        )
                }
                
                // -------------------------------------------------- //
                // displaying the sorted lists
                else if todayListClicked {
                        List {
                            // Section 1: Recurring Features
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
                        .offset(y: -100)
                        NavigationLink(
                            destination: AddView(),
                            label: {
                                Text("Add To-Do ✏️")
                                    .font(.headline).italic()
                                    .foregroundColor(.black).opacity(1.0)
                                    .padding()
                                    .background(Color("RecurringListColor").opacity(0.6))
                                    .cornerRadius(20)
                            }
                        )
                }
                
                else if weeklyListClicked {
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
                        .offset(y: -100)
                        NavigationLink(
                            destination: AddView(),
                            label: {
                                Text("Add To-Do ✏️")
                                    .font(.headline).italic()
                                    .foregroundColor(.black).opacity(1.0)
                                    .padding()
                                    .background(Color("RecurringListColor").opacity(0.6))
                                    .cornerRadius(20)
                            }
                        )
                }
                
                
                // -------------------------------------------------- //

                
            }// .navigationTitle("📝 TO DO")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    NavigationLink ("Add", destination:
                                        AddView())
            )
        }
        
    }
}

struct backgroundArt: View {
    var body: some View {
        Image("LightClouds")
            .resizable()
            .frame(width: 450, height: 200)
            .offset(y: -80)
        Text("Let's start the day")
            .font(.system(size: 25)).italic()
            .offset(x: -40, y: -230)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
        .preferredColorScheme(.light)
        .environmentObject(ListViewModel())
    }
}

