//
//  HomePage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/24.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var appState: AppState
    @StateObject var locationmanager = LocationManager()
    @StateObject var motionManager = MotionManager()
    @State var isNotification: Bool = false
    
    var body: some View {
        Group(){
            if !isNotification {
                NotificationPage(isNotification:$isNotification, locationManager:locationmanager, motionManager:motionManager)
                    .onDisappear{
                        self.locationmanager.setupTimer()
                        self.motionManager.setupTimer()
                    }
            } else {
                TabView(){
                    TrackPage()
                        .tabItem { Label("Track",
                                         systemImage: "car") }
                        .toolbarBackground(.white, for: .tabBar)
                    StatisticsPage()
                        .tabItem { Label("Statistics",
                                         systemImage: "chart.bar") }
                        .toolbarBackground(.white, for: .tabBar)
                    CommunityPage()
                        .tabItem { Label("Community",
                                         systemImage: "person.3.fill") }
                        .toolbarBackground(.white, for: .tabBar)
                    SurveyPage()
                        .tabItem { Label("Survey",
                                         systemImage: "bubble") }
                        .toolbarBackground(.white, for: .tabBar)
                    
                    SettingsView()
                        .tabItem {Label("Setting",
                                        systemImage: "gear")}
                        .toolbarBackground(.white, for: .tabBar)
                }
                .accentColor(.primaryColor)
            }
        }
        .onAppear{
            checkNotificationStatus()
        }
    }
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                // Set shouldNotification based on the authorization status
                self.isNotification = (settings.authorizationStatus == .authorized)
                if self.isNotification {
                    print("Notification Privacy is \(appState.privacy)")
                    self.locationmanager.privacy_level = appState.privacy
                    self.motionManager.privacy_level = appState.privacy
                    self.locationmanager.locationManager.startUpdatingLocation()
                    self.locationmanager.locationManager.allowsBackgroundLocationUpdates = true
                    self.locationmanager.locationManager.showsBackgroundLocationIndicator = true
                    self.motionManager.startAccelerometerUpdates()
                    self.locationmanager.setupTimer()
                    self.motionManager.setupTimer()
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
