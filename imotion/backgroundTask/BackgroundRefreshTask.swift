//
//  BackgroundRefreshTask.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/2.
//

import BackgroundTasks
import UIKit

func scheduleAppRefresh() {
    let today = Calendar.current.startOfDay(for: .now)
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    let request = BGProcessingTaskRequest(identifier: "InferenceAndSendData")
    request.earliestBeginDate = tomorrow
    try? BGTaskScheduler.shared.submit(request)
}

func scheduleTestNotification() {
    print("Test scheduleNotification")
    let fiveMinutesFromNow = Calendar.current.date(byAdding: .second, value: 10, to: Date())
    let request = BGAppRefreshTaskRequest(identifier: "EditionNotification")
    request.earliestBeginDate = fiveMinutesFromNow
    try? BGTaskScheduler.shared.submit(request)
    print("Test scheduleNotification Done")
}

func scheduleNotification() {
    print("scheduleNotification")
    let today = Calendar.current.startOfDay(for: .now)
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    let noonComponent = DateComponents(hour: 12)
    let noon = Calendar.current.date(byAdding: noonComponent, to: tomorrow)
    let request = BGAppRefreshTaskRequest(identifier: "EditionNotification")
    request.earliestBeginDate = noon
    try? BGTaskScheduler.shared.submit(request)
}

func isCharging() async -> Bool {
    // Check battery state
    let batteryState = await UIDevice.current.batteryState
    return batteryState == .charging || batteryState == .full
}

func testImmediateNotification() {
    print("test strat")
    let content = UNMutableNotificationContent()
    content.title = "Test Notification"
    content.body = "This is a test notification."
    content.sound = .default
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)  // 5 minutes

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
    print("test done")
}



func notifyForEdition() async {
    let content = UNMutableNotificationContent()
    content.title = "Reminder"
    content.body = "Don't forget to edit your activity for yesterday."
    content.sound = .default

    // Trigger the notification immediately for demonstration purposes
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    // Create the request
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // Schedule the notification
    do {
        try await UNUserNotificationCenter.current().add(request)
        print("Notification scheduled.")
    } catch {
        print("Notification failed with error: \(String(describing: error))")
    }
}

func runModelAndSendData() async {
        await withTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
                await trainModel()
            }
            taskGroup.addTask {
                await sendData()
            }
        }
    }

func trainModel() async {
    // Your implementation of trainModel
    print("train")
}

func sendData() async {
    // Your implementation of sendData
    print("send")
}


