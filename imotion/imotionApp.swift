//
//  imotionApp.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/14.
//

import SwiftUI
import SwiftData

@main
struct imotionApp: App {
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(AppState.shared)
        }
        .backgroundTask(.appRefresh("EditionNotification")){
            scheduleTestNotification()
            testImmediateNotification()
        }
    }
}
