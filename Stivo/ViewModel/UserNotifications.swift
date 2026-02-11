//
//  Untitled.swift
//  Stivo
//
//  Created by noura on 11/02/2026.
//

import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    // طلب إذن الإشعارات
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    // جدولة الإشعار حسب التكرار
    func scheduleNotification(for goal: Goal) {
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder 💪"
        content.body = goal.title
        content.sound = .default
        
        var dateComponents = DateComponents()
        
        switch goal.frequency {
        case .daily:
            dateComponents.hour = 9
            
        case .weekly:
            dateComponents.weekday = 2
            dateComponents.hour = 9
            
        case .monthly:
            dateComponents.day = 1
            dateComponents.hour = 9
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: goal.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
