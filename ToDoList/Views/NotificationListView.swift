//
//  NotificationListView.swift
//  ToDoList
//
//  Created by Vivian Wang on 16/8/21.
//

import SwiftUI

struct NotificationListView: View {
    @StateObject private var notificationManager = NotificationManager()
    @State private var isCreatePresented = false
    
        // need to somehow link this to addview
    
    var body: some View {
        List(notificationManager.notifications, id: \.identifier) { notifications in
            Text(notifications.content.title)
                .fontWeight(.semibold)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Notifications")
        .onAppear(perform: notificationManager.reloadAuthorizationStatus)
        .onChange(of: notificationManager.authorizationStatus) {
            authorizationStatus in switch authorizationStatus {
            case .notDetermined:
                // request Authorization
                notificationManager.requestAuthorization()
            case .authorized:
                // get local authorisation
                notificationManager.reloadLocalNotifications()
            break
            default:
                break
            }
        }
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}

