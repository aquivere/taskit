//
//  NotificationListView.swift
//  ToDoList
//
//  Created by Vivian Wang on 16/8/21.
//

/*

import SwiftUI

struct NotificationListView: View {
    @StateObject private var notificationManager = ListViewModel()
    
    var body: some View {
        List(notificationManager.notifications, id: \.identifier) { notifications in
            Text(notifications.content.title)
                .fontWeight(.semibold)
        }
        .listStyle(InsetGroupedListStyle())
        // .navigationTitle("Notifications")
        .onAppear(perform: notificationManager.reloadAuthorizationStatus)
        .onChange(of: notificationManager.authorizationStatus) {
            authorizationStatus in switch authorizationStatus {
            case .notDetermined:
                // request Authorization
                notificationManager.requestAuthorization()
            case .authorized:
                // get local authorisation
                notificationManager.reloadLocalNotifications()
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

*/
