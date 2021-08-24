//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Borborick Zhu on 9/7/21.
//

import Foundation
import UserNotifications

/*
 
CRUD FUNCTIONS
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
    
    let itemsKey: String = "items_list"
    let recItemsKey: String = "rec_items_list"
    
    init() {
        
    }
    
    // for regular items
    
    func getItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey) else {return}
        guard let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.items = savedItems
    }
    func deleteItem(indexSet: IndexSet) {
        // TODO: delete notification from here
        items.remove(atOffsets: indexSet)
        
    }
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
        
    }
    func addItem(title:String, dateCompleted: String, date: Date) {
        let newItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: "Do not repeat")
        items.append(newItem)
        
    }
    // TODO: CLEAN EVERYTHING UP !!!!!!!!!!
    func updateItem(item: ItemModel) {
        if var index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
            
            if !item.isCompleted {
                // if item is turned into completed, then we no longer need to run the notification
                index = index + 1
               // print(self.notif.notifIds[index])
                let string = String(index)
                UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                   var identifiers: [String] = []
                   for notification:UNNotificationRequest in notificationRequests {
                    if notification.identifier == string {
                        print(notification.identifier)
                        print(string)
                          identifiers.append(notification.identifier)
                       }
                   }
                   UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                }
            }
        }
    }
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    // for recurring items
    
    func getRecItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey) else {return}
        guard let savedRecItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.recItems = savedRecItems
        
    }
    func deleteRecItem(indexSet: IndexSet) {
        recItems.remove(atOffsets: indexSet)
        
    }
    func moveRecItem(from: IndexSet, to: Int) {
        recItems.move(fromOffsets: from, toOffset: to)
        
    }
    
    @objc func reset(timer: Timer) {
        guard let info = timer.userInfo as? [Any] else {print("error"); return;}
        guard let index = info[0] as? Int else {print("error"); return;}
        guard let newItem = info[1] as? ItemModel else {print("error"); return;}
        self.recItems[index] = newItem.resetCompletion()
        
    }
    
    func addRecItem(title:String, dateCompleted: String, date: Date, recurrence: String) {
        let newRecItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
        recItems.append(newRecItem)
        if let index = recItems.firstIndex(where: { $0.id == newRecItem.id }) {
            // reset the completion to incomplete when recurring
           if newRecItem.recurrence == "Every Day" {
                let recInfo: [Any] = [index, newRecItem]
                let timer = Timer(fireAt: newRecItem.date, interval: 86400, target: self, selector: #selector(reset), userInfo: recInfo, repeats: true)
                RunLoop.current.add(timer, forMode: .default)
            
           } else if newRecItem.recurrence == "Every Week" {
                let recInfo: [Any] = [index, newRecItem]
                let timer = Timer(fireAt: newRecItem.date, interval: 604800, target: self, selector: #selector(reset), userInfo: recInfo, repeats: true)
                RunLoop.current.add(timer, forMode: .default)
            
           } else if newRecItem.recurrence == "Every Fortnight" {
                let recInfo: [Any] = [index, newRecItem]
                let timer = Timer(fireAt: newRecItem.date, interval: 1209600, target: self, selector: #selector(reset), userInfo: recInfo, repeats: true)
                RunLoop.current.add(timer, forMode: .default)
            
           } else if newRecItem.recurrence == "Every Month" {
                let recInfo: [Any] = [index, newRecItem]
                let dateComp = Calendar.current.dateComponents([.month], from: date)
                if dateComp.month == 4 || dateComp.month == 6 || dateComp.month == 9 || dateComp.month == 11 {
                    // 30 days
                    let timer = Timer(fireAt: newRecItem.date, interval: 2592000, target: self, selector: #selector(reset), userInfo: recInfo, repeats: true)
                    RunLoop.current.add(timer, forMode: .default)
                    
                } else if dateComp.month == 2 {
                    // Feb has 28 days
                    let timer = Timer(fireAt: newRecItem.date, interval: 2419200, target: self, selector: #selector(reset), userInfo: recInfo, repeats: true)
                    RunLoop.current.add(timer, forMode: .default)
                    
                } else {
                    // 31 days
                    let timer = Timer(fireAt: newRecItem.date, interval: 2678400, target: self, selector: #selector(reset), userInfo: recInfo, repeats: true)
                    RunLoop.current.add(timer, forMode: .default)
                    
                }
           }
        }
    }
    
    func updateRecItem(recItem: ItemModel) {
        if let index = recItems.firstIndex(where: { $0.id == recItem.id }) {
            recItems[index] = recItem.updateCompletion()
        }
        
    }
    func saveRecItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
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
        print("reloadLocalNotifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.sync {
                self.notifications = notifications
            }
        }
    }
    
    func createLocalNotification(title: String, date: Date, recurrence: String, completion: @escaping (Error?) -> Void) {
        
        var dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        
        if recurrence == "Every Day" {
            dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        } else if recurrence == "Every Week" {
            dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        } else if recurrence == "Every Fortnight" {
            dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        } else if recurrence == "Every Month" {
            dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        }
        
        var trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        if recurrence != "Do not repeat" {
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
        }

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.sound = .default
        
        notifNum = notifNum + 1
        let myString = String(notifNum)

        let request = UNNotificationRequest(identifier: myString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
}

