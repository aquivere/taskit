import SwiftUI

struct ToDoButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("RegularListColor").opacity(configuration.isPressed ? 1 : 0.5))
            .clipShape(Capsule())
    }
}

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @ObservedObject var userSettings = UserModel()
    
    @State private var todayListClicked = false
    @State private var weeklyListClicked = false
   
    let today = Date()
    // let aWeekLater = Calendar.current.date(byAdding: dateComponent.day = 7, to: today)
    
    var body: some View {
        VStack {
           // if userSettings.selectedView == "Daily" {
                // Set up for daily view
                VStack (alignment: .leading) {
                    Text("Hello \(userSettings.name),")
                        .font(.title)
                    
                    Text("you have \(listViewModel.ordDailyItems.count) tasks today")
                        .font(.title)
                        .bold()
                    
                    Text(today, style: .date)
                        .italic()
                        .font(.footnote)
                }
                .offset(x: 20)
            HStack {
                Button ("Today") {
                    todayListClicked = true
                    weeklyListClicked = false
                    listViewModel.orderDailyTasks()
                }
                .buttonStyle(ToDoButton())
                
                Button ("This Week") {
                    todayListClicked = false
                    weeklyListClicked = true
                    listViewModel.orderWeeklyTasks()
                }
                .buttonStyle(ToDoButton())
                
                Button("All Tasks") {
                    todayListClicked = false
                    weeklyListClicked = false
                }
                .buttonStyle(ToDoButton())
            }
            
            if todayListClicked {
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
                    
            }
            
            else {
                List {
                    // Section 1: Recurring Features
                    ForEach(listViewModel.allItems) { item in
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

            //.offset(y: -100)
            /*} else if userSettings.selectedView == "Weekly" {
                // Set up for weekly view
                VStack (alignment: .leading) {
                    Text("Hello \(userSettings.name),")
                        .font(.title)
                    
                    Text("you have \(listViewModel.ordWeeklyItems.count) tasks this week")
                        .font(.title)
                        .bold()
                    
                    Text(today, style: .date) + Text("-") + Text(today, style: .date)
                        .italic()
                        .font(.footnote)
                }
                    .offset(x: 20)
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
            }*/
            
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(ListViewModel())
    }
}
