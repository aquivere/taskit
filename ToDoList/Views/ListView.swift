//
//  ListView.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim on 8/7/21.
//  Home page view

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @ObservedObject var userSettings = UserModel()
    @EnvironmentObject var appState: AppState
    @State private var pressed = false
    @State var indexNumber = 1

    let colorMinimal = "Minimal"
    let background = "background"
    
    var body: some View {

        NavigationView {
            VStack(alignment: .leading ) {
               
                TitleView()
                    .padding(.leading)
                
                // DAILY VIEW FOR NON RECURRING TASKS
                Divider()
                    .frame(height: 1)
                    .background(Color("AccentColor"))
                
                Text("Today")
                    .italic()
                    .fontWeight(.semibold)
                    .font(.body)
                    .foregroundColor(Color("Minimal"))
                    .padding(.vertical, 2)
                    .padding(.leading, 20)
               
                Divider()
                    .frame(height: 1)
                    .background(Color("AccentColor"))
                
                ScrollView {
                    List {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .listRowInsets(EdgeInsets())
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 300)
                    .padding(.leading, 20)
                }
                
                Spacer()
               
                // RECURRING VIEWS - A TAB UNDER.
                if indexNumber == 1 {
                    Divider()
                        .frame(height: 1)
                        .background(Color("AccentColor"))
                    
                    Text("This week")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .contextMenu {
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 2
                                        self.pressed.toggle()
                                    }
                                    
                                }
                                
                            }, label: {
                                Text("This fortnight")
                            }
                            )
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 3
                                        self.pressed.toggle()
                                    }
                                }
                            }, label: {
                                Text("This month")
                            })
                        }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color("AccentColor"))
                    
                    WeeklyRecurringListView()
                        .padding(.leading, 20)
                    
                } else if indexNumber == 2 {
                    Divider()
                        .frame(height: 1)
                        .background(Color("AccentColor"))
                    
                    Text("This fortnight")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .opacity(self.pressed ? 0 : 1.0)
                        .contextMenu {
                           
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 1
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("This week")
                            }
                            )
                            
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 3
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("This month")
                            }
                            )
                        }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color("AccentColor"))
                    
                    FortnightlyRecurringListView()
                    
                } else {
                    Divider()
                        .frame(height: 1)
                        .background(Color("AccentColor"))
                    
                    Text("This month")
                        .italic()
                        .fontWeight(.semibold)
                        .font(.body)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                        .opacity(self.pressed ? 0 : 1.0)
                        .contextMenu {
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 1
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("This week")
                            })
                            Button(action: {
                                self.pressed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.linear) {
                                        indexNumber = 2
                                        self.pressed.toggle()
                                    }
                                    
                                }
                            }, label: {
                                Text("This fortnight")
                            })
                        }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color("AccentColor"))
                    
                    MonthlyRecurringListView()
                        .padding(.leading, 20)
                    
                }
            }
            .navigationBarTitle(Text("Home"), displayMode: .inline)
            .navigationBarItems(
                leading: NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .foregroundColor(Color("AccentColor"))
                    
                },
                trailing: NavigationLink(destination: AddView()) {
                    Text("+")
                        .font(.system(size: 25))
                        .foregroundColor(Color("AccentColor"))
                }
            )
        }
        .onAppear(perform: listViewModel.reloadAuthorizationStatus)
        .onChange(of: listViewModel.authorizationStatus) {
            authorizationStatus in switch authorizationStatus {
            case .notDetermined:
                // request Authorization
                listViewModel.requestAuthorization()
            case .authorized:
                // get local authorisation
                listViewModel.reloadLocalNotifications()
            default:
                break
            }
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
            .bold()
            .padding(.top, 20)
            .foregroundColor(Color("Minimal"))
        
        if listViewModel.items.count == 1 {
            Text("you have \(listViewModel.items.count) task \nto complete.")
                .font(.title)
                .bold()
                .foregroundColor(Color("Minimal"))
            
        } else {
            Text("you have \(listViewModel.items.count) tasks \nto complete.")
                .font(.title)
                .bold()
                .foregroundColor(Color("Minimal"))
        }
        
        Text(today, style: .date)
            .italic()
            .padding(.top, 2)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListView()
                .environmentObject(ListViewModel())
                .modifier(DarkModeViewModifier())
        }
    }
}
