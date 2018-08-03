//
//  Notification.swift
//  SleepTonight
//
//  Created by Selena Sui on 7/30/18.
//

import Foundation
import UserNotifications

struct Notification {
    
    let title: String
    let body: String
    let identifier: String
    let dateMatching: DateComponents
    let trigger: UNNotificationTrigger
    
    init(title: String, body: String, identifier: String, dateMatching: DateComponents) {
        self.title = title
        self.body = body
        self.identifier = identifier
        self.dateMatching = dateMatching
        
        self.trigger = UNCalendarNotificationTrigger(dateMatching: self.dateMatching, repeats: true)
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = self.title
        content.body = self.body
        content.sound = UNNotificationSound.default()
        
        self.removeNotification()
        
        let request = UNNotificationRequest(identifier: self.identifier, content: content, trigger: self.trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.identifier])
    }
    
}
