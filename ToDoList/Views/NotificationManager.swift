//
//  NotificationManager.swift
//  ToDoList
//
//  Created by Vivian Wang on 16/8/21.
//

// idk where i'm meant to put this file

import Foundation
import UserNotifications


final class NotificationManager: ObservableObject {

    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
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
    
}

