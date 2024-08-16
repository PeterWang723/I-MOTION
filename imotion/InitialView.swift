//
//  InitialView.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/18.
//

import SwiftUI
import LocalAuthentication

struct InitialView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            if appState.isActive {
                ContentView()  // Transition to the main content view
                    .onAppear{
                        print(UserDefaults.standard.hasScheduledAppRefresh)
                        if UserDefaults.standard.hasScheduledAppRefresh {
                            scheduleTestNotification()
                            UserDefaults.standard.hasScheduledAppRefresh = false
                        }
                        
                    }
            } else {
                Text("I - M O T I O N")
                    .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor) // White background for the entire screen
            }
        }
        .edgesIgnoringSafeArea(.all) // Optional: Ignore safe area to make background truly full-screen
        .onAppear {
            Task {
                if UserDefaults.standard.object(forKey: "WifiOnly") == nil {
                    UserDefaults.standard.set(true, forKey: "WifiOnly")
                }
                let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                let context = LAContext()
                if  token != nil {
                    var error: NSError?
                    appState.privacy = token!["privacyLevel"]!!
                    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                        if UserDefaults.standard.bool(forKey: "faceIDEnabled"){
                            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is for security reason") {
                                success, authenticationError in
                                if success {
                                    DispatchQueue.main.async {
                                        appState.user_token = token!["jwt"]!!
                                        appState.isActive = true
                                        appState.isSuccessfulLoggedIn = true
                                        if token!["houseHold"] != "" {
                                            appState.houseHold = token!["houseHold"]!!
                                            appState.skipSurvey = true
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                        withAnimation {
                                            appState.isActive = true
                                        }
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation {
                                    appState.isActive = true
                                }
                            }
                        }
                    } else {
                        print("There is somthing happend")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                appState.isActive = true
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            appState.isActive = true
                        }
                    }
                }
                print("Task End")
            }
        }
    }
}

extension UserDefaults {
    private enum Keys {
        static let hasScheduledAppRefresh = "hasScheduledAppRefresh"
    }

    var hasScheduledAppRefresh: Bool {
        get {
            return bool(forKey: Keys.hasScheduledAppRefresh)
        }
        set {
            set(newValue, forKey: Keys.hasScheduledAppRefresh)
        }
    }
}

#Preview {
    InitialView()
        .environmentObject(AppState.shared)
}

