//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
//

import Foundation
import UserNotifications

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
        
    let itemsKey: String = "items_list"
    let recItemsKey: String = "rec_items_list"
    
    init() {
        getItems()
        getRecItems()
    }
    
    // Functions for regular tasks (non-repeating)
    
    // store data so that it persists after the program is shut down
    func getItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey) else {return}
        guard let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.items = savedItems
    }
    
    // function to delete the task permanently from list, and remove its pending notification
    func deleteItem(indexSet: IndexSet) {
        for item in indexSet {
            let index = Int(item)
            let myString = items[index].id
            deleteLocalNotification(notifId: myString)
        }
        items.remove(atOffsets: indexSet)
    }
    
    // function to move the order of the task in the list
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    // function to add a new task into the list, and sort the list in order of due date
    func addItem(title:String, dateCompleted: String, date: Date) {
        let newItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: "Do not repeat")
        items.append(newItem)
        items = items.sorted(by: {$0.date.compare($1.date) == .orderedAscending })
    }

    // function to update completion of the item
    // when the task is clicked as complete, item is removed permanently from list, and pending notification is deleted
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
    
    // Functions for recurring items
    
    // store data so that it persists after the program is shut down
    func getRecItems() {
        guard let data = UserDefaults.standard.data(forKey: recItemsKey) else {return}
        guard let savedRecItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.recItems = savedRecItems
    }
    
    // function to delete the recurring task from the recurring tasks list
    func deleteRecItem(indexSet: IndexSet) {
        recItems.remove(atOffsets: indexSet)
    }
    
    // function to move the order of the recurring task in the list
    func moveRecItem(from: IndexSet, to: Int) {
        recItems.move(fromOffsets: from, toOffset: to)
        
    }
    
    // function to add a recurring task into the list
    func addRecItem(title:String, dateCompleted: String, date: Date, recurrence: String) {
        if (recurrence == "Do not repeat") {
            addItem(title: title, dateCompleted: dateCompleted, date: date)
            return
        }
        let newRecItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
        recItems.append(newRecItem)
        recItems = recItems.sorted(by: {$0.date.compare($1.date) == .orderedAscending })
    }
    
    // function to reset completion for recurring items when the time period has past
    // i.e. if a weekly item has been completed, it will reset to incomplete the next week
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
            // if the current week/fortnight/month is later than the due date of the task, it means that the item was not completed in that time period
            // if so, call the updateRecItem function, to update the due date to the upcoming week/fortnight/month
            // check this with each repeating task in the list
            if (recItem.recurrence == "Every Week") {
                if (((currWeek > itemWeek) && (currYear == itemYear)) || (currYear > itemYear)) {
                    updateRecItem(recItem: recItem)
                }
            } else if (recItem.recurrence == "Every Fortnight") {
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
    
    // function to set a new due date for repeating tasks and make them be marked as incomplete
    func updateRecItem(recItem: ItemModel) {
        if let index = recItems.firstIndex(where: { $0.id == recItem.id }) {
            var newDate: Date
            if (recItem.recurrence == "Every Week") {
                // reset the due date to be the week after the task's previous due date
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
                // reset the due date to be a fortnight after the task's previous due date
                let timeLapsed: TimeInterval = 1209600
                newDate = recItem.date + timeLapsed
                recItems[index] = recItem.updateRecCompletion(date: newDate)
                
            } else if (recItem.recurrence == "Every Month") {
                // reset the due date to be a month after the task's previous due date
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
    
    
    // Functions to set notifications for regular non-repeating tasks
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in DispatchQueue.main.async {
            self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    // function to request authorization for notifications, if not already answered
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
    
    // function to create the local notification, with the notification being set off on the due date and time of the task
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
    
    // function to delete a pending notification for a particular task
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

 
