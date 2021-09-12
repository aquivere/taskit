//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Borborick Zhu on 9/7/21.
//

import Foundation
import UserNotifications

/*
CRUD FUNCTIONS/Users/Vivian/Desktop/welcome/1-uni/projects/todolist_git/self-project/ViewModels/ListViewModel.swift
 create
 read
 update
 delete
*/

class ListViewModel: ObservableObject {
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    @Published var notifIds: [String] = [""]
    @Published var notifNum: Int = 0
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    
    @Published var recItems: [ItemModel] = [] {
        didSet {
            saveRecItems()
        }
    }
    
    @Published var allItems: [ItemModel] = []
    @Published var ordDailyItems: [ItemModel] = []
    @Published var ordWeeklyItems: [ItemModel] = []
    
    let itemsKey: String = "items_list"
    let recItemsKey: String = "rec_items_list"
    
    init() {
        getItems()
        getRecItems()
    }
    
    // for regular items
    
    func getItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey) else {return}
        guard let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.items = savedItems
    }
    func deleteItem(indexSet: IndexSet) {
        for item in indexSet {
            let index = Int(item)
            let myString = items[index].id
            deleteLocalNotification(notifId: myString)
        }
        items.remove(atOffsets: indexSet)
        
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
        
    }
    
    func addItem(title:String, dateCompleted: String, date: Date) {
        let newItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: "Do not repeat")
        items.append(newItem)
        allItems.append(newItem)
        
        items = items.sorted(by: {$0.date.compare($1.date) == .orderedAscending })
       
    }

    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
            
            if !item.isCompleted {
                // if item is turned into completed, then we no longer need to run the notification
                deleteLocalNotification(notifId: item.id)
            }
            items.remove(at: (index))
        }
    }
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    // for recurring items
    func getRecItems() {
        guard let data = UserDefaults.standard.data(forKey: recItemsKey) else {return}
        guard let savedRecItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.recItems = savedRecItems
        
    }
    func deleteRecItem(indexSet: IndexSet) {
        recItems.remove(atOffsets: indexSet)
        
    }
    func moveRecItem(from: IndexSet, to: Int) {
        recItems.move(fromOffsets: from, toOffset: to)
        
    }
    
    // function to reset completion for recurring items
    
    func addRecItem(title:String, dateCompleted: String, date: Date, recurrence: String) {
        if (recurrence == "Do not repeat") {
            addItem(title: title, dateCompleted: dateCompleted, date: date)
            return
        }
        let newRecItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
        recItems.append(newRecItem)
        allItems.append(newRecItem)
        recItems = recItems.sorted(by: {$0.date.compare($1.date) == .orderedAscending })
    }
    
    func resetRecItem() {
        var index = 0
        while (index < recItems.count) {
            let recItem = recItems[index]
            let components = Calendar.current.dateComponents([.weekOfYear, .year, .month], from: recItem.date)
            guard let itemWeek = components.weekOfYear else {return;}
            guard let itemYear = components.year else {return;}
            guard let itemMonth = components.month else {return;}
            let currComponents = Calendar.current.dateComponents([.weekOfYear, .year, .month], from: Date())
            guard let currWeek = currComponents.weekOfYear else {return;}
            guard let currYear = currComponents.year else {return;}
            guard let currMonth = currComponents.month else {return;}
            
            if (recItem.recurrence == "Every Week") {
                // check if the current week is one week after than the due date, that means they did not complete the task that week
                // if it is, then reset the due date to the next week
                // if it is a later week after current week, leave as it is
            
                if (((currWeek > itemWeek) && (currYear == itemYear)) || (currYear > itemYear)) {
                    // change due date to next one and back to incomplete
                    updateRecItem(recItem: recItem)

                }
            } else if (recItem.recurrence == "Every Fortnight") {
                // check if the current week is within the two weeks from the current week
                // if the task is due this week or next week, we want to show it
                // if the current week is after two weeks from previous due date, then that means they  did not complete the task that fortnight
                // reset the due date to the next fortnight if so
                // if it is completed within the two weeks, the due date is reset to after so leave as it is
                if ( (currWeek > (itemWeek + 1)) && (currYear == itemYear) ) {
                    updateRecItem(recItem: recItem)
                } else if ( (currWeek == 1) && (itemWeek == 51) && (currYear == itemYear + 1) ) {
                    updateRecItem(recItem: recItem)
                } else if ( (currWeek == 2) && (itemWeek == 52) && (currYear == itemYear + 1) ) {
                    updateRecItem(recItem: recItem)
                }
            } else if (recItem.recurrence == "Every Month") {
                if ( ((currMonth > itemMonth) && (currYear == itemYear)) || (currYear > itemYear) ) {
                    updateRecItem(recItem: recItem)
                }
            }
            index = index + 1
        }
        
    }
    func updateRecItem(recItem: ItemModel) {
        if let index = recItems.firstIndex(where: { $0.id == recItem.id }) {
            var newDate: Date
            if (recItem.recurrence == "Every Week") {
                var components = Calendar.current.dateComponents([.weekday, .weekOfYear, .year], from: recItem.date)
                guard let week = components.weekOfYear else {return;}
                guard let year = components.year else {return;}
                
                if (week != 52) {
                    components.weekOfYear = week + 1
                } else {
                    components.weekOfYear = 1
                    components.year = year + 1
                }
                guard let newDate: Date = Calendar.current.date(from: components) else {return;}
                recItems[index] = recItem.updateRecDate(date: newDate)
            } else if (recItem.recurrence == "Every Fortnight") {
                let timeLapsed: TimeInterval = 1209600
                newDate = recItem.date + timeLapsed
                recItems[index] = recItem.updateRecCompletion(date: newDate)
                
            } else if (recItem.recurrence == "Every Month") {
                var components = Calendar.current.dateComponents([.day, .month, .year], from: recItem.date)
                guard let month = components.month else {return;}
                guard let year = components.year else {return;}
                if (month != 12) {
                    components.month = month + 1
                } else {
                    components.month = 1
                    components.year = year + 1
                }
                guard let newDate: Date = Calendar.current.date(from: components) else {return;}
                recItems[index] = recItem.updateRecCompletion(date: newDate)
            }
        }
    }
    func saveRecItems() {
        if let encodedData = try? JSONEncoder().encode(recItems) {
            UserDefaults.standard.set(encodedData, forKey: recItemsKey)
        }
    }
    
    
    // Notification functions
    
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in DispatchQueue.main.async {
            self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }
    
    func reloadLocalNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.sync {
                self.notifications = notifications
            }
        }
    }
    
    
    func createLocalNotification(title: String, date: Date, recurrence: String, completion: @escaping (Error?) -> Void) {
        if let index = items.firstIndex(where: { $0.title == title }) {
            let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.sound = .default
            let myString = items[index].id
            let request = UNNotificationRequest(identifier: myString, content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
        }
 
    }
    

    func deleteLocalNotification(notifId: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
            if notification.identifier == notifId {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
}

 
