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
        items.remove(atOffsets: indexSet)
        
    }
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
        
    }
    func addItem(title:String, dateCompleted: String, date: Date) {
        let newItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: "")
        items.append(newItem)
        
    }
    // TODO: CLEAN EVERYTHING UP !!!!!!!!!!
    func updateItem(item: ItemModel) {
        if var index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
            if !item.isCompleted {
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
           if newRecItem.recurrence == "Every Day" {
            
            let recInfo: [Any] = [index, newRecItem]
            let timer = Timer(fireAt: newRecItem.date, interval: 10, target: self, selector: #selector(reset), userInfo: recInfo, repeats: true)
            RunLoop.current.add(timer, forMode: .default)
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
    
    func createLocalNotification(title: String, day: Int, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
        
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.sound = .default
        
        /*
        notifIds.append(UUID().uuidString)
        print(UUID().uuidString)
        print(notifIds[1])*/
        
        notifNum = notifNum + 1
        let myString = String(notifNum)

        let request = UNNotificationRequest(identifier: myString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
}

