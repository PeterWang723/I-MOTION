//
//  NotificationManager.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/8.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                // Notifications are allowed
                completion(true)
            } else {
                // Notifications are not allowed
                completion(false)
            }
        }
    }
}
