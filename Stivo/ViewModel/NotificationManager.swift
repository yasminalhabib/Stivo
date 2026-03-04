//
//  Untitled.swift
//  Stivo
//
//  Created by noura on 11/02/2026.
//

import Foundation
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    // MARK: - Request Permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print(granted ? "Notification permission granted" : "Notification permission denied")
        }
    }

    // MARK: - Schedule
    func scheduleNotification(for goal: Goal) {
        let content = UNMutableNotificationContent()
        content.title = "You set this goal for a reason. Don't stop now ⚡️"
        content.body = goal.title
        content.sound = .default

        var dateComponents = DateComponents()
        switch goal.frequency {
        case .daily:
            dateComponents.hour = 12

        case .weekly:
            dateComponents.weekday = 2
            dateComponents.hour = 12

        case .monthly:
            dateComponents.day = 1
            dateComponents.hour = 12
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: goal.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Cancel
    func cancelNotification(for id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }

    // MARK: - Reschedule if Edited
    func rescheduleIfNeeded(newGoal: Goal, oldGoal: Goal) {
        guard newGoal.title != oldGoal.title || newGoal.frequency != oldGoal.frequency else { return }
        cancelNotification(for: newGoal.id)
        scheduleNotification(for: newGoal)
    }
}
