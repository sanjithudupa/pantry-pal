//
//  NotificationsManager.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/24/21.
//

import Foundation
import UserNotifications

class NotificationsManager {
    
    let center = UNUserNotificationCenter.current()
    var authorized = false
    
    func askForAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            NotificationsManager.getInstance().authorized = granted
            print(granted)
        }
    }
    
    func scheduleNotification(foodItem: FoodItem) {
//        let center = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//        content.title = "Your " + foodItem.type.capitalized + " has expired!"
//        content.body = "Use it or remove it from your pantry."
//        content.categoryIdentifier = "alarm"
//        content.sound = UNNotificationSound.default
//
//        var dateComponents = DateComponents()
//        dateComponents.
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        center.add(request)
    }
    
    private static var instance: NotificationsManager? = nil
    
    public static func getInstance() -> NotificationsManager {
        if (instance == nil) {
            instance = NotificationsManager()
        }
        return instance!
    }
}
