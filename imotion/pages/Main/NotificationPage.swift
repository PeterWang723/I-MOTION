//
//  NotificationPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/8.
//

import SwiftUI

struct NotificationPage: View {
    @Binding var isNotification: Bool
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var motionManager: MotionManager
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Text("INSTRUCTION")
            .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
            .fontWeight(.bold)
            .foregroundColor(.primaryColor)
            .padding(.bottom, 30)
        Text("Before we start, Please push this button for us to give your remind to see your everyday traits and edit them")
            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
            .fontWeight(.bold)
            .padding(.top, 40)
            .padding(.horizontal, 50)
            .padding(.bottom, 150.0)
        Button(action: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("Permission denied: \(error.localizedDescription)")
                } else {
                    locationManager.privacy_level = appState.privacy
                    motionManager.privacy_level = appState.privacy
                    locationManager.locationManager.allowsBackgroundLocationUpdates = true
                    locationManager.locationManager.requestAlwaysAuthorization()
                    locationManager.locationManager.startUpdatingLocation()
                    motionManager.startAccelerometerUpdates()
                    isNotification = true
                    scheduleNotification()
                }
            }
        }) {
            Text("ENABLE NOTIFICATION")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 320, height:40)
                .background(
                    RoundedRectangle(
                        cornerRadius: 5,
                        style: .continuous
                    )
                    .fill(Color(red: 0.0, green: 0.0, blue: 180))
                )
        }
        .padding(.bottom, 10)
    }
}
